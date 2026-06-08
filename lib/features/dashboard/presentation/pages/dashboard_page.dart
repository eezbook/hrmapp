import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/permissions/hrm_permissions.dart';
import '../../../../core/storage/hive_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../auth/data/datasources/auth_remote_datasource.dart';
import '../../../auth/data/models/company_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/models/dashboard_data_model.dart';
import '../cubit/dashboard_cubit.dart';

const _navy = Color(0xFF1B2064);
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
  }

  String _firstName(String fullName) {
    final parts = fullName.trim().split(' ');
    return parts.isNotEmpty ? parts.first : fullName;
  }

  String _formattedTime() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final employeeRaw =
        HiveStorage.employee.get(HiveKeys.employee) as Map?;
    final employeeName = employeeRaw?['name'] as String? ?? 'Employee';
    final employeePhoto = employeeRaw?['photo'] as String?;
    final companyName = employeeRaw?['companyName'] as String?;

    final initials = employeeName
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

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
                  // ── Header ──────────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _Header(
                      firstName: _firstName(employeeName),
                      initials: initials,
                      photoUrl: employeePhoto,
                      companyName: companyName,
                      time: _formattedTime(),
                      onMenuTap: () => _showCompanySwitcher(context),
                      onNotificationTap: () =>
                          context.goNamed(RouteNames.notifications),
                      onAvatarTap: () =>
                          context.goNamed(RouteNames.profile),
                    ),
                  ),

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

  void _showCompanySwitcher(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CompanySwitcherSheet(
        onSwitch: (companyId) {
          Navigator.pop(context);
          context.read<AuthBloc>().add(SwitchCompanyRequested(companyId));
        },
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String firstName;
  final String initials;
  final String? photoUrl;
  final String? companyName;
  final String time;
  final VoidCallback onMenuTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onAvatarTap;

  const _Header({
    required this.firstName,
    required this.initials,
    required this.photoUrl,
    required this.companyName,
    required this.time,
    required this.onMenuTap,
    required this.onNotificationTap,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            children: [
              // ── Row 1: Menu + Greeting + Bell + Avatar ─────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Hamburger
                  GestureDetector(
                    onTap: onMenuTap,
                    child: const Icon(Icons.menu_rounded,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),

                  // Greeting
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, $firstName!',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Explore the dashboard',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bell
                  GestureDetector(
                    onTap: onNotificationTap,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFC107),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Avatar
                  GestureDetector(
                    onTap: onAvatarTap,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white.withOpacity(0.15),
                      backgroundImage: photoUrl != null
                          ? NetworkImage(photoUrl!)
                          : null,
                      child: photoUrl == null
                          ? Text(
                              initials,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ── Row 2: Time pills ──────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _TimePill(
                      label: time,
                      icon: Icons.replay_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TimePill(
                      label: 'Out time',
                      icon: Icons.replay_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimePill extends StatelessWidget {
  final String label;
  final IconData icon;

  const _TimePill({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.white60, size: 18),
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

          // ── Summery ────────────────────────────────────────────────────
          _SectionHeader(
            title: 'Summery',
            action: const Icon(Icons.settings_outlined,
                color: _navy, size: 20),
          ),
          const SizedBox(height: 12),
          _SummaryRow(data: data),

          const SizedBox(height: 24),

          // ── Modules ────────────────────────────────────────────────────
          const _SectionHeader(title: 'Modules'),
          const SizedBox(height: 12),
          _ModulesGrid(),

          // ── Learning ───────────────────────────────────────────────────
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
          // Icon + Count on same row
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
        icon: Icons.inventory_2_outlined,
        label: 'Assets',
        route: RouteNames.leave,
        hasAccess: HrmPermissions.canApplyLeave,
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
                  content:
                      Text('This feature is not available for your account.'),
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

// ── Company Switcher Sheet ────────────────────────────────────────────────────

class _CompanySwitcherSheet extends StatefulWidget {
  final void Function(int companyId) onSwitch;
  const _CompanySwitcherSheet({required this.onSwitch});

  @override
  State<_CompanySwitcherSheet> createState() => _CompanySwitcherSheetState();
}

class _CompanySwitcherSheetState extends State<_CompanySwitcherSheet> {
  List<CompanyModel> _companies = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final ds = getIt<AuthRemoteDataSource>();
      final response = await ds.getCompanies();
      setState(() {
        _companies = response.data ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load companies';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Text('Switch Company',
                      style: AppTextStyles.titleSmall),
                ],
              ),
            ),
            const Divider(height: 16),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(color: _purple),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_error!,
                    style: const TextStyle(color: Colors.red)),
              )
            else
              ..._companies.map(
                (c) => ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20),
                  leading: CircleAvatar(
                    backgroundColor:
                        c.isCurrent ? _purple : Colors.grey.shade100,
                    child: Text(
                      c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: c.isCurrent ? Colors.white : _navy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(c.name),
                  trailing: c.isCurrent
                      ? const Icon(Icons.check_circle_rounded,
                          color: _purple)
                      : null,
                  onTap: c.isCurrent
                      ? null
                      : () => widget.onSwitch(c.id),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
