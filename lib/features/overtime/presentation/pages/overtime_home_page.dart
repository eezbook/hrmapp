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
import '../../../../core/widgets/avatar_widget.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/feature_header.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../data/models/overtime_model.dart';
import '../cubit/overtime_cubit.dart';

const _purple = Color(0xFF7367F0);
const _pageBg = Color(0xFFF5F7FF);

class OvertimeHomePage extends StatefulWidget {
  const OvertimeHomePage({super.key});

  @override
  State<OvertimeHomePage> createState() => _OvertimeHomePageState();
}

class _OvertimeHomePageState extends State<OvertimeHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _filter;
  final _canApprove = HrmPermissions.canApproveOvertime;
  OvertimeSummaryModel? _summary;

  @override
  void initState() {
    super.initState();
    final tabs = _canApprove ? 2 : 1;
    _tabController = TabController(length: tabs, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {});
      _updateHeader(_tabController.index);
    });
    context.read<OvertimeCubit>().loadRequests();
    if (_canApprove) {
      context.read<OvertimeCubit>().loadApprovals();
    }
    _updateHeader(0);
  }

  void _updateHeader(int tab) {
    if (_canApprove) {
      getIt<HrmHeaderCubit>().update(
        subtitle: 'Overtime requests',
        bottom: FeatureTabSwitcher(
          labels: const ['My Requests', 'Approvals'],
          selectedIndex: tab,
          onChanged: (i) {
            setState(() {});
            _tabController.animateTo(i);
            _updateHeader(i);
          },
        ),
      );
    } else {
      getIt<HrmHeaderCubit>().update(
        subtitle: 'Overtime requests',
        clearBottom: true,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otEnabled = _summary?.overtimeEnabled ?? true;
    return BlocListener<OvertimeCubit, OvertimeState>(
      listener: (context, state) {
        if (state is OvertimeLoaded && state.summary != null) {
          setState(() => _summary = state.summary);
        }
      },
      child: Scaffold(
      backgroundColor: _pageBg,
      floatingActionButton: (HrmPermissions.canApplyOvertime && otEnabled)
          ? FloatingActionButton.extended(
              onPressed: () => context.goNamed(RouteNames.overtimeApply),
              backgroundColor: _purple,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Log Overtime'),
            )
          : null,
      body: _canApprove
          ? TabBarView(
              controller: _tabController,
              children: [
                _MyRequestsTab(
                  filter: _filter,
                  onFilterChanged: (f) => setState(() => _filter = f),
                ),
                _ApprovalsTab(),
              ],
            )
          : _MyRequestsTab(
              filter: _filter,
              onFilterChanged: (f) => setState(() => _filter = f),
            ),
      ),
    );
  }
}

class _MyRequestsTab extends StatelessWidget {
  final String? filter;
  final void Function(String?) onFilterChanged;

  const _MyRequestsTab({
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OvertimeCubit, OvertimeState>(
      listener: (context, state) {
        if (state is OvertimeActionSuccess) {
          context.read<OvertimeCubit>().loadRequests(status: filter);
        }
      },
      builder: (context, state) {
        if (state is OvertimeLoading) return const ShimmerListLoader();
        if (state is OvertimeError) {
          return ErrorView(
            message: state.failure.message,
            onRetry: () => context.read<OvertimeCubit>().loadRequests(),
          );
        }
        if (state is OvertimeLoaded) {
          final s = state.summary;
          return Column(
            children: [
              if (s != null && !s.overtimeEnabled)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: Colors.orange.shade700, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Overtime is disabled for your account.',
                          style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.orange.shade800),
                        ),
                      ),
                    ],
                  ),
                ),
              if (s != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _SummaryChip(
                            label: 'Approved hrs',
                            value: s.totalApprovedHours.toStringAsFixed(1),
                          ),
                          const SizedBox(width: 10),
                          _SummaryChip(
                            label: 'Used today',
                            value:
                                '${s.usedHoursToday.toStringAsFixed(1)} / ${s.dailyThresholdHours}h',
                            isWarning: s.usedHoursToday >=
                                s.dailyThresholdHours,
                          ),
                          const SizedBox(width: 10),
                          _SummaryChip(
                            label: 'Total amount',
                            value: CurrencyUtils.formatShort(s.totalAmount),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.payments_outlined,
                              size: 14, color: Color(0xFF7367F0)),
                          const SizedBox(width: 4),
                          Text(
                            '${s.normalRate}× normal · ${s.holidayRate}× holiday',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: const Color(0xFF7367F0),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    (null, 'All'),
                    ('pending', 'Pending'),
                    ('approved', 'Approved'),
                    ('rejected', 'Rejected'),
                  ]
                      .map((f) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(f.$2),
                              selected: filter == f.$1,
                              onSelected: (_) {
                                onFilterChanged(f.$1);
                                context
                                    .read<OvertimeCubit>()
                                    .loadRequests(status: f.$1);
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              Expanded(
                child: state.requests.isEmpty
                    ? const EmptyState(
                        icon: Icons.schedule_rounded,
                        title: 'No overtime requests',
                      )
                    : RefreshIndicator(
                        onRefresh: () async => context
                            .read<OvertimeCubit>()
                            .loadRequests(status: filter),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.requests.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final req = state.requests[i];
                            return Card(
                              child: ListTile(
                                title: Text(
                                  HrmDateUtils.formatDisplay(
                                      DateTime.parse(req.date)),
                                ),
                                subtitle: Text(
                                  '${req.startTime} – ${req.endTime} · ${req.hours.toStringAsFixed(1)} hrs',
                                ),
                                trailing: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    StatusPill(req.status),
                                    Text(
                                      CurrencyUtils.formatPkr(req.amount),
                                      style: AppTextStyles.labelSmall,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
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
    return BlocConsumer<OvertimeCubit, OvertimeState>(
      listener: (context, state) {
        if (state is OvertimeActionSuccess) {
          context.read<OvertimeCubit>().loadApprovals();
        }
      },
      builder: (context, state) {
        if (state is OvertimeLoading) return const ShimmerListLoader();
        if (state is ApprovalsLoaded) {
          if (state.approvals.isEmpty) {
            return const EmptyState(
              icon: Icons.check_circle_outline_rounded,
              title: 'No pending overtime approvals',
            );
          }
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<OvertimeCubit>().loadApprovals(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.approvals.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final req = state.approvals[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AvatarWidget(
                              imageUrl: req.employeePhoto,
                              name: req.employeeName ?? 'Employee',
                              radius: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    req.employeeName ?? 'Employee',
                                    style: AppTextStyles.titleSmall,
                                  ),
                                  Text(
                                    '${HrmDateUtils.formatDisplay(DateTime.parse(req.date))} · ${req.hours.toStringAsFixed(1)} hrs',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (req.reason.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(req.reason, style: AppTextStyles.bodySmall),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  final ctrl = TextEditingController();
                                  final comment =
                                      await showDialog<String>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Reject Overtime'),
                                      content: TextFormField(
                                        controller: ctrl,
                                        decoration: const InputDecoration(
                                          hintText: 'Reason',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        FilledButton(
                                          onPressed: () => Navigator.pop(
                                              context, ctrl.text.trim()),
                                          child: const Text('Reject'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (comment != null && context.mounted) {
                                    context
                                        .read<OvertimeCubit>()
                                        .rejectRequest(req.id, comment);
                                  }
                                },
                                child: const Text('Reject'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton(
                                onPressed: () async {
                                  final confirm =
                                      await ConfirmationDialog.show(
                                    context,
                                    title: 'Approve Overtime',
                                    message:
                                        'Approve this overtime request?',
                                    confirmLabel: 'Approve',
                                  );
                                  if (confirm == true && context.mounted) {
                                    context
                                        .read<OvertimeCubit>()
                                        .approveRequest(req.id);
                                  }
                                },
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
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isWarning;
  const _SummaryChip({
    required this.label,
    required this.value,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = isWarning ? scheme.errorContainer : scheme.primaryContainer;
    final fg = isWarning ? scheme.onErrorContainer : scheme.onPrimaryContainer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.titleSmall.copyWith(color: fg),
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: fg.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
