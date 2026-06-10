import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/cubit/hrm_header_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/permissions/hrm_permissions.dart';
import '../../../../core/widgets/feature_header.dart';
import '../cubit/leave_balance_cubit.dart';
import '../cubit/leave_requests_cubit.dart';
import '../widgets/leave_balance_tab.dart';
import '../widgets/leave_requests_tab.dart';

const _purple = Color(0xFF7367F0);

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
      _updateHeader(_tabController.index);
    });
    context.read<LeaveBalanceCubit>().load();
    context.read<LeaveRequestsCubit>().load();
    _updateHeader(_selectedTab);
  }

  void _updateHeader(int tab) {
    getIt<HrmHeaderCubit>().update(
      subtitle: 'Manage your leaves',
      bottom: FeatureTabSwitcher(
        labels: const ['Balance', 'My Requests'],
        selectedIndex: tab,
        onChanged: (i) {
          setState(() => _selectedTab = i);
          _tabController.animateTo(i);
          _updateHeader(i);
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: featurePageBg,
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
      body: TabBarView(
        controller: _tabController,
        children: const [
          LeaveBalanceTab(),
          LeaveRequestsTab(),
        ],
      ),
    );
  }
}
