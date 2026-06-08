import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/overtime_cubit.dart';

class OvertimeApplyPage extends StatefulWidget {
  const OvertimeApplyPage({super.key});

  @override
  State<OvertimeApplyPage> createState() => _OvertimeApplyPageState();
}

class _OvertimeApplyPageState extends State<OvertimeApplyPage> {
  final _reasonCtrl = TextEditingController();
  DateTime? _date;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _error;

  static const _maxHoursPerDay = 4.0;

  double get _calculatedHours {
    if (_startTime == null || _endTime == null) return 0;
    final start =
        _startTime!.hour * 60 + _startTime!.minute;
    final end = _endTime!.hour * 60 + _endTime!.minute;
    if (end <= start) return 0;
    return (end - start) / 60.0;
  }

  bool get _exceedsMax => _calculatedHours > _maxHoursPerDay;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (_startTime ?? const TimeOfDay(hour: 18, minute: 0))
          : (_endTime ?? const TimeOfDay(hour: 20, minute: 0)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _submit() {
    if (_date == null) {
      setState(() => _error = 'Select date');
      return;
    }
    if (_startTime == null || _endTime == null) {
      setState(() => _error = 'Select start and end time');
      return;
    }
    if (_calculatedHours <= 0) {
      setState(() => _error = 'End time must be after start time');
      return;
    }
    if (_reasonCtrl.text.trim().length < 10) {
      setState(() => _error = 'Reason must be at least 10 characters');
      return;
    }

    context.read<OvertimeCubit>().applyOvertime({
      'date': HrmDateUtils.formatApi(_date!),
      'start_time':
          '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}',
      'end_time':
          '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}',
      'hours': _calculatedHours,
      'reason': _reasonCtrl.text.trim(),
    });
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Log Overtime')),
      body: BlocListener<OvertimeCubit, OvertimeState>(
        listener: (ctx, state) {
          if (state is AppliedSuccess) {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(
                content: Text('Overtime logged successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is OvertimeError) {
            setState(() => _error = state.failure.message);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:
                        scheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: scheme.outline.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined),
                      const SizedBox(width: 12),
                      Text(
                        _date != null
                            ? HrmDateUtils.formatDisplay(_date!)
                            : 'Select Date',
                        style: TextStyle(
                          color: _date != null
                              ? scheme.onSurface
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _TimePicker(
                      label: 'Start Time',
                      value: _startTime,
                      onTap: () => _pickTime(true),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _TimePicker(
                      label: 'End Time',
                      value: _endTime,
                      onTap: () => _pickTime(false),
                    ),
                  ),
                ],
              ),
              if (_calculatedHours > 0) ...[
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _exceedsMax
                        ? scheme.errorContainer
                        : scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _exceedsMax
                            ? Icons.warning_amber_rounded
                            : Icons.schedule,
                        color: _exceedsMax
                            ? scheme.onErrorContainer
                            : scheme.onPrimaryContainer,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_calculatedHours.toStringAsFixed(1)} hours'
                        '${_exceedsMax ? ' — exceeds policy max of ${_maxHoursPerDay.toStringAsFixed(0)} hrs/day' : ''}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: _exceedsMax
                              ? scheme.onErrorContainer
                              : scheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _reasonCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Reason',
                  hintText: 'Minimum 10 characters',
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _error!,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: scheme.error),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<OvertimeCubit, OvertimeState>(
                builder: (_, state) => AppButton(
                  label: 'Submit',
                  isLoading: state is OvertimeLoading,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimePicker extends StatelessWidget {
  final String label;
  final TimeOfDay? value;
  final VoidCallback onTap;

  const _TimePicker({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: scheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outline.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value != null ? value!.format(context) : '—',
              style: AppTextStyles.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
