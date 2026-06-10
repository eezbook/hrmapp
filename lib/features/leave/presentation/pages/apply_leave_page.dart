import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/datasources/leave_remote_datasource.dart';
import '../../data/models/leave_balance_model.dart';
import '../../data/models/leave_type_model.dart';
import '../bloc/leave_bloc.dart';
import '../bloc/leave_event.dart';
import '../bloc/leave_state.dart';

class ApplyLeavePage extends StatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  State<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonCtrl = TextEditingController();

  List<LeaveTypeModel> _leaveTypes = [];
  List<LeaveBalanceModel> _balances = [];
  LeaveTypeModel? _selectedType;
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _focusedDay = DateTime.now();

  // 0 = Full Day, 1 = 1st Half, 2 = 2nd Half
  int _dayType = 0;

  // 0 = Save as Draft, 1 = Send for Approval
  int _approvalStatus = 1;

  static const List<String> _narrationSuggestions = [
    'Feeling unwell / sick',
    'Medical appointment',
    'Family emergency',
    'Personal work',
    'Out of town / travel',
    'Child care duty',
    'Urgent household matter',
    'Religious observance',
    'Wedding / family function',
    'Rest and recovery',
    'Mental health day',
    'Home maintenance / repair',
  ];

  // TODO: future — backup employee support (requires employee search API endpoint
  // and backend update to HrmMobileLeaveController::apply() to accept backup_employee_id)
  // final _backupEmployeeCtrl = TextEditingController();
  // int? _backupEmployeeId;

  List<String> _holidays = [];
  bool _loadingTypes = true;
  String? _error;
  // True while the first tap of a range has been registered but the user
  // hasn't confirmed end date yet. Keeps the calendar in "open range" state
  // so a second tap can either confirm same-day or extend to a range.
  bool _awaitingRangeEnd = false;

  bool get _isSingleDay =>
      _startDate != null &&
      _endDate != null &&
      isSameDay(_startDate!, _endDate!);

  bool get _isHalfDay => _dayType != 0;

  double get _calculatedDays {
    if (_startDate == null || _endDate == null) return 0;
    if (_isHalfDay) return 0.5;
    return HrmDateUtils.workingDaysBetween(_startDate!, _endDate!).toDouble();
  }

  double? get _selectedBalance {
    if (_selectedType == null) return null;
    try {
      return _balances
          .firstWhere((b) => b.id == _selectedType!.id)
          .remaining;
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final ds = getIt<LeaveRemoteDataSource>();

    // Run all three calls in parallel. Each handles its own error so a failure
    // in one (e.g. no holiday calendar data) does not blank out the others.
    List<LeaveTypeModel> types = [];
    List<String> holidays = [];
    List<LeaveBalanceModel> balances = [];

    await Future.wait([
      ds
          .getLeaveTypes()
          .then((r) => types = r.data ?? [])
          .catchError((_) {}),
      ds
          .getPublicHolidays()
          .then((r) => holidays = r.data ?? [])
          .catchError((_) {}),
      ds
          .getBalance()
          .then((r) => balances = r.data ?? [])
          .catchError((_) {}),
    ]);

    setState(() {
      _leaveTypes = types;
      _holidays = holidays;
      _balances = balances;
      if (_leaveTypes.isNotEmpty) _selectedType = _leaveTypes.first;
      _loadingTypes = false;
      if (_leaveTypes.isEmpty) {
        _error = 'No leave types found. Please contact your administrator.';
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      setState(() => _error = 'Please select leave dates');
      return;
    }
    if (_isHalfDay && !_isSingleDay) {
      setState(() => _error = '1st/2nd half leave must be for a single day only');
      return;
    }
    if (_calculatedDays == 0) {
      setState(() => _error = 'Selected date range contains no working days');
      return;
    }

    context.read<LeaveBloc>().add(ApplyLeave({
          'leave_type_id': _selectedType!.id,
          'start_date': HrmDateUtils.formatApi(_startDate!),
          'end_date': HrmDateUtils.formatApi(_endDate!),
          'is_half_day': _isHalfDay,
          if (_isHalfDay)
            'half_day_session': _dayType == 2 ? 'afternoon' : 'morning',
          'reason': _reasonCtrl.text.trim(),
          'request_date': HrmDateUtils.formatApi(DateTime.now()),
          'approval_status': _approvalStatus,
          // TODO: future — 'backup_employee_id': _backupEmployeeId,
        }));
  }

  String _dayTypeLabel(int type) {
    switch (type) {
      case 1:
        return '1st Half';
      case 2:
        return '2nd Half';
      default:
        return 'Full Day';
    }
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    // TODO: future — _backupEmployeeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Apply for Leave')),
      body: BlocListener<LeaveBloc, LeaveState>(
        listener: (ctx, state) {
          if (state is AppliedSuccess) {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(
                content: Text('Leave applied successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is LeaveApplyOfflineQueued) {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.amber.shade700,
              ),
            );
          } else if (state is LeaveError) {
            setState(() => _error = state.failure.message);
          }
        },
        child: _loadingTypes
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TODO: future — Backup Employee field
                      // Requires: employee search API endpoint + backend update
                      // to HrmMobileLeaveController::apply() to accept backup_employee_id.
                      //
                      // TextFormField(
                      //   controller: _backupEmployeeCtrl,
                      //   decoration: const InputDecoration(
                      //     labelText: 'Backup Employee (optional)',
                      //     hintText: 'Search employee...',
                      //   ),
                      // ),
                      // const SizedBox(height: AppSpacing.md),

                      // ── Leave Type + Balance ──────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<LeaveTypeModel>(
                              value: _selectedType,
                              decoration: const InputDecoration(
                                labelText: 'Leave Type',
                              ),
                              items: _leaveTypes
                                  .map((t) => DropdownMenuItem(
                                        value: t,
                                        child: Text(t.name),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() {
                                _selectedType = v;
                                _dayType = 0;
                              }),
                              validator: (v) =>
                                  v == null ? 'Select a leave type' : null,
                            ),
                          ),
                          if (_selectedBalance != null) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: scheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    _selectedBalance!.toStringAsFixed(1),
                                    style: AppTextStyles.titleSmall.copyWith(
                                      color: scheme.onPrimaryContainer,
                                    ),
                                  ),
                                  Text(
                                    'Balance',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: scheme.onPrimaryContainer,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // ── Date Picker ───────────────────────────────
                      Text('Select Dates', style: AppTextStyles.titleSmall),
                      const SizedBox(height: AppSpacing.sm),
                      TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now()
                            .add(const Duration(days: 365)),
                        focusedDay: _focusedDay,
                        rangeStartDay: _startDate,
                        // Pass null while awaiting second tap so the calendar
                        // remains in "open range" mode and can still extend.
                        rangeEndDay: _awaitingRangeEnd ? null : _endDate,
                        rangeSelectionMode: _isHalfDay
                            ? RangeSelectionMode.disabled
                            : RangeSelectionMode.enforced,
                        calendarFormat: CalendarFormat.month,
                        selectedDayPredicate: _isHalfDay
                            ? (d) => isSameDay(d, _startDate)
                            : null,
                        enabledDayPredicate: (day) {
                          if (day.weekday == DateTime.saturday ||
                              day.weekday == DateTime.sunday) return false;
                          if (_holidays.contains(
                              HrmDateUtils.formatApi(day))) return false;
                          return true;
                        },
                        onRangeSelected: _isHalfDay
                            ? null
                            : (start, end, focused) {
                                setState(() {
                                  _focusedDay = focused;
                                  _dayType = 0;
                                  if (end == null) {
                                    // First tap: immediately treat as single-day
                                    // selection. Keep _awaitingRangeEnd = true so
                                    // the calendar stays open for a second tap that
                                    // can extend into a multi-day range.
                                    _startDate = start;
                                    _endDate = start;
                                    _awaitingRangeEnd = true;
                                  } else {
                                    // Second tap: range or same-day confirmed.
                                    _startDate = start;
                                    _endDate = end;
                                    _awaitingRangeEnd = false;
                                    // Half-day only valid for a single day.
                                    if (!isSameDay(start, end)) {
                                      _dayType = 0;
                                    }
                                  }
                                });
                              },
                        onDaySelected: _isHalfDay
                            ? (selected, focused) => setState(() {
                                  _startDate = selected;
                                  _endDate = selected;
                                  _focusedDay = focused;
                                })
                            : null,
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

                      // ── Date Summary + Total Days ─────────────────
                      if (_startDate != null) ...[
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
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _isHalfDay
                                          ? '${_dayTypeLabel(_dayType)} on ${HrmDateUtils.formatDisplay(_startDate!)}'
                                          : '${HrmDateUtils.formatDisplay(_startDate!)} – ${HrmDateUtils.formatDisplay(_endDate ?? _startDate!)}',
                                      style: AppTextStyles.bodySmall
                                          .copyWith(
                                        color: scheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${_calculatedDays.toStringAsFixed(1)} day(s)',
                                    style: AppTextStyles.titleSmall
                                        .copyWith(
                                      color: scheme.onPrimaryContainer,
                                    ),
                                  ),
                                  Text(
                                    'Total Days',
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

                      // ── Day Type (only for single-day selection) ──
                      if (_isSingleDay) ...[
                        Text('Day Type', style: AppTextStyles.titleSmall),
                        const SizedBox(height: AppSpacing.sm),
                        SegmentedButton<int>(
                          segments: const [
                            ButtonSegment(value: 0, label: Text('Full Day')),
                            ButtonSegment(value: 1, label: Text('1st Half')),
                            ButtonSegment(value: 2, label: Text('2nd Half')),
                          ],
                          selected: {_dayType},
                          onSelectionChanged: (s) => setState(() {
                            _dayType = s.first;
                            _awaitingRangeEnd = false;
                          }),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      // ── Reason / Narration ────────────────────────
                      TextFormField(
                        controller: _reasonCtrl,
                        maxLines: 3,
                        maxLength: 2000,
                        decoration: const InputDecoration(
                          labelText: 'Reason / Narration',
                          hintText: 'Enter reason for leave...',
                          alignLabelWithHint: true,
                        ),
                        validator: Validators.reason,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: _narrationSuggestions
                            .map((s) => ActionChip(
                                  label: Text(s,
                                      style: AppTextStyles.bodySmall),
                                  onPressed: () => setState(() {
                                    _reasonCtrl.text = s;
                                    _reasonCtrl.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                          offset: s.length),
                                    );
                                  }),
                                ))
                            .toList(),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // ── Send for Approval ─────────────────────────
                      DropdownButtonFormField<int>(
                        value: _approvalStatus,
                        decoration: const InputDecoration(
                          labelText: 'Send for Approval',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 0,
                            child: Text('Save as Draft'),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text('Send for Approval'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _approvalStatus = v ?? 1),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // ── Error ─────────────────────────────────────
                      if (_error != null) ...[
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
                        const SizedBox(height: AppSpacing.sm),
                      ],

                      // ── Submit ────────────────────────────────────
                      BlocBuilder<LeaveBloc, LeaveState>(
                        builder: (_, state) => AppButton(
                          label: 'Submit Leave Request',
                          isLoading: state is LeaveLoading,
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
