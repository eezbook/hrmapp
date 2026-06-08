import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../cubit/leave_requests_cubit.dart';

const _navy   = Color(0xFF1B2064);
const _purple = Color(0xFF7367F0);

class LeaveRequestsTab extends StatefulWidget {
  const LeaveRequestsTab({super.key});

  @override
  State<LeaveRequestsTab> createState() => _LeaveRequestsTabState();
}

class _LeaveRequestsTabState extends State<LeaveRequestsTab> {
  String? _filter;
  final _scrollCtrl = ScrollController();

  static const _filters = [
    (null,        'All'),
    ('draft',     'Draft'),
    ('pending',   'Pending'),
    ('approved',  'Approved'),
    ('rejected',  'Rejected'),
  ];

  static String _dayTypeLabel(bool? isHalfDay, String? session) {
    if (isHalfDay != true) return 'Full Day';
    if (session == 'afternoon') return '2nd Half';
    return '1st Half';
  }

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent * 0.8) {
      context.read<LeaveRequestsCubit>().loadMore(status: _filter);
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter chips
        _FilterRow(
          selected: _filter,
          onSelected: (f) {
            setState(() => _filter = f);
            context.read<LeaveRequestsCubit>().load(status: f);
          },
        ),

        // Request list
        Expanded(
          child: BlocConsumer<LeaveRequestsCubit, LeaveRequestsState>(
            listener: (context, state) {
              if (state is LeaveRequestCancelled) {
                context
                    .read<LeaveRequestsCubit>()
                    .load(status: _filter);
              }
              if (state is LeaveRequestsError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ));
              }
            },
            builder: (context, state) {
              if (state is LeaveRequestsLoading) {
                return const ShimmerRequestList();
              }
              if (state is LeaveRequestsError) {
                return ErrorView(
                  message: state.message,
                  onRetry: () => context
                      .read<LeaveRequestsCubit>()
                      .load(status: _filter),
                );
              }

              final requests = state is LeaveRequestsLoaded
                  ? state.requests
                  : state is LeaveRequestsLoadingMore
                      ? state.requests
                      : null;
              final hasMore = state is LeaveRequestsLoaded
                  ? state.hasMore
                  : false;

              if (requests == null) return const SizedBox.shrink();

              if (requests.isEmpty) {
                return const EmptyState(
                  icon: Icons.event_available_rounded,
                  title: 'No leave requests',
                  subtitle: 'Apply for leave using the button below.',
                );
              }

              return RefreshIndicator(
                color: _purple,
                onRefresh: () async => context
                    .read<LeaveRequestsCubit>()
                    .refresh(status: _filter),
                child: ListView.separated(
                  controller: _scrollCtrl,
                  padding:
                      const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  itemCount: requests.length + (hasMore ? 1 : 0),
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    if (i == requests.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                              color: _purple),
                        ),
                      );
                    }
                    final req = requests[i];
                    return Dismissible(
                      key: Key('leave_req_${req.id}'),
                      direction: req.isPending
                          ? DismissDirection.endToStart
                          : DismissDirection.none,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.cancel_outlined,
                            color: Colors.white, size: 26),
                      ),
                      confirmDismiss: (_) =>
                          ConfirmationDialog.show(
                        context,
                        title: 'Cancel Request',
                        message:
                            'Are you sure you want to cancel this leave request?',
                        confirmLabel: 'Cancel Request',
                        isDangerous: true,
                      ),
                      onDismissed: (_) => context
                          .read<LeaveRequestsCubit>()
                          .cancel(req.id),
                      child: GestureDetector(
                        onTap: () => context.goNamed(
                          RouteNames.leaveDetail,
                          pathParameters: {
                            'id': req.id.toString()
                          },
                        ),
                        child: _RequestCard(
                          leaveTypeName: req.leaveTypeName,
                          startDate: req.startDate,
                          endDate: req.endDate,
                          days: req.days,
                          status: req.status,
                          dayTypeLabel: _dayTypeLabel(
                              req.isHalfDay, req.halfDaySession),
                          reason: req.reason,
                          createdAt: req.createdAt,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Filter row ────────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  final String? selected;
  final void Function(String?) onSelected;

  const _FilterRow({required this.selected, required this.onSelected});

  static const _filters = [
    (null,       'All'),
    ('draft',    'Draft'),
    ('pending',  'Pending'),
    ('approved', 'Approved'),
    ('rejected', 'Rejected'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: _filters.map((f) {
          final isSelected = selected == f.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelected(f.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? _purple : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected
                        ? _purple
                        : Colors.grey.shade300,
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: _purple.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: Text(
                  f.$2,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Request card ──────────────────────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final String leaveTypeName;
  final String startDate;
  final String endDate;
  final double days;
  final String status;
  final String dayTypeLabel;
  final String reason;
  final String? createdAt;

  const _RequestCard({
    required this.leaveTypeName,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.status,
    required this.dayTypeLabel,
    required this.reason,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leave type + status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.beach_access_rounded,
                    color: _purple, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leaveTypeName,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: _navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${HrmDateUtils.formatDisplay(DateTime.parse(startDate))}'
                      '  →  '
                      '${HrmDateUtils.formatDisplay(DateTime.parse(endDate))}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              StatusPill(status),
            ],
          ),

          const SizedBox(height: 12),
          Container(
              height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 10),

          // Days + type + reason row
          Row(
            children: [
              _InfoChip(
                icon: Icons.calendar_today_rounded,
                label: '${days.toStringAsFixed(1)} day(s)',
                color: _purple,
              ),
              const SizedBox(width: 8),
              _InfoChip(
                icon: Icons.access_time_rounded,
                label: dayTypeLabel,
                color: Colors.grey.shade600,
              ),
              if (reason.isNotEmpty) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reason,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),

          if (createdAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Applied: ${HrmDateUtils.formatDisplay(DateTime.parse(createdAt!))}',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.grey.shade400,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
