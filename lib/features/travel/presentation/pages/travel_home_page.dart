import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/permissions/hrm_permissions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/status_pill.dart';
import '../bloc/travel_bloc.dart';
import '../bloc/travel_event.dart';
import '../bloc/travel_state.dart';

class TravelHomePage extends StatefulWidget {
  const TravelHomePage({super.key});

  @override
  State<TravelHomePage> createState() => _TravelHomePageState();
}

class _TravelHomePageState extends State<TravelHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _canApprove = HrmPermissions.canApproveTravel;

  @override
  void initState() {
    super.initState();
    final tabs = _canApprove ? 3 : 2;
    _tabController = TabController(length: tabs, vsync: this);
    context.read<TravelBloc>()
      ..add(const LoadTravelRequests())
      ..add(LoadExpenseClaims());
    if (_canApprove) context.read<TravelBloc>().add(LoadTravelApprovals());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Travel & Expenses',
      floatingActionButton: HrmPermissions.canApplyTravel
          ? FloatingActionButton.extended(
              onPressed: () => context.goNamed(RouteNames.travelRequest),
              icon: const Icon(Icons.add),
              label: const Text('New Request'),
            )
          : null,
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              const Tab(text: 'Travel'),
              const Tab(text: 'Expenses'),
              if (_canApprove) const Tab(text: 'Approvals'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _TravelTab(),
                _ExpensesTab(),
                if (_canApprove) _ApprovalsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TravelTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelBloc, TravelState>(
      builder: (context, state) {
        if (state is TravelLoading) return const ShimmerListLoader();
        if (state is TravelError) {
          return ErrorView(
            message: state.failure.message,
            onRetry: () => context
                .read<TravelBloc>()
                .add(const LoadTravelRequests()),
          );
        }
        if (state is TravelRequestsLoaded) {
          if (state.requests.isEmpty) {
            return const EmptyState(
              icon: Icons.flight_rounded,
              title: 'No travel requests',
            );
          }
          return RefreshIndicator(
            onRefresh: () async => context
                .read<TravelBloc>()
                .add(const LoadTravelRequests()),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final r = state.requests[i];
                return InkWell(
                  onTap: () => context.goNamed(
                    RouteNames.travelDetail,
                    pathParameters: {'id': r.id.toString()},
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(r.purpose,
                                    style: AppTextStyles.titleSmall),
                              ),
                              StatusPill(r.status),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${r.origin} → ${r.destination}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${HrmDateUtils.formatDisplay(DateTime.parse(r.departureDate))} – ${HrmDateUtils.formatDisplay(DateTime.parse(r.returnDate))}',
                            style: AppTextStyles.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            CurrencyUtils.formatPkr(r.estimatedBudget),
                            style: AppTextStyles.labelLarge.copyWith(
                              color:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
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
    );
  }
}

class _ExpensesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelBloc, TravelState>(
      builder: (context, state) {
        if (state is TravelLoading) return const ShimmerListLoader();
        if (state is ExpenseClaimsLoaded) {
          if (state.claims.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_rounded,
              title: 'No expense claims',
            );
          }
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<TravelBloc>().add(LoadExpenseClaims()),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.claims.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final c = state.claims[i];
                return InkWell(
                  onTap: () => context.goNamed(
                    RouteNames.expenseDetail,
                    pathParameters: {'claimId': c.id.toString()},
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: Card(
                    child: ListTile(
                      title: Text(c.title),
                      subtitle: Text(
                          '${c.items.length} item(s)'),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(CurrencyUtils.formatPkr(c.total),
                              style: AppTextStyles.titleSmall),
                          StatusPill(c.status),
                        ],
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
    );
  }
}

class _ApprovalsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelBloc, TravelState>(
      builder: (context, state) {
        if (state is TravelLoading) return const ShimmerListLoader();
        if (state is TravelApprovalsLoaded) {
          if (state.approvals.isEmpty) {
            return const EmptyState(
              icon: Icons.check_circle_outline_rounded,
              title: 'No pending approvals',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.approvals.length,
            itemBuilder: (_, i) {
              final r = state.approvals[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.purpose, style: AppTextStyles.titleSmall),
                      Text('${r.origin} → ${r.destination}'),
                      Text('Budget: ${CurrencyUtils.formatPkr(r.estimatedBudget)}'),
                      if (r.budgetLimit != null)
                        Text('Policy limit: ${CurrencyUtils.formatPkr(r.budgetLimit!)}'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context
                                  .read<TravelBloc>()
                                  .add(RejectTravelRequest(r.id, 'Rejected')),
                              child: const Text('Reject'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton(
                              onPressed: () => context
                                  .read<TravelBloc>()
                                  .add(ApproveTravelRequest(r.id)),
                              child: const Text('Approve'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
