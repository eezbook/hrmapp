import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/cubit/hrm_header_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/permissions/hrm_permissions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../attendance/data/datasources/attendance_remote_datasource.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/models/dashboard_data_model.dart';
import '../cubit/dashboard_cubit.dart';

const _navy   = Color(0xFF1B2064);
const _purple = Color(0xFF7367F0);
const _pageBg = Color(0xFFF5F7FF);

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
    getIt<HrmHeaderCubit>().update(
      subtitle: 'Explore the dashboard',
      bottom: const _DashboardTimePills(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (ctx, authState) {
          if (authState is AuthAuthenticated) {
            ctx.read<DashboardCubit>().loadDashboard();
          }
        },
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: _purple,
              onRefresh: () =>
                  context.read<DashboardCubit>().loadDashboard(),
              child: CustomScrollView(
                slivers: [
                  if (state is DashboardLoading)
                    const SliverFillRemaining(
                      child: ShimmerDashboardBody(),
                    )
                  else if (state is DashboardError)
                    SliverFillRemaining(
                      child: ErrorView(
                        message: state.message,
                        onRetry: () =>
                            context.read<DashboardCubit>().loadDashboard(),
                      ),
                    )
                  else if (state is DashboardLoaded) ...[
                    SliverToBoxAdapter(
                      child: _DashboardBody(data: state.data),
                    ),
                  ],
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

String _toAmPm(String? t) {
  if (t == null) return '--:--';
  final parts = t.split(':');
  if (parts.length < 2) return t;
  final h = int.tryParse(parts[0]);
  if (h == null) return t;
  final period = h < 12 ? 'AM' : 'PM';
  final h12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
  return '$h12:${parts[1]} $period';
}

// ── Dashboard time pills (placed in shell header bottom slot) ─────────────────

class _DashboardTimePills extends StatefulWidget {
  const _DashboardTimePills();

  @override
  State<_DashboardTimePills> createState() => _DashboardTimePillsState();
}

class _DashboardTimePillsState extends State<_DashboardTimePills> {
  String? _checkIn;
  String? _checkOut;

  @override
  void initState() {
    super.initState();
    _fetchToday();
  }

  Future<void> _fetchToday() async {
    try {
      final res = await getIt<AttendanceRemoteDataSource>().getToday();
      if (!mounted) return;
      setState(() {
        _checkIn  = _toAmPm(res.data?.checkIn);
        _checkOut = _toAmPm(res.data?.checkOut);
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TimePill(
            label: _checkIn ?? '--:--',
            sublabel: 'Check In',
            icon: Icons.login_rounded,
            active: _checkIn != null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _TimePill(
            label: _checkOut ?? '--:--',
            sublabel: 'Check Out',
            icon: Icons.logout_rounded,
            active: _checkOut != null,
          ),
        ),
      ],
    );
  }
}

class _TimePill extends StatelessWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  final bool active;

  const _TimePill({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(active ? 0.14 : 0.08),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: Colors.white.withOpacity(active ? 0.3 : 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon,
              color: active ? const Color(0xFFF5A623) : Colors.white38,
              size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sublabel,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white54,
                  fontSize: 10,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.titleSmall.copyWith(
                  color: active ? Colors.white : Colors.white38,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Dashboard Body ────────────────────────────────────────────────────────────

class _DashboardBody extends StatelessWidget {
  final DashboardDataModel data;
  const _DashboardBody({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          _SectionHeader(
            title: 'Summery',
            action: const Icon(Icons.settings_outlined,
                color: _navy, size: 20),
          ),
          const SizedBox(height: 12),
          _SummaryRow(data: data),

          const SizedBox(height: 24),

          const _SectionHeader(title: 'Modules'),
          const SizedBox(height: 12),
          _ModulesGrid(),

          if (HrmPermissions.canEnrollTraining &&
              data.myLearningProgress != null) ...[
            const SizedBox(height: 24),
            const _SectionHeader(title: 'Learning'),
            const SizedBox(height: 12),
            _LearningCard(
              progress: data.myLearningProgress! / 100,
              title: data.nearestTrainingTitle,
              deadline: data.nearestTrainingDeadline,
              onTap: () => context.goNamed(RouteNames.training),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  const _SectionHeader({required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.titleSmall.copyWith(
            color: _navy,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        const Spacer(),
        if (action != null) action!,
      ],
    );
  }
}

// ── Summary row ───────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  final DashboardDataModel data;
  const _SummaryRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final cards = <_SummaryItem>[];

    cards.add(_SummaryItem(
      icon: Icons.event_busy_rounded,
      label: 'Missed\nAttendance',
      count: data.pendingLeaveCount ?? 0,
      iconColor: const Color(0xFFEF4444),
      bgColor: const Color(0xFFFFECEC),
    ));

    cards.add(_SummaryItem(
      icon: Icons.pending_actions_rounded,
      label: 'Pending\nApproval',
      count: data.pendingApprovalsCount ?? 0,
      iconColor: const Color(0xFFF59E0B),
      bgColor: const Color(0xFFFFF8E1),
    ));

    cards.add(_SummaryItem(
      icon: Icons.campaign_rounded,
      label: 'New\nNotices',
      count: data.pendingExpenseClaimsCount ?? 0,
      iconColor: const Color(0xFF7367F0),
      bgColor: const Color(0xFFEEECFF),
    ));

    return Row(
      children: cards.asMap().entries.map((e) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: e.key == 0 ? 0 : 6,
              right: e.key == cards.length - 1 ? 0 : 6,
            ),
            child: _SummaryCard(item: e.value),
          ),
        );
      }).toList(),
    );
  }
}

class _SummaryItem {
  final IconData icon;
  final String label;
  final int count;
  final Color iconColor;
  final Color bgColor;
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.iconColor,
    required this.bgColor,
  });
}

class _SummaryCard extends StatelessWidget {
  final _SummaryItem item;
  const _SummaryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: item.iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                item.count.toString().padLeft(2, '0'),
                style: AppTextStyles.headlineMedium.copyWith(
                  color: _navy,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey.shade600,
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Modules grid ──────────────────────────────────────────────────────────────

class _ModulesGrid extends StatelessWidget {
  const _ModulesGrid();

  @override
  Widget build(BuildContext context) {
    final modules = [
      _ModuleItem(
        icon: Icons.free_breakfast_outlined,
        label: 'Break Time',
        route: RouteNames.attendance,
        hasAccess: HrmPermissions.canViewAttendance,
      ),
      _ModuleItem(
        icon: Icons.task_alt_rounded,
        label: 'Task',
        route: RouteNames.overtime,
        hasAccess: HrmPermissions.canApplyOvertime,
      ),
      _ModuleItem(
        icon: Icons.login_rounded,
        label: 'Check In/Out',
        route: RouteNames.attendance,
        hasAccess: HrmPermissions.canViewAttendance,
      ),
      _ModuleItem(
        icon: Icons.monetization_on_outlined,
        label: 'Claim',
        route: RouteNames.travel,
        hasAccess: HrmPermissions.canApplyTravel,
      ),
      _ModuleItem(
        icon: Icons.people_alt_outlined,
        label: 'Directory',
        route: RouteNames.profile,
        hasAccess: true,
      ),
      _ModuleItem(
        icon: Icons.location_on_outlined,
        label: 'My Location',
        route: RouteNames.location,
        hasAccess: true,
      ),
    ];

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.0,
      children: modules.map((m) => _ModuleTile(item: m)).toList(),
    );
  }
}

class _ModuleItem {
  final IconData icon;
  final String label;
  final String route;
  final bool hasAccess;
  const _ModuleItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.hasAccess,
  });
}

class _ModuleTile extends StatelessWidget {
  final _ModuleItem item;
  const _ModuleTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final locked = !item.hasAccess;
    return Opacity(
      opacity: locked ? 0.45 : 1.0,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (locked) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'This feature is not available for your account.'),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }
            context.goNamed(item.route);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.icon, color: _purple, size: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  item.label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _navy,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Learning card ─────────────────────────────────────────────────────────────

class _LearningCard extends StatelessWidget {
  final double progress;
  final String? title;
  final String? deadline;
  final VoidCallback onTap;

  const _LearningCard({
    required this.progress,
    required this.title,
    required this.deadline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: _purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.auto_stories_rounded,
                        color: _purple, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title ?? 'My Learning Progress',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _navy,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (deadline != null)
                          Text(
                            'Due: $deadline',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: _purple,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: _purple.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation(_purple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
