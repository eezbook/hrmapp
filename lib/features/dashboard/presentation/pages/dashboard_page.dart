import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/permissions/hrm_permissions.dart';
import '../../../../core/storage/hive_storage.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/avatar_widget.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../data/models/dashboard_data_model.dart';
import '../cubit/dashboard_cubit.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? 'Good morning'
        : now.hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    final employeeRaw =
        HiveStorage.employee.get(HiveKeys.employee) as Map?;
    final employeeName = employeeRaw?['name'] as String? ?? 'Employee';
    final employeeDesignation =
        employeeRaw?['designation'] as String? ?? '';
    final employeeDepartment =
        employeeRaw?['department'] as String? ?? '';
    final employeePhoto = employeeRaw?['photo'] as String?;

    return AppScaffold(
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () =>
                context.read<DashboardCubit>().loadDashboard(),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 160,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                      color: scheme.primary,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AvatarWidget(
                            imageUrl: employeePhoto,
                            name: employeeName,
                            radius: 28,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$greeting,',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color:
                                        scheme.onPrimary.withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  employeeName,
                                  style: AppTextStyles.titleLarge.copyWith(
                                    color: scheme.onPrimary,
                                  ),
                                ),
                                if (employeeDesignation.isNotEmpty)
                                  Text(
                                    '$employeeDesignation · $employeeDepartment',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: scheme.onPrimary
                                          .withOpacity(0.7),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Text(
                                HrmDateUtils.formatRelative(now),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: scheme.onPrimary.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (state is DashboardLoading)
                  const SliverFillRemaining(
                    child: ShimmerListLoader(itemCount: 4),
                  )
                else if (state is DashboardError)
                  SliverFillRemaining(
                    child: ErrorView(
                      message: state.message,
                      onRetry: () =>
                          context.read<DashboardCubit>().loadDashboard(),
                    ),
                  )
                else if (state is DashboardLoaded)
                  SliverList(
                    delegate: SliverChildListDelegate(
                      _buildCards(context, state.data),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildCards(
      BuildContext context, DashboardDataModel data) {
    final scheme = Theme.of(context).colorScheme;
    final cards = <Widget>[];
    const pad = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

    // Leave balance
    if (HrmPermissions.canApplyLeave &&
        data.leaveBalances != null &&
        data.leaveBalances!.isNotEmpty) {
      cards.add(const SizedBox(height: 16));
      cards.add(Padding(
        padding: pad,
        child: Text('Leave Balances', style: AppTextStyles.titleSmall),
      ));
      cards.add(SizedBox(
        height: 90,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: data.leaveBalances!
              .take(4)
              .map((b) => _StatChip(
                    label: b.leaveTypeName,
                    value: b.remaining.toStringAsFixed(1),
                    subtitle: 'remaining',
                  ))
              .toList(),
        ),
      ));
    }

    // Pending leave requests
    if (HrmPermissions.canApplyLeave &&
        data.pendingLeaveCount != null) {
      cards.add(Padding(
        padding: pad,
        child: _DashCard(
          icon: Icons.beach_access_rounded,
          title: 'Pending Leave Requests',
          value: '${data.pendingLeaveCount}',
          onTap: () => context.goNamed(RouteNames.leave),
        ),
      ));
    }

    // Manager approvals
    if (HrmPermissions.canApproveLeave &&
        data.pendingApprovalsCount != null) {
      cards.add(Padding(
        padding: pad,
        child: _DashCard(
          icon: Icons.pending_actions_rounded,
          title: 'Pending Team Approvals',
          value: '${data.pendingApprovalsCount}',
          color: scheme.tertiaryContainer,
          onTap: () => context.goNamed(RouteNames.leaveApprovals),
        ),
      ));
    }

    // Training
    if (HrmPermissions.canEnrollTraining) {
      if (data.nearestTrainingTitle != null) {
        cards.add(Padding(
          padding: pad,
          child: _DashCard(
            icon: Icons.school_rounded,
            title: data.nearestTrainingTitle!,
            value: data.nearestTrainingDeadline ?? '',
            subtitle: 'Due date',
            color: scheme.secondaryContainer,
            onTap: () => context.goNamed(RouteNames.training),
          ),
        ));
      }
      if (data.myLearningProgress != null) {
        cards.add(Padding(
          padding: pad,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_stories_rounded),
                      const SizedBox(width: 8),
                      const Text('My Learning Progress'),
                      const Spacer(),
                      Text(
                        '${data.myLearningProgress!.toStringAsFixed(0)}%',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: data.myLearningProgress! / 100,
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    }

    // Pending expense claims
    if (HrmPermissions.canApplyTravel &&
        data.pendingExpenseClaimsCount != null) {
      cards.add(Padding(
        padding: pad,
        child: _DashCard(
          icon: Icons.receipt_long_rounded,
          title: 'Pending Expense Claims',
          value: '${data.pendingExpenseClaimsCount}',
          onTap: () => context.goNamed(RouteNames.travel),
        ),
      ));
    }

    // Quick actions
    cards.add(const SizedBox(height: 8));
    cards.add(Padding(
      padding: pad,
      child: Text('Quick Actions', style: AppTextStyles.titleSmall),
    ));
    cards.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (HrmPermissions.canApplyLeave)
            ActionChip(
              avatar: const Icon(Icons.beach_access_rounded, size: 16),
              label: const Text('Apply Leave'),
              onPressed: () => context.goNamed(RouteNames.leaveApply),
            ),
          if (HrmPermissions.canApplyTravel)
            ActionChip(
              avatar: const Icon(Icons.receipt_long_rounded, size: 16),
              label: const Text('Submit Expense'),
              onPressed: () => context.goNamed(RouteNames.expenseClaim),
            ),
          if (HrmPermissions.canApplyOvertime)
            ActionChip(
              avatar: const Icon(Icons.schedule_rounded, size: 16),
              label: const Text('Log Overtime'),
              onPressed: () => context.goNamed(RouteNames.overtimeApply),
            ),
        ],
      ),
    ));
    cards.add(const SizedBox(height: 80));
    return cards;
  }
}

class _DashCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final Color? color;
  final VoidCallback onTap;

  const _DashCard({
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: color ?? scheme.surfaceVariant.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon,
                    color: scheme.onPrimaryContainer),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodyMedium),
                    if (subtitle != null)
                      Text(subtitle!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: scheme.onSurfaceVariant,
                          )),
                  ],
                ),
              ),
              Text(
                value,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: scheme.primary,
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;

  const _StatChip({
    required this.label,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(
              color: scheme.onPrimaryContainer,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: scheme.onPrimaryContainer.withOpacity(0.8),
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: AppTextStyles.bodySmall.copyWith(
                color: scheme.onPrimaryContainer.withOpacity(0.6),
              ),
            ),
        ],
      ),
    );
  }
}
