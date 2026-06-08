import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/avatar_widget.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../domain/entities/leave_request.dart';
import '../cubit/leave_approvals_cubit.dart';

class LeaveApprovalsTab extends StatelessWidget {
  const LeaveApprovalsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeaveApprovalsCubit, LeaveApprovalsState>(
      listener: (context, state) {
        if (state is LeaveApprovalActionSuccess) {
          context.read<LeaveApprovalsCubit>().load();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Action completed')),
          );
        }
        if (state is LeaveApprovalsError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
        }
      },
      builder: (context, state) {
        if (state is LeaveApprovalsLoading) return const ShimmerListLoader();
        if (state is LeaveApprovalsError) {
          return ErrorView(
            message: state.message,
            onRetry: () => context.read<LeaveApprovalsCubit>().load(),
          );
        }

        final approvals = state is LeaveApprovalsLoaded
            ? state.approvals
            : state is LeaveApprovalsLoadingMore
                ? state.approvals
                : null;

        if (approvals == null) return const SizedBox.shrink();

        if (approvals.isEmpty) {
          return const EmptyState(
            icon: Icons.check_circle_outline_rounded,
            title: 'No pending approvals',
          );
        }
        return RefreshIndicator(
          onRefresh: () async => context.read<LeaveApprovalsCubit>().load(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: approvals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final req = approvals[i];
              if (req.status != 'pending') {
                return _HistoryCard(req: req);
              }
              return Dismissible(
                key: Key('approval_${req.id}'),
                background: _SwipeBackground(
                  color: Colors.green,
                  icon: Icons.check,
                  align: Alignment.centerLeft,
                ),
                secondaryBackground: _SwipeBackground(
                  color: Colors.red,
                  icon: Icons.close,
                  align: Alignment.centerRight,
                ),
                confirmDismiss: (dir) async {
                  if (dir == DismissDirection.startToEnd) {
                    return ConfirmationDialog.show(
                      context,
                      title: 'Approve Leave',
                      message:
                          'Approve ${req.employeeName ?? "this employee"}\'s leave request?',
                      confirmLabel: 'Approve',
                    );
                  } else {
                    final comment = await _showRejectDialog(context);
                    if (comment == null) return false;
                    if (context.mounted) {
                      context
                          .read<LeaveApprovalsCubit>()
                          .reject(req.id, comment);
                    }
                    return false;
                  }
                },
                onDismissed: (dir) {
                  if (dir == DismissDirection.startToEnd) {
                    context.read<LeaveApprovalsCubit>().approve(req.id);
                  }
                },
                child: _PendingApprovalCard(req: req),
              );
            },
          ),
        );
      },
    );
  }

  Future<String?> _showRejectDialog(BuildContext context) {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reject Leave'),
        content: TextFormField(
          controller: ctrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter reason for rejection (required)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                Navigator.pop(context, ctrl.text.trim());
              }
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}

class _PendingApprovalCard extends StatelessWidget {
  final LeaveRequest req;

  const _PendingApprovalCard({required this.req});

  static String _dayTypeLabel(bool isHalfDay, String? session) {
    if (!isHalfDay) return 'Full Day';
    if (session == 'afternoon') return '2nd Half';
    return '1st Half';
  }

  Future<String?> _showRejectDialog(BuildContext context) {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reject Leave'),
        content: TextFormField(
          controller: ctrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter reason (required)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                Navigator.pop(context, ctrl.text.trim());
              }
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AvatarWidget(
                  imageUrl: req.employeePhoto,
                  name: req.employeeName ?? 'Employee',
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req.employeeName ?? 'Employee',
                        style: AppTextStyles.titleSmall,
                      ),
                      Text(
                        req.leaveTypeName,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${req.days.toStringAsFixed(1)} d',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                    Text(
                      _dayTypeLabel(req.isHalfDay, req.halfDaySession),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${HrmDateUtils.formatDisplay(DateTime.parse(req.startDate))} – '
              '${HrmDateUtils.formatDisplay(DateTime.parse(req.endDate))}',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 6),
            if (req.reason.isNotEmpty)
              Text(
                req.reason,
                style: AppTextStyles.bodySmall.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final comment = await _showRejectDialog(context);
                      if (comment != null && context.mounted) {
                        context
                            .read<LeaveApprovalsCubit>()
                            .reject(req.id, comment);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: scheme.error,
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      final confirm = await ConfirmationDialog.show(
                        context,
                        title: 'Approve Leave',
                        message: 'Approve this leave request?',
                        confirmLabel: 'Approve',
                      );
                      if (confirm == true && context.mounted) {
                        context.read<LeaveApprovalsCubit>().approve(req.id);
                      }
                    },
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final LeaveRequest req;
  const _HistoryCard({required this.req});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: AvatarWidget(
          imageUrl: req.employeePhoto,
          name: req.employeeName ?? 'Employee',
        ),
        title: Text(req.employeeName ?? 'Employee'),
        subtitle: Text(
          '${req.leaveTypeName} · ${req.days.toStringAsFixed(1)} day(s)',
        ),
        trailing: StatusPill(req.status),
      ),
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  final Color color;
  final IconData icon;
  final AlignmentGeometry align;

  const _SwipeBackground({
    required this.color,
    required this.icon,
    required this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: align,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
