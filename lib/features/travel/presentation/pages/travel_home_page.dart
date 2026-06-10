import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/cubit/hrm_header_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/permissions/hrm_permissions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/feature_header.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/status_pill.dart';
import '../bloc/travel_bloc.dart';
import '../bloc/travel_event.dart';
import '../bloc/travel_state.dart';

const _purple = Color(0xFF7367F0);

class TravelHomePage extends StatefulWidget {
  const TravelHomePage({super.key});

  @override
  State<TravelHomePage> createState() => _TravelHomePageState();
}

class _TravelHomePageState extends State<TravelHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _canApprove = HrmPermissions.canApproveTravel;
  int _selectedTab = 0;

  late final TravelBloc _requestsBloc;
  late final TravelBloc _claimsBloc;
  TravelBloc? _approvalsBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _canApprove ? 3 : 2,
      vsync: this,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() => _selectedTab = _tabController.index);
      _updateHeader(_tabController.index);
    });

    _requestsBloc = getIt<TravelBloc>()..add(const LoadTravelRequests());
    _claimsBloc   = getIt<TravelBloc>()..add(LoadExpenseClaims());
    if (_canApprove) {
      _approvalsBloc = getIt<TravelBloc>()..add(LoadTravelApprovals());
    }
    _updateHeader(0);
  }

  void _updateHeader(int tab) {
    getIt<HrmHeaderCubit>().update(
      subtitle: 'Track your travels & expenses',
      bottom: FeatureTabSwitcher(
        labels: _tabLabels,
        selectedIndex: tab,
        onChanged: (i) {
          setState(() => _selectedTab = i);
          _tabController.animateTo(i);
          _updateHeader(i);
        },
      ),
    );
  }

  List<String> get _tabLabels =>
      _canApprove ? ['Travel', 'Expenses', 'Approvals'] : ['Travel', 'Expenses'];

  @override
  void dispose() {
    _tabController.dispose();
    _requestsBloc.close();
    _claimsBloc.close();
    _approvalsBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: featurePageBg,
      floatingActionButton: HrmPermissions.canApplyTravel
          ? FloatingActionButton.extended(
              onPressed: () async {
                await context.pushNamed(RouteNames.travelRequest);
                _requestsBloc.add(const LoadTravelRequests());
              },
              backgroundColor: _purple,
              foregroundColor: Colors.white,
              elevation: 4,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'New Request',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          : null,
      body: TabBarView(
        controller: _tabController,
        children: [
          BlocProvider.value(
            value: _requestsBloc,
            child: const _TravelTab(),
          ),
          BlocProvider.value(
            value: _claimsBloc,
            child: const _ExpensesTab(),
          ),
          if (_canApprove)
            BlocProvider.value(
              value: _approvalsBloc!,
              child: const _ApprovalsTab(),
            ),
        ],
      ),
    );
  }
}

// ── Travel Tab ────────────────────────────────────────────────────────────────

class _TravelTab extends StatelessWidget {
  const _TravelTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelBloc, TravelState>(
      builder: (context, state) {
        if (state is TravelLoading) return const ShimmerListLoader();
        if (state is TravelError) {
          return ErrorView(
            message: state.failure.message,
            onRetry: () =>
                context.read<TravelBloc>().add(const LoadTravelRequests()),
          );
        }
        if (state is TravelRequestsLoaded) {
          if (state.requests.isEmpty) {
            return const EmptyState(
              icon: Icons.flight_rounded,
              title: 'No travel requests',
              subtitle: 'Tap + to create your first travel request',
            );
          }
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<TravelBloc>().add(const LoadTravelRequests()),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final r = state.requests[i];
                return _TravelCard(request: r);
              },
            ),
          );
        }
        return const EmptyState(
          icon: Icons.flight_rounded,
          title: 'No travel requests',
          subtitle: 'Tap + to create your first travel request',
        );
      },
    );
  }
}

class _TravelCard extends StatelessWidget {
  final request;
  const _TravelCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => context.goNamed(
        RouteNames.travelDetail,
        pathParameters: {'id': request.id.toString()},
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(request.purpose,
                      style: AppTextStyles.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 8),
                StatusPill(request.status),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.flight_takeoff_rounded,
                    size: 16, color: Color(0xFF7367F0)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${request.origin.isNotEmpty ? request.origin : "—"} → ${request.destination}',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 14, color: Color(0xFF7367F0)),
                const SizedBox(width: 6),
                Text(
                  '${HrmDateUtils.formatDisplay(DateTime.parse(request.departureDate))}'
                  ' – '
                  '${HrmDateUtils.formatDisplay(DateTime.parse(request.returnDate))}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF7367F0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  CurrencyUtils.formatPkr(request.estimatedBudget),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: const Color(0xFF7367F0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Expenses Tab ──────────────────────────────────────────────────────────────

class _ExpensesTab extends StatelessWidget {
  const _ExpensesTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelBloc, TravelState>(
      builder: (context, state) {
        if (state is TravelLoading) return const ShimmerListLoader();
        if (state is TravelError) {
          return ErrorView(
            message: state.failure.message,
            onRetry: () =>
                context.read<TravelBloc>().add(LoadExpenseClaims()),
          );
        }
        if (state is ExpenseClaimsLoaded) {
          if (state.claims.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_rounded,
              title: 'No expense claims',
              subtitle: 'File a claim from an approved travel request',
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
                return _ExpenseCard(claim: c);
              },
            ),
          );
        }
        return const EmptyState(
          icon: Icons.receipt_long_rounded,
          title: 'No expense claims',
          subtitle: 'File a claim from an approved travel request',
        );
      },
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final claim;
  const _ExpenseCard({required this.claim});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => context.goNamed(
        RouteNames.expenseDetail,
        pathParameters: {'claimId': claim.id.toString()},
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.receipt_long_rounded,
                  color: scheme.onPrimaryContainer, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(claim.title,
                      style: AppTextStyles.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(
                    '${claim.items.length} item(s)',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyUtils.formatPkr(claim.total),
                  style:
                      AppTextStyles.titleSmall.copyWith(color: scheme.primary),
                ),
                const SizedBox(height: 4),
                StatusPill(claim.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Approvals Tab ─────────────────────────────────────────────────────────────

class _ApprovalsTab extends StatelessWidget {
  const _ApprovalsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelBloc, TravelState>(
      builder: (context, state) {
        if (state is TravelLoading) return const ShimmerListLoader();
        if (state is TravelError) {
          return ErrorView(
            message: state.failure.message,
            onRetry: () =>
                context.read<TravelBloc>().add(LoadTravelApprovals()),
          );
        }
        if (state is TravelApprovalsLoaded) {
          if (state.approvals.isEmpty) {
            return const EmptyState(
              icon: Icons.check_circle_outline_rounded,
              title: 'No pending approvals',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.approvals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final r = state.approvals[i];
              return Container(
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.purpose, style: AppTextStyles.titleSmall),
                    const SizedBox(height: 6),
                    Text('${r.origin} → ${r.destination}',
                        style: AppTextStyles.bodySmall),
                    Text(
                      CurrencyUtils.formatPkr(r.estimatedBudget),
                      style: AppTextStyles.bodySmall
                          .copyWith(color: const Color(0xFF7367F0)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context
                                .read<TravelBloc>()
                                .add(RejectTravelRequest(r.id, 'Rejected')),
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                            icon:
                                const Icon(Icons.close_rounded, size: 16),
                            label: const Text('Reject'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => context
                                .read<TravelBloc>()
                                .add(ApproveTravelRequest(r.id)),
                            icon:
                                const Icon(Icons.check_rounded, size: 16),
                            label: const Text('Approve'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const EmptyState(
          icon: Icons.check_circle_outline_rounded,
          title: 'No pending approvals',
        );
      },
    );
  }
}
