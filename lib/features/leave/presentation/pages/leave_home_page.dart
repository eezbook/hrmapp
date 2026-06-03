import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/permissions/hrm_permissions.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../bloc/leave_bloc.dart';
import '../bloc/leave_event.dart';
import '../widgets/leave_balance_tab.dart';
import '../widgets/leave_requests_tab.dart';
import '../widgets/leave_approvals_tab.dart';

class LeaveHomePage extends StatefulWidget {
  const LeaveHomePage({super.key});

  @override
  State<LeaveHomePage> createState() => _LeaveHomePageState();
}

class _LeaveHomePageState extends State<LeaveHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _canApprove = HrmPermissions.canApproveLeave;

  @override
  void initState() {
    super.initState();
    final tabCount = _canApprove ? 3 : 2;
    _tabController = TabController(length: tabCount, vsync: this);
    context.read<LeaveBloc>()
      ..add(LoadBalance())
      ..add(const LoadRequests());
    if (_canApprove) context.read<LeaveBloc>().add(const LoadApprovals());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Leave',
      floatingActionButton: HrmPermissions.canApplyLeave
          ? FloatingActionButton.extended(
              onPressed: () => context.goNamed(RouteNames.leaveApply),
              icon: const Icon(Icons.add),
              label: const Text('Apply Leave'),
            )
          : null,
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              const Tab(text: 'Balance'),
              const Tab(text: 'My Requests'),
              if (_canApprove) const Tab(text: 'Approvals'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const LeaveBalanceTab(),
                const LeaveRequestsTab(),
                if (_canApprove) const LeaveApprovalsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
