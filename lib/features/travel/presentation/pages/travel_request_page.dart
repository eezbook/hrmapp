import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/travel_bloc.dart';
import '../bloc/travel_event.dart';
import '../bloc/travel_state.dart';

class TravelRequestPage extends StatefulWidget {
  const TravelRequestPage({super.key});

  @override
  State<TravelRequestPage> createState() => _TravelRequestPageState();
}

class _TravelRequestPageState extends State<TravelRequestPage> {
  final _formKey          = GlobalKey<FormState>();
  final _purposeCtrl      = TextEditingController();
  final _travelFromCtrl   = TextEditingController();
  final _destinationCtrl  = TextEditingController();
  final _vehicleInfoCtrl  = TextEditingController();
  final _budgetCtrl       = TextEditingController();
  final _narrationCtrl    = TextEditingController();
  final _noOfPersonsCtrl  = TextEditingController(text: '0');

  // Visitor names repeater
  final List<TextEditingController> _visitorCtrls = [];

  DateTime? _departure;
  DateTime? _returnDate;
  DateTime  _focusedDay = DateTime.now();
  String?   _error;

  // 0 = Save as Draft, 1 = Send for Approval
  int _approvalStatus = 1;

  // 'local' = domestic, 'foreign' = international
  String _typeOfVisit = 'local';

  // TODO: future — Advance Payment / Advance Amount
  // Requires backend update to HrmMobileTravelController::travelStore()
  // to accept: advance_payment (0/1), advance_amount (decimal).
  // bool _advancePayment = false;
  // final _advanceAmountCtrl = TextEditingController();

  int get _totalDays {
    if (_departure == null) return 0;
    final end = _returnDate ?? _departure!;
    return end.difference(_departure!).inDays + 1;
  }

  @override
  void dispose() {
    _purposeCtrl.dispose();
    _travelFromCtrl.dispose();
    _destinationCtrl.dispose();
    _vehicleInfoCtrl.dispose();
    _budgetCtrl.dispose();
    _narrationCtrl.dispose();
    _noOfPersonsCtrl.dispose();
    for (final c in _visitorCtrls) {
      c.dispose();
    }
    // TODO: future — _advanceAmountCtrl.dispose();
    super.dispose();
  }

  void _addVisitor() {
    setState(() => _visitorCtrls.add(TextEditingController()));
  }

  void _removeVisitor(int index) {
    _visitorCtrls[index].dispose();
    setState(() => _visitorCtrls.removeAt(index));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_departure == null) {
      setState(() => _error = 'Please select departure date');
      return;
    }

    final effectiveReturn = _returnDate ?? _departure!;

    context.read<TravelBloc>().add(
          CreateTravelRequest({
            'purpose':          _purposeCtrl.text.trim(),
            'origin':           _travelFromCtrl.text.trim(),
            'destination':      _destinationCtrl.text.trim(),
            'destination_type': _typeOfVisit == 'foreign'
                ? 'international'
                : 'domestic',
            'departure_date':   HrmDateUtils.formatApi(_departure!),
            'return_date':      HrmDateUtils.formatApi(effectiveReturn),
            'total_days':       _totalDays,
            'transport_mode':   _vehicleInfoCtrl.text.trim(),
            'no_of_persons':    int.tryParse(_noOfPersonsCtrl.text) ?? 0,
            'visitor_names':    jsonEncode(
                _visitorCtrls.map((c) => c.text.trim()).toList()),
            'estimated_budget': double.tryParse(
                    _budgetCtrl.text.replaceAll(',', '')) ??
                0,
            'notes':            _narrationCtrl.text.trim(),
            'request_date':     HrmDateUtils.formatApi(DateTime.now()),
            'approval_status':  _approvalStatus,
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('New Travel Request')),
      body: BlocListener<TravelBloc, TravelState>(
        listener: (ctx, state) {
          if (state is TravelRequestCreated) {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(
                content: Text('Travel request submitted'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is TravelError) {
            setState(() => _error = state.failure.message);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Approval Status ───────────────────────────────
                DropdownButtonFormField<int>(
                  value: _approvalStatus,
                  decoration: const InputDecoration(
                    labelText: 'Approval Status',
                  ),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Save as Draft')),
                    DropdownMenuItem(
                        value: 1, child: Text('Send for Approval')),
                  ],
                  onChanged: (v) =>
                      setState(() => _approvalStatus = v ?? 1),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Type of Visit ─────────────────────────────────
                DropdownButtonFormField<String>(
                  value: _typeOfVisit,
                  decoration: const InputDecoration(
                    labelText: 'Type of Visit',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'local', child: Text('Local')),
                    DropdownMenuItem(
                        value: 'foreign', child: Text('Foreign')),
                  ],
                  onChanged: (v) =>
                      setState(() => _typeOfVisit = v ?? 'local'),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Purpose of Journey ────────────────────────────
                TextFormField(
                  controller: _purposeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Purpose of Journey',
                    hintText: 'Enter purpose of journey',
                  ),
                  validator: (v) => Validators.required(v, 'Purpose'),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Travel From ───────────────────────────────────
                TextFormField(
                  controller: _travelFromCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Travel From',
                    hintText: 'Origin / departure location',
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Travel To (Destination) ───────────────────────
                TextFormField(
                  controller: _destinationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Travel To',
                    hintText: 'Destination',
                  ),
                  validator: (v) =>
                      Validators.required(v, 'Travel To'),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Travel Dates (calendar range picker) ─────────
                Text('Travel Dates', style: AppTextStyles.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now()
                      .add(const Duration(days: 730)),
                  focusedDay: _focusedDay,
                  rangeStartDay: _departure,
                  rangeEndDay: _returnDate,
                  rangeSelectionMode: RangeSelectionMode.enforced,
                  calendarFormat: CalendarFormat.month,
                  onRangeSelected: (start, end, focused) {
                    setState(() {
                      _departure   = start;
                      _returnDate  = end;
                      _focusedDay  = focused;
                      _error       = null;
                    });
                  },
                  onPageChanged: (f) =>
                      setState(() => _focusedDay = f),
                  calendarStyle: CalendarStyle(
                    rangeHighlightColor:
                        scheme.primary.withOpacity(0.2),
                    rangeStartDecoration: BoxDecoration(
                      color: scheme.primary,
                      shape: BoxShape.circle,
                    ),
                    rangeEndDecoration: BoxDecoration(
                      color: scheme.primary,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: scheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // ── Total Traveling Days (read-only) ──────────────
                if (_departure != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            () {
                              final end = _returnDate ?? _departure!;
                              final start = HrmDateUtils.formatDisplay(_departure!);
                              final endStr = HrmDateUtils.formatDisplay(end);
                              return start == endStr ? start : '$start – $endStr';
                            }(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: scheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$_totalDays day(s)',
                              style: AppTextStyles.titleSmall.copyWith(
                                color: scheme.onPrimaryContainer,
                              ),
                            ),
                            Text(
                              'Total Traveling Days',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: scheme.onPrimaryContainer,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.md),

                // ── Vehicle Info ──────────────────────────────────
                TextFormField(
                  controller: _vehicleInfoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Info',
                    hintText: 'Enter vehicle information',
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── No. of Persons ────────────────────────────────
                TextFormField(
                  controller: _noOfPersonsCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    labelText: 'No. of Persons',
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Visitor Names (repeater) ──────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Visitor Names',
                        style: AppTextStyles.titleSmall),
                    TextButton.icon(
                      onPressed: _addVisitor,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Visitor'),
                    ),
                  ],
                ),

                if (_visitorCtrls.isEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      'No visitors added yet.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),

                ...List.generate(_visitorCtrls.length, (i) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _visitorCtrls[i],
                            decoration: InputDecoration(
                              labelText: 'Visitor ${i + 1}',
                              hintText: 'Enter visitor name',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _removeVisitor(i),
                          icon: Icon(Icons.remove_circle_outline,
                              color: scheme.error),
                          tooltip: 'Remove',
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: AppSpacing.md),

                // ── Estimated Budget ──────────────────────────────
                TextFormField(
                  controller: _budgetCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Estimated Budget',
                    prefixText: 'PKR ',
                  ),
                  validator: Validators.amount,
                ),

                const SizedBox(height: AppSpacing.md),

                // TODO: future — Advance Payment + Advance Amount
                // Requires backend update to accept advance_payment (0/1)
                // and advance_amount (decimal, shown conditionally).

                // ── Narration / Remarks ───────────────────────────
                TextFormField(
                  controller: _narrationCtrl,
                  maxLines: 4,
                  maxLength: 1000,
                  decoration: const InputDecoration(
                    labelText: 'Narration / Remarks',
                    hintText: 'Enter remarks or narration...',
                    alignLabelWithHint: true,
                  ),
                ),

                // ── Error ─────────────────────────────────────────
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: scheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color: scheme.onErrorContainer, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: scheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.md),

                // ── Submit ────────────────────────────────────────
                BlocBuilder<TravelBloc, TravelState>(
                  builder: (_, state) => AppButton(
                    label: 'Submit Request',
                    isLoading: state is TravelLoading,
                    onPressed: _submit,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
