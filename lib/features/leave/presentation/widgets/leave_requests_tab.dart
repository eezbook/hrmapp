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
import '../bloc/leave_bloc.dart';
import '../bloc/leave_event.dart';
import '../bloc/leave_state.dart';

class LeaveRequestsTab extends StatefulWidget {
  const LeaveRequestsTab({super.key});

  @override
  State<LeaveRequestsTab> createState() => _LeaveRequestsTabState();
}

class _LeaveRequestsTabState extends State<LeaveRequestsTab> {
  String? _filter;
  final _scrollCtrl = ScrollController();

  final _filters = [
    (null, 'All'),
    ('draft', 'Draft'),
    ('pending', 'Pending'),
    ('approved', 'Approved'),
    ('rejected', 'Rejected'),
  ];

  static String _dayTypeLabel(bool isHalfDay, String? session) {
    if (!isHalfDay) return 'Full Day';
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
      context.read<LeaveBloc>().add(LoadMoreRequests(status: _filter));
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
        _FilterChips(
          filters: _filters,
          selected: _filter,
          onSelected: (f) {
            setState(() => _filter = f);
            context.read<LeaveBloc>().add(LoadRequests(status: f));
          },
        ),
        Expanded(
          child: BlocBuilder<LeaveBloc, LeaveState>(
            builder: (context, state) {
              if (state is LeaveLoading) {
                return const ShimmerListLoader();
              }
              if (state is LeaveError) {
                return ErrorView(
                  message: state.failure.message,
                  onRetry: () => context
                      .read<LeaveBloc>()
                      .add(LoadRequests(status: _filter)),
                );
              }
              if (state is RequestsLoaded) {
                if (state.requests.isEmpty) {
                  return const EmptyState(
                    icon: Icons.event_available_rounded,
                    title: 'No leave requests',
                    subtitle: 'Apply for leave using the button below.',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => context
                      .read<LeaveBloc>()
                      .add(RefreshRequests(status: _filter)),
                  child: ListView.separated(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.requests.length +
                        (state.hasMore ? 1 : 0),
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      if (i == state.requests.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final req = state.requests[i];
                      return Dismissible(
                        key: Key('leave_req_${req.id}'),
                        direction: req.isPending
                            ? DismissDirection.endToStart
                            : DismissDirection.none,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.cancel,
                              color: Colors.white),
                        ),
                        confirmDismiss: (_) => ConfirmationDialog.show(
                          context,
                          title: 'Cancel Request',
                          message:
                              'Are you sure you want to cancel this leave request?',
                          confirmLabel: 'Cancel Request',
                          isDangerous: true,
                        ),
                        onDismissed: (_) => context
                            .read<LeaveBloc>()
                            .add(CancelRequest(req.id)),
                        child: InkWell(
                          onTap: () => context.goNamed(
                            RouteNames.leaveDetail,
                            pathParameters: {'id': req.id.toString()},
                          ),
                          borderRadius: BorderRadius.circular(12),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          req.leaveTypeName,
                                          style:
                                              AppTextStyles.titleSmall,
                                        ),
                                      ),
                                      StatusPill(req.status),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${HrmDateUtils.formatDisplay(DateTime.parse(req.startDate))} – '
                                    '${HrmDateUtils.formatDisplay(DateTime.parse(req.endDate))}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '${req.days.toStringAsFixed(1)} day(s)',
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _dayTypeLabel(req.isHalfDay, req.halfDaySession),
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (req.reason.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      req.reason,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  if (req.createdAt != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Requested: ${HrmDateUtils.formatDisplay(DateTime.parse(req.createdAt!))}',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  final List<(String?, String)> filters;
  final String? selected;
  final void Function(String?) onSelected;

  const _FilterChips({
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: filters
            .map((f) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f.$2),
                    selected: selected == f.$1,
                    onSelected: (_) => onSelected(f.$1),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
