import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/datasources/travel_remote_datasource.dart';
import '../../data/models/expense_claim_model.dart';
import '../bloc/travel_bloc.dart';
import '../bloc/travel_event.dart';
import '../bloc/travel_state.dart';

// ─── Local draft item (UI only, no backend calls) ─────────────────────────────
class _DraftItem {
  ExpenseCategoryModel category;
  String description;
  double amount;
  DateTime date;
  XFile? receiptFile;
  String? uploadedReceiptUrl;
  bool uploading;

  _DraftItem({
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    this.receiptFile,
    this.uploadedReceiptUrl,
    this.uploading = false,
  });
}

class ExpenseClaimPage extends StatefulWidget {
  final int? travelRequestId;
  const ExpenseClaimPage({super.key, this.travelRequestId});

  @override
  State<ExpenseClaimPage> createState() => _ExpenseClaimPageState();
}

class _ExpenseClaimPageState extends State<ExpenseClaimPage> {
  // ── Claim header ────────────────────────────────────────────────────────────
  final _titleCtrl = TextEditingController(text: 'Expense Claim');
  final _notesCtrl = TextEditingController();
  DateTime _claimDate = DateTime.now();
  String _status = 'pending'; // 'draft' | 'pending'

  // ── Per-item add form ───────────────────────────────────────────────────────
  final _amountCtrl = TextEditingController();
  final _descCtrl   = TextEditingController();
  DateTime _itemDate = DateTime.now();
  ExpenseCategoryModel? _selectedCategory;

  // ── Data ────────────────────────────────────────────────────────────────────
  List<ExpenseCategoryModel> _categories       = [];
  final List<_DraftItem>     _items            = [];
  bool   _loadingCategories = true;
  bool   _submitting        = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // ── Category loader ─────────────────────────────────────────────────────────
  Future<void> _loadCategories() async {
    try {
      final res = await getIt<TravelRemoteDataSource>().getCategories();
      setState(() {
        _categories = res.data ?? [];
        if (_categories.isNotEmpty) _selectedCategory = _categories.first;
        _loadingCategories = false;
      });
    } catch (_) {
      setState(() => _loadingCategories = false);
    }
  }

  double get _total => _items.fold(0.0, (s, i) => s + i.amount);

  // ── Date pickers ─────────────────────────────────────────────────────────────
  Future<void> _pickClaimDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _claimDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate:  DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _claimDate = picked);
  }

  Future<void> _pickItemDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _itemDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate:  DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _itemDate = picked);
  }

  // ── Add / remove item (purely local — no backend call) ──────────────────────
  void _addItem() {
    if (_selectedCategory == null) {
      setState(() => _error = 'Please select a category');
      return;
    }
    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0;
    if (amount <= 0) {
      setState(() => _error = 'Enter a valid amount greater than 0');
      return;
    }

    setState(() {
      _items.add(_DraftItem(
        category:    _selectedCategory!,
        description: _descCtrl.text.trim(),
        amount:      amount,
        date:        _itemDate,
      ));
      _amountCtrl.clear();
      _descCtrl.clear();
      _error = null;
    });
  }

  void _removeItem(int index) => setState(() => _items.removeAt(index));

  // ── Receipt upload (only after claim is created on backend) ─────────────────
  Future<void> _uploadReceipt(_DraftItem item, int claimId) async {
    final picker = ImagePicker();
    final file   = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    setState(() {
      item.receiptFile = file;
      item.uploading   = true;
    });
    try {
      final mp  = await MultipartFile.fromFile(file.path, filename: file.name);
      final res = await getIt<TravelRemoteDataSource>().uploadReceipt(claimId, mp);
      setState(() {
        item.uploadedReceiptUrl = res.data?['url'];
        item.uploading          = false;
      });
    } catch (_) {
      setState(() => item.uploading = false);
    }
  }

  // ── Submit: create claim → add items → submit ────────────────────────────────
  Future<void> _submit() async {
    if (_items.isEmpty) {
      setState(() => _error = 'Add at least one expense item');
      return;
    }
    setState(() { _submitting = true; _error = null; });

    try {
      // 1. Create the claim
      final claimRes = await getIt<TravelRemoteDataSource>().createClaim({
        'title':      _titleCtrl.text.trim().isEmpty
            ? 'Expense Claim'
            : _titleCtrl.text.trim(),
        'claim_date': HrmDateUtils.formatApi(_claimDate),
        'notes':      _notesCtrl.text.trim(),
        'status':     'draft',
        if (widget.travelRequestId != null)
          'travel_request_id': widget.travelRequestId,
      });
      final claimId = claimRes.data?.id;
      if (claimId == null) throw Exception('Could not create claim');

      // 2. Add each item to the claim
      for (final item in _items) {
        await getIt<TravelRemoteDataSource>().addExpenseItem(claimId, {
          'expense_category_id': item.category.id,
          'expense_date':        HrmDateUtils.formatApi(item.date),
          'amount':              item.amount,
          'description':         item.description,
        });
      }

      // 3. Submit or keep as draft
      if (_status == 'pending') {
        if (!mounted) return;
        context.read<TravelBloc>().add(SubmitExpenseClaim(claimId));
      } else {
        if (!mounted) return;
        setState(() => _submitting = false);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Claim saved as draft'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _submitting = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
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
                content: Text('Claim submitted for approval'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is TravelError) {
            setState(() {
              _submitting = false;
              _error = state.failure.message;
            });
          }
        },
        child: _loadingCategories
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // ── Scrollable body ───────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // ── Claim header card ─────────────────────
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Claim Details',
                                      style: AppTextStyles.titleSmall),
                                  const SizedBox(height: AppSpacing.sm),

                                  // Status
                                  DropdownButtonFormField<String>(
                                    value: _status,
                                    decoration: const InputDecoration(
                                        labelText: 'Status'),
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'draft',
                                          child: Text('Save as Draft')),
                                      DropdownMenuItem(
                                          value: 'pending',
                                          child: Text('Submit for Approval')),
                                    ],
                                    onChanged: (v) => setState(
                                        () => _status = v ?? 'pending'),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),

                                  // Claim Title
                                  TextFormField(
                                    controller: _titleCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Claim Title *',
                                      hintText:
                                          'e.g. Business Trip — May 2026',
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),

                                  // Claim Date
                                  InkWell(
                                    onTap: _pickClaimDate,
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        labelText: 'Claim Date',
                                        suffixIcon: Icon(
                                            Icons.calendar_today,
                                            size: 18),
                                      ),
                                      child: Text(
                                        HrmDateUtils.formatDisplay(
                                            _claimDate),
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),

                                  // Notes
                                  TextFormField(
                                    controller: _notesCtrl,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      labelText: 'Notes / Remarks',
                                      hintText:
                                          'Optional notes or remarks...',
                                      alignLabelWithHint: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSpacing.md),

                          // ── Items repeater ────────────────────────
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text('Expense Items',
                                            style:
                                                AppTextStyles.titleSmall),
                                      ),
                                      if (_items.isNotEmpty)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: scheme.primaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${_items.length} item${_items.length == 1 ? '' : 's'}',
                                            style: AppTextStyles.labelSmall
                                                .copyWith(
                                              color:
                                                  scheme.onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const Divider(height: 20),

                                  // ── Existing rows ─────────────────
                                  if (_items.isNotEmpty) ...[
                                    // Column headers
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 4, left: 4, right: 4),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 3,
                                              child: Text('Category',
                                                  style: AppTextStyles
                                                      .labelSmall
                                                      .copyWith(
                                                          color: scheme
                                                              .onSurfaceVariant))),
                                          Expanded(
                                              flex: 2,
                                              child: Text('Date',
                                                  style: AppTextStyles
                                                      .labelSmall
                                                      .copyWith(
                                                          color: scheme
                                                              .onSurfaceVariant))),
                                          Expanded(
                                              flex: 2,
                                              child: Text('Amount',
                                                  textAlign: TextAlign.end,
                                                  style: AppTextStyles
                                                      .labelSmall
                                                      .copyWith(
                                                          color: scheme
                                                              .onSurfaceVariant))),
                                          const SizedBox(width: 32),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    ...List.generate(_items.length, (i) {
                                      final item = _items[i];
                                      return Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 6),
                                        decoration: BoxDecoration(
                                          color: scheme.surfaceContainerLow,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      item.category.name,
                                                      style: AppTextStyles
                                                          .bodySmall
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      HrmDateUtils
                                                          .formatDisplay(
                                                              item.date),
                                                      style: AppTextStyles
                                                          .bodySmall,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      CurrencyUtils
                                                          .formatPkr(
                                                              item.amount),
                                                      textAlign:
                                                          TextAlign.end,
                                                      style: AppTextStyles
                                                          .bodySmall
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: scheme
                                                                  .primary),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () =>
                                                        _removeItem(i),
                                                    icon: Icon(
                                                        Icons.close_rounded,
                                                        size: 18,
                                                        color: scheme.error),
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        const BoxConstraints(
                                                            minWidth: 32,
                                                            minHeight: 32),
                                                  ),
                                                ],
                                              ),
                                              if (item.description
                                                  .isNotEmpty) ...[
                                                const SizedBox(height: 2),
                                                Text(
                                                  item.description,
                                                  style: AppTextStyles
                                                      .bodySmall
                                                      .copyWith(
                                                          color: scheme
                                                              .onSurfaceVariant),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                    const Divider(height: 16),
                                  ],

                                  // ── Add new row ───────────────────
                                  Text('Add Item',
                                      style: AppTextStyles.labelSmall
                                          .copyWith(
                                              color: scheme.primary,
                                              fontWeight: FontWeight.w600)),
                                  const SizedBox(height: AppSpacing.sm),

                                  // Category
                                  DropdownButtonFormField<
                                      ExpenseCategoryModel>(
                                    value: _selectedCategory,
                                    decoration: const InputDecoration(
                                        labelText: 'Category *'),
                                    items: _categories
                                        .map((c) => DropdownMenuItem(
                                              value: c,
                                              child: Text(c.name),
                                            ))
                                        .toList(),
                                    onChanged: (v) => setState(
                                        () => _selectedCategory = v),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),

                                  // Date
                                  InkWell(
                                    onTap: _pickItemDate,
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        labelText: 'Date *',
                                        suffixIcon: Icon(
                                            Icons.calendar_today,
                                            size: 18),
                                      ),
                                      child: Text(
                                        HrmDateUtils.formatDisplay(
                                            _itemDate),
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),

                                  // Amount
                                  TextFormField(
                                    controller: _amountCtrl,
                                    keyboardType: const TextInputType
                                        .numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*')),
                                    ],
                                    decoration: const InputDecoration(
                                      labelText: 'Amount *',
                                      prefixText: 'PKR ',
                                      hintText: '0.00',
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),

                                  // Description
                                  TextFormField(
                                    controller: _descCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Description',
                                      hintText: 'Optional...',
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),

                                  // Add button
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: _addItem,
                                      icon: const Icon(Icons.add, size: 18),
                                      label: const Text('Add Item'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Sticky bottom bar ─────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Amount',
                                style: AppTextStyles.titleSmall),
                            Text(
                              CurrencyUtils.formatPkr(_total),
                              style: AppTextStyles.titleMedium.copyWith(
                                color: scheme.primary,
                              ),
                            ),
                          ],
                        ),
                        // Error
                        if (_error != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: scheme.errorContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    color: scheme.onErrorContainer,
                                    size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _error!,
                                    style: AppTextStyles.bodySmall.copyWith(
                                        color: scheme.onErrorContainer),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.sm),
                        BlocBuilder<TravelBloc, TravelState>(
                          builder: (_, state) => AppButton(
                            label: _status == 'draft'
                                ? 'Save as Draft'
                                : 'Submit for Approval',
                            isLoading:
                                _submitting || state is TravelLoading,
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
