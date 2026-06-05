import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/training_bloc.dart';
import '../bloc/training_event.dart';
import '../bloc/training_state.dart';

class AddTrainingRequestPage extends StatefulWidget {
  const AddTrainingRequestPage({super.key});

  @override
  State<AddTrainingRequestPage> createState() =>
      _AddTrainingRequestPageState();
}

class _AddTrainingRequestPageState extends State<AddTrainingRequestPage> {
  final _formKey          = GlobalKey<FormState>();
  final _titleCtrl        = TextEditingController();
  final _locationCtrl     = TextEditingController();
  final _advanceAmtCtrl   = TextEditingController(text: '0');
  final _narrationCtrl    = TextEditingController();

  DateTime? _dateFrom;
  DateTime? _dateTo;
  DateTime  _focusedDay = DateTime.now();
  String?   _error;

  // 0 = Save as Draft, 1 = Send for Approval
  int _approvalStatus = 1;

  // Training Type options matching the web form
  String? _trainingType;

  int get _totalDays {
    if (_dateFrom == null || _dateTo == null) return 0;
    return _dateTo!.difference(_dateFrom!).inDays + 1;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _advanceAmtCtrl.dispose();
    _narrationCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_dateFrom == null || _dateTo == null) {
      setState(() => _error = 'Please select training dates');
      return;
    }

    context.read<TrainingBloc>().add(
          SubmitTrainingRequest({
            'training_type':     _trainingType ?? '',
            'training_title':    _titleCtrl.text.trim(),
            'training_location': _locationCtrl.text.trim(),
            'advance_amount':
                double.tryParse(_advanceAmtCtrl.text) ?? 0,
            'training_date_from': HrmDateUtils.formatApi(_dateFrom!),
            'training_date_to':   HrmDateUtils.formatApi(_dateTo!),
            'total_days':         _totalDays,
            'main_narration':     _narrationCtrl.text.trim(),
            'approval_status':    _approvalStatus,
            'request_date':       HrmDateUtils.formatApi(DateTime.now()),
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Training Request')),
      body: BlocListener<TrainingBloc, TrainingState>(
        listener: (ctx, state) {
          if (state is TrainingRequestSubmitted) {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(
                content: Text('Training request submitted'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is TrainingError) {
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
                    DropdownMenuItem(
                        value: 0, child: Text('Save as Draft')),
                    DropdownMenuItem(
                        value: 1, child: Text('Send for Approval')),
                  ],
                  onChanged: (v) =>
                      setState(() => _approvalStatus = v ?? 1),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Training Type ─────────────────────────────────
                DropdownButtonFormField<String>(
                  value: _trainingType,
                  decoration: const InputDecoration(
                    labelText: 'Training Type',
                    hintText: 'Select Type',
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'domestic', child: Text('Domestic')),
                    DropdownMenuItem(
                        value: 'foreign', child: Text('Foreign')),
                    DropdownMenuItem(
                        value: 'internal', child: Text('Internal')),
                    DropdownMenuItem(
                        value: 'in-house', child: Text('In-House')),
                  ],
                  onChanged: (v) => setState(() => _trainingType = v),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Training Title ────────────────────────────────
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Training Title *',
                    hintText: 'Enter training title',
                  ),
                  validator: (v) =>
                      Validators.required(v, 'Training Title'),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Training Location ─────────────────────────────
                TextFormField(
                  controller: _locationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Training Location',
                    hintText: 'Enter training location / venue',
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Advance Amount ────────────────────────────────
                TextFormField(
                  controller: _advanceAmtCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Advance Amount',
                    prefixText: 'PKR ',
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Training Dates (calendar range) ───────────────
                Text('Training Dates *',
                    style: AppTextStyles.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                TableCalendar(
                  firstDay: DateTime.now()
                      .subtract(const Duration(days: 365)),
                  lastDay: DateTime.now()
                      .add(const Duration(days: 730)),
                  focusedDay: _focusedDay,
                  rangeStartDay: _dateFrom,
                  rangeEndDay: _dateTo,
                  rangeSelectionMode: RangeSelectionMode.enforced,
                  calendarFormat: CalendarFormat.month,
                  onRangeSelected: (start, end, focused) {
                    setState(() {
                      _dateFrom    = start;
                      _dateTo      = end;
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

                // ── Total Training Days (read-only) ───────────────
                if (_dateFrom != null && _dateTo != null) ...[
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
                            '${HrmDateUtils.formatDisplay(_dateFrom!)} – ${HrmDateUtils.formatDisplay(_dateTo!)}',
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
                              'Total Training Days',
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

                // ── Narration / Remarks ───────────────────────────
                TextFormField(
                  controller: _narrationCtrl,
                  maxLines: 4,
                  maxLength: 2000,
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
                BlocBuilder<TrainingBloc, TrainingState>(
                  builder: (_, state) => AppButton(
                    label: 'Submit Training Request',
                    isLoading: state is TrainingLoading,
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
