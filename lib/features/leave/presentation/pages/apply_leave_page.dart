import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/datasources/leave_remote_datasource.dart';
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
  LeaveTypeModel? _selectedType;
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _focusedDay = DateTime.now();
  bool _isHalfDay = false;
  String _halfSession = 'morning';
  XFile? _document;
  List<String> _holidays = [];
  bool _loadingTypes = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final ds = getIt<LeaveRemoteDataSource>();
      final typesRes = await ds.getLeaveTypes();
      final holidaysRes = await ds.getPublicHolidays();
      setState(() {
        _leaveTypes = typesRes.data ?? [];
        _holidays = holidaysRes.data ?? [];
        if (_leaveTypes.isNotEmpty) _selectedType = _leaveTypes.first;
        _loadingTypes = false;
      });
    } catch (e) {
      setState(() {
        _loadingTypes = false;
        _error = 'Failed to load leave types';
      });
    }
  }

  int get _calculatedDays {
    if (_startDate == null || _endDate == null) return 0;
    if (_isHalfDay) return 0; // 0.5 handled separately
    return HrmDateUtils.workingDaysBetween(_startDate!, _endDate!);
  }

  Future<void> _pickDocument() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _document = file);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      setState(() => _error = 'Please select leave dates');
      return;
    }
    if (_selectedType!.requiresDocument && _document == null) {
      setState(
          () => _error = 'Document is required for this leave type');
      return;
    }

    context.read<LeaveBloc>().add(ApplyLeave({
          'leave_type_id': _selectedType!.id,
          'start_date': HrmDateUtils.formatApi(_startDate!),
          'end_date': HrmDateUtils.formatApi(_endDate!),
          'reason': _reasonCtrl.text.trim(),
          'is_half_day': _isHalfDay,
          if (_isHalfDay) 'half_day_session': _halfSession,
        }));
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
            ctx.read<LeaveBloc>().add(LoadBalance());
          } else if (state is LeaveError) {
            setState(
                () => _error = state.failure.message);
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
                      DropdownButtonFormField<LeaveTypeModel>(
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
                        onChanged: (v) =>
                            setState(() => _selectedType = v),
                        validator: (v) =>
                            v == null ? 'Select a leave type' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Select Dates',
                        style: AppTextStyles.titleSmall,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TableCalendar(
                        firstDay: DateTime.now()
                            .subtract(const Duration(days: 365)),
                        lastDay: DateTime.now()
                            .add(const Duration(days: 365)),
                        focusedDay: _focusedDay,
                        rangeStartDay: _startDate,
                        rangeEndDay: _endDate,
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
                                  _startDate = start;
                                  _endDate = end;
                                  _focusedDay = focused;
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
                      if (_startDate != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _isHalfDay
                                ? 'Half day on ${HrmDateUtils.formatDisplay(_startDate!)}'
                                : '${_calculatedDays} working day(s) · ${HrmDateUtils.formatDisplay(_startDate!)} – ${HrmDateUtils.formatDisplay(_endDate ?? _startDate!)}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: scheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      if (_selectedType?.allowHalfDay == true) ...[
                        SwitchListTile(
                          title: const Text('Half Day'),
                          value: _isHalfDay,
                          onChanged: (v) =>
                              setState(() => _isHalfDay = v),
                          contentPadding: EdgeInsets.zero,
                        ),
                        if (_isHalfDay)
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                  value: 'morning', label: Text('Morning')),
                              ButtonSegment(
                                  value: 'afternoon',
                                  label: Text('Afternoon')),
                            ],
                            selected: {_halfSession},
                            onSelectionChanged: (s) =>
                                setState(() => _halfSession = s.first),
                          ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      TextFormField(
                        controller: _reasonCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Reason',
                          hintText: 'Minimum 10 characters',
                        ),
                        validator: Validators.reason,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (_selectedType?.requiresDocument == true ||
                          _document != null) ...[
                        Text(
                          'Supporting Document${_selectedType?.requiresDocument == true ? ' (Required)' : ''}',
                          style: AppTextStyles.titleSmall,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        GestureDetector(
                          onTap: _pickDocument,
                          child: Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: scheme.outline.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _document != null
                                ? Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.attach_file),
                                        const SizedBox(width: 8),
                                        Text(
                                          _document!.name,
                                          style: AppTextStyles.bodySmall,
                                        ),
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.upload_rounded,
                                            color: scheme.onSurfaceVariant),
                                        Text(
                                          'Tap to attach document',
                                          style:
                                              AppTextStyles.bodySmall.copyWith(
                                            color: scheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      if (_error != null) ...[
                        Text(
                          _error!,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: scheme.error),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
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
