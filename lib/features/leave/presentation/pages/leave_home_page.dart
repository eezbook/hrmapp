import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/permissions/hrm_permissions.dart';
import '../../../../core/storage/hive_storage.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/leave_balance_cubit.dart';
import '../cubit/leave_requests_cubit.dart';
import '../widgets/leave_balance_tab.dart';
import '../widgets/leave_requests_tab.dart';

const _navy   = Color(0xFF1B2064);
const _purple = Color(0xFF7367F0);
const _pageBg = Color(0xFFF5F7FF);

class LeaveHomePage extends StatefulWidget {
  final int initialTab;
  const LeaveHomePage({super.key, this.initialTab = 0});

  @override
  State<LeaveHomePage> createState() => _LeaveHomePageState();
}

class _LeaveHomePageState extends State<LeaveHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab.clamp(0, 1);
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _selectedTab,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() => _selectedTab = _tabController.index);
    });
    context.read<LeaveBalanceCubit>().load();
    context.read<LeaveRequestsCubit>().load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _firstName(String fullName) {
    final parts = fullName.trim().split(' ');
    return parts.isNotEmpty ? parts.first : fullName;
  }

  @override
  Widget build(BuildContext context) {
    final employeeRaw   = HiveStorage.employee.get(HiveKeys.employee) as Map?;
    final employeeName  = employeeRaw?['name'] as String? ?? 'Employee';
    final employeePhoto = employeeRaw?['photo'] as String?;
    final initials = employeeName
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return Scaffold(
      backgroundColor: _pageBg,
      floatingActionButton: HrmPermissions.canApplyLeave
          ? FloatingActionButton.extended(
              onPressed: () => context.goNamed(RouteNames.leaveApply),
              backgroundColor: _purple,
              foregroundColor: Colors.white,
              elevation: 4,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Apply Leave',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          : null,
      body: Column(
        children: [
          // ── Navy header ───────────────────────────────────────────────
          _LeaveHeader(
            firstName: _firstName(employeeName),
            initials: initials,
            photoUrl: employeePhoto,
            selectedTab: _selectedTab,
            onTabChanged: (i) {
              setState(() => _selectedTab = i);
              _tabController.animateTo(i);
            },
            onNotificationTap: () =>
                context.goNamed(RouteNames.notifications),
            onAvatarTap: () => context.goNamed(RouteNames.profile),
          ),

          // ── Tab content ───────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                LeaveBalanceTab(),
                LeaveRequestsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _LeaveHeader extends StatelessWidget {
  final String firstName;
  final String initials;
  final String? photoUrl;
  final int selectedTab;
  final void Function(int) onTabChanged;
  final VoidCallback onNotificationTap;
  final VoidCallback onAvatarTap;

  const _LeaveHeader({
    required this.firstName,
    required this.initials,
    required this.photoUrl,
    required this.selectedTab,
    required this.onTabChanged,
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
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            children: [
              // Row: hamburger + greeting + bell + avatar
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_rounded,
                      color: Colors.white, size: 26),
                  const SizedBox(width: 14),
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
                          'Manage your leaves',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bell
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: onNotificationTap,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.notifications_outlined,
                              color: Colors.white, size: 22),
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

              // Segmented tab switcher
              Container(
                height: 42,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _TabBtn(
                      label: 'Balance',
                      selected: selectedTab == 0,
                      onTap: () => onTabChanged(0),
                    ),
                    _TabBtn(
                      label: 'My Requests',
                      selected: selectedTab == 1,
                      onTap: () => onTabChanged(1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: selected ? _navy : Colors.white60,
              fontWeight:
                  selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
