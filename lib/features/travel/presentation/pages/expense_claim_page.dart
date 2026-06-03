import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/datasources/travel_remote_datasource.dart';
import '../../data/models/expense_claim_model.dart';
import '../bloc/travel_bloc.dart';
import '../bloc/travel_event.dart';
import '../bloc/travel_state.dart';

class _DraftItem {
  final String category;
  final String description;
  double amount;
  DateTime date;
  XFile? receiptFile;
  String? uploadedReceiptUrl;
  bool uploading;
  bool requiresReceipt;

  _DraftItem({
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    this.receiptFile,
    this.uploadedReceiptUrl,
    this.uploading = false,
    this.requiresReceipt = false,
  });
}

class ExpenseClaimPage extends StatefulWidget {
  final int? travelRequestId;

  const ExpenseClaimPage({super.key, this.travelRequestId});

  @override
  State<ExpenseClaimPage> createState() => _ExpenseClaimPageState();
}

class _ExpenseClaimPageState extends State<ExpenseClaimPage> {
  final _formKey = GlobalKey<FormState>();
  final _categoryCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  List<ExpenseCategoryModel> _categories = [];
  ExpenseCategoryModel? _selectedCategory;
  DateTime _itemDate = DateTime.now();
  final List<_DraftItem> _items = [];
  int? _claimId;
  bool _loadingCategories = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _createClaim();
  }

  Future<void> _loadCategories() async {
    try {
      final res =
          await getIt<TravelRemoteDataSource>().getCategories();
      setState(() {
        _categories = res.data ?? [];
        if (_categories.isNotEmpty) _selectedCategory = _categories.first;
        _loadingCategories = false;
      });
    } catch (_) {
      setState(() => _loadingCategories = false);
    }
  }

  Future<void> _createClaim() async {
    try {
      final res = await getIt<TravelRemoteDataSource>().createClaim({
        'title': 'Expense Claim',
        if (widget.travelRequestId != null)
          'travel_request_id': widget.travelRequestId,
      });
      setState(() => _claimId = res.data?.id);
    } catch (_) {}
  }

  double get _total =>
      _items.fold(0.0, (sum, i) => sum + i.amount);

  Future<void> _addItem() async {
    if (_selectedCategory == null) return;
    final amount =
        double.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0;
    if (amount <= 0) return;

    final item = _DraftItem(
      category: _selectedCategory!.name,
      description: _descCtrl.text.trim(),
      amount: amount,
      date: _itemDate,
      requiresReceipt: _selectedCategory!.requiresReceipt,
    );
    setState(() {
      _items.add(item);
      _descCtrl.clear();
      _amountCtrl.clear();
    });
  }

  Future<void> _uploadReceipt(_DraftItem item) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    setState(() {
      item.receiptFile = file;
      item.uploading = true;
    });

    try {
      final multipart = await MultipartFile.fromFile(
        file.path,
        filename: file.name,
      );
      final res = await getIt<TravelRemoteDataSource>()
          .uploadReceipt(_claimId!, multipart);
      setState(() {
        item.uploadedReceiptUrl = res.data?['url'];
        item.uploading = false;
      });
    } catch (_) {
      setState(() => item.uploading = false);
    }
  }

  Future<void> _submit() async {
    final unattached = _items
        .where((i) => i.requiresReceipt && i.uploadedReceiptUrl == null)
        .toList();
    if (unattached.isNotEmpty) {
      setState(
          () => _error = 'Upload receipts for all required items first');
      return;
    }
    if (_claimId == null) {
      setState(() => _error = 'Failed to create claim. Try again.');
      return;
    }
    context.read<TravelBloc>().add(SubmitExpenseClaim(_claimId!));
  }

  @override
  void dispose() {
    _categoryCtrl.dispose();
    _descCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Claim')),
      body: BlocListener<TravelBloc, TravelState>(
        listener: (ctx, state) {
          if (state is ExpenseSubmitted) {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(
                content: Text('Claim submitted'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is TravelError) {
            setState(() => _error = state.failure.message);
          }
        },
        child: _loadingCategories
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add item form
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                children: [
                                  DropdownButtonFormField<
                                      ExpenseCategoryModel>(
                                    value: _selectedCategory,
                                    decoration: const InputDecoration(
                                      labelText: 'Category',
                                    ),
                                    items: _categories
                                        .map((c) => DropdownMenuItem(
                                              value: c,
                                              child: Text(c.name),
                                            ))
                                        .toList(),
                                    onChanged: (v) => setState(
                                        () => _selectedCategory = v),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _descCtrl,
                                    decoration: const InputDecoration(
                                        labelText: 'Description'),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _amountCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Amount',
                                      prefixText: 'PKR ',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: _addItem,
                                      icon: const Icon(Icons.add),
                                      label: const Text('Add Item'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Items list
                          if (_items.isNotEmpty) ...[
                            Text('Items', style: AppTextStyles.titleSmall),
                            const SizedBox(height: AppSpacing.sm),
                            ..._items.map((item) => Dismissible(
                                  key: Key(
                                      '${item.category}_${item.amount}'),
                                  direction: item.isPerDiem
                                      ? DismissDirection.none
                                      : DismissDirection.endToStart,
                                  background: Container(
                                    color: scheme.error,
                                    alignment: Alignment.centerRight,
                                    padding:
                                        const EdgeInsets.only(right: 16),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  onDismissed: (_) =>
                                      setState(() => _items.remove(item)),
                                  child: Card(
                                    child: ListTile(
                                      title: Text(item.description.isEmpty
                                          ? item.category
                                          : item.description),
                                      subtitle: Text(
                                          '${item.category} · ${HrmDateUtils.formatDisplay(item.date)}'),
                                      trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            CurrencyUtils.formatPkr(
                                                item.amount),
                                            style:
                                                AppTextStyles.titleSmall,
                                          ),
                                          if (item.requiresReceipt) ...[
                                            if (item.uploading)
                                              const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2),
                                              )
                                            else if (item
                                                    .uploadedReceiptUrl !=
                                                null)
                                              const Icon(Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 18)
                                            else
                                              GestureDetector(
                                                onTap: () =>
                                                    _uploadReceipt(item),
                                                child: Text(
                                                  'Upload receipt',
                                                  style:
                                                      AppTextStyles.labelSmall
                                                          .copyWith(
                                                    color: scheme.error,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // Total + Submit
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total',
                                style: AppTextStyles.titleSmall),
                            Text(CurrencyUtils.formatPkr(_total),
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: scheme.primary,
                                )),
                          ],
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 8),
                          Text(_error!,
                              style: TextStyle(color: scheme.error)),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        BlocBuilder<TravelBloc, TravelState>(
                          builder: (_, state) => AppButton(
                            label: 'Submit Claim',
                            isLoading: state is TravelLoading,
                            onPressed: _items.isEmpty ? null : _submit,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

extension on _DraftItem {
  bool get isPerDiem => false;
}
