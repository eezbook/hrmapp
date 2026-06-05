import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../domain/entities/leave_request.dart';
import '../../domain/repositories/leave_repository.dart';
import '../bloc/leave_bloc.dart';
import '../bloc/leave_event.dart';
import '../bloc/leave_state.dart';

class LeaveRequestDetailPage extends StatefulWidget {
  final int id;

  const LeaveRequestDetailPage({super.key, required this.id});

  @override
  State<LeaveRequestDetailPage> createState() =>
      _LeaveRequestDetailPageState();
}

class _LeaveRequestDetailPageState extends State<LeaveRequestDetailPage> {
  LeaveRequest? _request;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    final result =
        await getIt<LeaveRepository>().getRequest(widget.id);
    if (!mounted) return;
    result.fold(
      (f) => setState(() {
        _loading = false;
        _error = f.message;
      }),
      (req) => setState(() {
        _loading = false;
        _request = req;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Leave Details')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(message: _error!, onRetry: _loadDetail)
              : _request == null
                  ? const Center(child: Text('Not found'))
                  : BlocListener<LeaveBloc, LeaveState>(
                      listener: (context, state) {
                        if (state is CancelledSuccess) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Request cancelled')),
                          );
                        }
                      },
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DetailCard(request: _request!),
                            const SizedBox(height: AppSpacing.md),
                            if (_request!.approvalTrail.isNotEmpty) ...[
                              Text(
                                'Approval Trail',
                                style: AppTextStyles.titleSmall,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              _ApprovalTimeline(
                                  steps: _request!.approvalTrail),
                            ],
                            if (_request!.isPending) ...[
                              const SizedBox(height: AppSpacing.lg),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final confirm =
                                        await ConfirmationDialog.show(
                                      context,
                                      title: 'Cancel Request',
                                      message:
                                          'Are you sure you want to cancel this leave request?',
                                      confirmLabel: 'Cancel Request',
                                      isDangerous: true,
                                    );
                                    if (confirm == true && mounted) {
                                      context.read<LeaveBloc>().add(
                                            CancelRequest(_request!.id),
                                          );
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: scheme.error,
                                  ),
                                  icon: const Icon(Icons.cancel_outlined),
                                  label: const Text('Cancel Request'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final LeaveRequest request;
  const _DetailCard({required this.request});

  static String _dayTypeLabel(bool isHalfDay, String? session) {
    if (!isHalfDay) return 'Full Day';
    if (session == 'afternoon') return '2nd Half';
    return '1st Half';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Row('Leave Type', request.leaveTypeName),
            _Row(
              'From',
              HrmDateUtils.formatDisplay(DateTime.parse(request.startDate)),
            ),
            _Row(
              'To',
              HrmDateUtils.formatDisplay(DateTime.parse(request.endDate)),
            ),
            _Row(
              'Duration',
              '${request.days.toStringAsFixed(1)} day(s)',
            ),
            _Row(
              'Day Type',
              _dayTypeLabel(request.isHalfDay, request.halfDaySession),
            ),
            if (request.createdAt != null)
              _Row(
                'Requested On',
                HrmDateUtils.formatDisplay(DateTime.parse(request.createdAt!)),
              ),
            _Row('Reason', request.reason),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Status',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  StatusPill(request.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _ApprovalTimeline extends StatelessWidget {
  final List<ApprovalStep> steps;
  const _ApprovalTimeline({required this.steps});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: steps.indexed.map((e) {
        final (i, step) = e;
        final isLast = i == steps.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _stepColor(step.status, scheme),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _stepIcon(step.status),
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: scheme.outlineVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Level ${step.level}: ${step.approverName}',
                        style: AppTextStyles.titleSmall,
                      ),
                      StatusPill(step.status),
                      if (step.comment != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          step.comment!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (step.decidedAt != null)
                        Text(
                          HrmDateUtils.formatDisplayTime(
                              DateTime.parse(step.decidedAt!)),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _stepColor(String status, ColorScheme scheme) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return scheme.error;
      default:
        return Colors.amber;
    }
  }

  IconData _stepIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check;
      case 'rejected':
        return Icons.close;
      default:
        return Icons.schedule;
    }
  }
}
