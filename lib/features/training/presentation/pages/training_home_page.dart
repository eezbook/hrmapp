import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/cubit/hrm_header_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/feature_header.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../data/models/training_request_model.dart';
import '../bloc/training_bloc.dart';
import '../bloc/training_event.dart';
import '../bloc/training_state.dart';

const _purple = Color(0xFF7367F0);
const _navy = Color(0xFF1B2064);

class TrainingHomePage extends StatefulWidget {
  const TrainingHomePage({super.key});

  @override
  State<TrainingHomePage> createState() => _TrainingHomePageState();
}

class _TrainingHomePageState extends State<TrainingHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _tabs = ['My Trainings', 'Certificates'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final idx = _tabController.index;
      _updateHeader(idx);
      _loadTabData(idx);
    });
    context.read<TrainingBloc>().add(const LoadTrainingRequests());
    _updateHeader(0);
  }

  void _loadTabData(int idx) {
    if (idx == 0) {
      context.read<TrainingBloc>().add(const LoadTrainingRequests());
    } else {
      context.read<TrainingBloc>().add(const LoadCertificates());
    }
  }

  void _updateHeader(int tab) {
    getIt<HrmHeaderCubit>().update(
      subtitle: 'Grow your skills',
      bottom: FeatureTabSwitcher(
        labels: _tabs,
        selectedIndex: tab,
        onChanged: (i) {
          _tabController.animateTo(i);
          _updateHeader(i);
          _loadTabData(i);
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
      body: TabBarView(
        controller: _tabController,
        children: const [
          _MyTrainingsTab(),
          _CertificatesTab(),
        ],
      ),
    );
  }
}

// ── My Trainings Tab ──────────────────────────────────────────────────────────

enum _TrainingFilter { all, pending, approved, inProgress }

class _MyTrainingsTab extends StatefulWidget {
  const _MyTrainingsTab();

  @override
  State<_MyTrainingsTab> createState() => _MyTrainingsTabState();
}

class _MyTrainingsTabState extends State<_MyTrainingsTab> {
  _TrainingFilter _filter = _TrainingFilter.all;

  static const _labels = {
    _TrainingFilter.all: 'All',
    _TrainingFilter.inProgress: 'In Progress',
    _TrainingFilter.pending: 'Pending',
    _TrainingFilter.approved: 'Approved',
  };

  bool _matchesFilter(TrainingRequestModel t) {
    switch (_filter) {
      case _TrainingFilter.all:
        return true;
      case _TrainingFilter.pending:
        return t.status == 'pending' || t.status == 'draft';
      case _TrainingFilter.approved:
        return t.status == 'approved';
      case _TrainingFilter.inProgress:
        final start = DateTime.tryParse(t.startDate);
        final end = DateTime.tryParse(t.endDate);
        if (start == null || end == null) return false;
        final now = DateTime.now();
        return !now.isBefore(start) && !now.isAfter(end);
    }
  }

  int _count(List<TrainingRequestModel> all, _TrainingFilter f) {
    return all.where((t) {
      switch (f) {
        case _TrainingFilter.all:
          return true;
        case _TrainingFilter.pending:
          return t.status == 'pending' || t.status == 'draft';
        case _TrainingFilter.approved:
          return t.status == 'approved';
        case _TrainingFilter.inProgress:
          final start = DateTime.tryParse(t.startDate);
          final end = DateTime.tryParse(t.endDate);
          if (start == null || end == null) return false;
          final now = DateTime.now();
          return !now.isBefore(start) && !now.isAfter(end);
      }
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingBloc, TrainingState>(
      builder: (context, state) {
        if (state is TrainingLoading) return const ShimmerListLoader();
        if (state is TrainingError) {
          return ErrorView(
            message: state.failure.message,
            onRetry: () => context
                .read<TrainingBloc>()
                .add(const LoadTrainingRequests()),
          );
        }
        if (state is TrainingRequestsLoaded) {
          final all = state.requests;
          final filtered = all.where(_matchesFilter).toList();

          return Column(
            children: [
              // ── Filter chips ─────────────────────────────────
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _TrainingFilter.values.map((f) {
                      final active = _filter == f;
                      final count = _count(all, f);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _filter = f),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: active ? _navy : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: active ? _navy : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _labels[f]!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: active
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: active
                                        ? Colors.white.withValues(alpha: 0.25)
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$count',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: active
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // ── List ─────────────────────────────────────────
              Expanded(
                child: filtered.isEmpty
                    ? EmptyState(
                        icon: Icons.school_rounded,
                        title: _filter == _TrainingFilter.all
                            ? 'No trainings assigned'
                            : 'No ${_labels[_filter]!.toLowerCase()} trainings',
                        subtitle: _filter == _TrainingFilter.all
                            ? 'Your training programmes will appear here.'
                            : 'Switch filter to see other trainings.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (_, i) =>
                            _TrainingCard(training: filtered[i]),
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

class _TrainingCard extends StatelessWidget {
  final TrainingRequestModel training;
  const _TrainingCard({required this.training});

  double _progress() {
    final start = DateTime.tryParse(training.startDate);
    if (start == null || training.totalDays <= 0) return 0.0;
    final now = DateTime.now();
    if (now.isBefore(start)) return 0.0;
    final end = DateTime.tryParse(training.endDate);
    if (end != null && now.isAfter(end)) return 1.0;
    final elapsed = now.difference(start).inDays + 1;
    return (elapsed / training.totalDays).clamp(0.0, 1.0);
  }

  int _daysElapsed() {
    final start = DateTime.tryParse(training.startDate);
    if (start == null) return 0;
    final now = DateTime.now();
    if (now.isBefore(start)) return 0;
    final end = DateTime.tryParse(training.endDate);
    if (end != null && now.isAfter(end)) return training.totalDays;
    return (now.difference(start).inDays + 1).clamp(0, training.totalDays);
  }

  bool _isUpcoming() {
    final start = DateTime.tryParse(training.startDate);
    return start != null && DateTime.now().isBefore(start);
  }

  bool _isCompleted() {
    final end = DateTime.tryParse(training.endDate);
    return end != null && DateTime.now().isAfter(end);
  }

  @override
  Widget build(BuildContext context) {
    final progress = _progress();
    final elapsed = _daysElapsed();
    final remaining = training.totalDays - elapsed;
    final upcoming = _isUpcoming();
    final completed = _isCompleted();

    Color progressColor;
    if (completed) {
      progressColor = AppColors.approved;
    } else if (upcoming) {
      progressColor = AppColors.info;
    } else {
      progressColor = _purple;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title row ──────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _purple.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.school_rounded,
                      color: _purple, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    training.trainingTitle,
                    style: const TextStyle(
                      color: Color(0xFF1B2064),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                StatusPill(training.status),
              ],
            ),
            const SizedBox(height: 12),

            // ── Body ─────────────────────────────────────────
            // Type + location row
            Row(
                  children: [
                    if (training.trainingType != null &&
                        training.trainingType!.isNotEmpty) ...[
                      _Chip(
                        icon: Icons.category_outlined,
                        label: training.trainingType!,
                        color: _purple,
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (training.trainingLocation != null &&
                        training.trainingLocation!.isNotEmpty)
                      _Chip(
                        icon: Icons.location_on_outlined,
                        label: training.trainingLocation!,
                        color: Colors.grey.shade600,
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // Date range
                Row(
                  children: [
                    const Icon(Icons.date_range_rounded,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      '${training.startDate}  →  ${training.endDate}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${training.totalDays} day${training.totalDays == 1 ? '' : 's'}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
                const SizedBox(height: 6),

                // Progress label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      upcoming
                          ? 'Starts in ${DateTime.tryParse(training.startDate)!.difference(DateTime.now()).inDays + 1} day(s)'
                          : completed
                              ? 'Completed'
                              : '$elapsed of ${training.totalDays} days done',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: progressColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (!upcoming && !completed)
                      Text(
                        '$remaining day${remaining == 1 ? '' : 's'} remaining',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Chip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Certificates Tab ──────────────────────────────────────────────────────────

class _CertificatesTab extends StatelessWidget {
  const _CertificatesTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingBloc, TrainingState>(
      builder: (context, state) {
        if (state is TrainingLoading) return const ShimmerListLoader();
        if (state is TrainingError) {
          return ErrorView(
            message: state.failure.message,
            onRetry: () =>
                context.read<TrainingBloc>().add(const LoadCertificates()),
          );
        }
        if (state is CertificatesLoaded) {
          if (state.certificates.isEmpty) {
            return const EmptyState(
              icon: Icons.workspace_premium_rounded,
              title: 'No certificates yet',
              subtitle: 'Complete courses to earn certificates.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: state.certificates.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final cert = state.certificates[i];
              final now = DateTime.now();
              final expiry = cert.expiryDate != null
                  ? DateTime.tryParse(cert.expiryDate!)
                  : null;
              final expiresSoon = expiry != null &&
                  expiry.difference(now).inDays <= 30 &&
                  expiry.isAfter(now);
              final isExpired = expiry != null && expiry.isBefore(now);

              return InkWell(
                onTap: () => context.pushNamed(
                  RouteNames.certificateView,
                  pathParameters: {'id': cert.id.toString()},
                  extra: cert,
                ),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    leading: const Icon(Icons.workspace_premium_rounded,
                        color: Colors.amber, size: 32),
                    title: Text(cert.courseName),
                    subtitle: Text('Issued: ${cert.issuedDate}'),
                    trailing: expiry != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isExpired
                                  ? AppColors.rejectedBg
                                  : expiresSoon
                                      ? AppColors.pendingBg
                                      : AppColors.approvedBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isExpired
                                  ? 'Expired'
                                  : expiresSoon
                                      ? 'Expiring'
                                      : 'Valid',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: isExpired
                                    ? AppColors.rejected
                                    : expiresSoon
                                        ? AppColors.pending
                                        : AppColors.approved,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : null,
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
