import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/cubit/hrm_header_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/feature_header.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../bloc/training_bloc.dart';
import '../bloc/training_event.dart';
import '../bloc/training_state.dart';

const _purple = Color(0xFF7367F0);

class TrainingHomePage extends StatefulWidget {
  const TrainingHomePage({super.key});

  @override
  State<TrainingHomePage> createState() => _TrainingHomePageState();
}

class _TrainingHomePageState extends State<TrainingHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  String? _selectedCategory;

  static const _tabs = ['Library', 'My Learning', 'Certificates'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() => _selectedTab = _tabController.index);
      _updateHeader(_tabController.index);
    });
    context.read<TrainingBloc>().add(const LoadCourses());
    _updateHeader(0);
  }

  void _updateHeader(int tab) {
    getIt<HrmHeaderCubit>().update(
      subtitle: 'Grow your skills',
      bottom: FeatureTabSwitcher(
        labels: _tabs,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(RouteNames.trainingRequest),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Request',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _LibraryTab(
            selectedCategory: _selectedCategory,
            onCategoryChanged: (c) {
              setState(() => _selectedCategory = c);
              context.read<TrainingBloc>().add(LoadCourses(category: c));
            },
          ),
          const _MyLearningTab(),
          const _CertificatesTab(),
        ],
      ),
    );
  }
}

// ── Library Tab ───────────────────────────────────────────────────────────────

class _LibraryTab extends StatelessWidget {
  final String? selectedCategory;
  final void Function(String?) onCategoryChanged;

  const _LibraryTab({
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingBloc, TrainingState>(
      builder: (context, state) {
        if (state is TrainingLoading) return const ShimmerListLoader();
        if (state is TrainingError) {
          return ErrorView(
            message: state.failure.message,
            onRetry: () =>
                context.read<TrainingBloc>().add(const LoadCourses()),
          );
        }
        if (state is CoursesLoaded) {
          return Column(
            children: [
              if (state.categories.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: const Text('All'),
                          selected: selectedCategory == null,
                          onSelected: (_) => onCategoryChanged(null),
                        ),
                      ),
                      ...state.categories.map((cat) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(cat),
                              selected: selectedCategory == cat,
                              onSelected: (_) => onCategoryChanged(cat),
                            ),
                          )),
                    ],
                  ),
                ),
              Expanded(
                child: state.courses.isEmpty
                    ? const EmptyState(
                        icon: Icons.school_rounded,
                        title: 'No courses found',
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: state.courses.length,
                        itemBuilder: (_, i) =>
                            _CourseCard(course: state.courses[i]),
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

class _CourseCard extends StatelessWidget {
  final course;
  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => context.goNamed(
        RouteNames.courseDetail,
        pathParameters: {'courseId': course.id.toString()},
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
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  course.thumbnailUrl != null
                      ? CachedNetworkImage(
                          imageUrl: course.thumbnailUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: scheme.primaryContainer),
                          errorWidget: (_, __, ___) => Container(
                              color: scheme.primaryContainer,
                              child: Icon(Icons.school,
                                  color: scheme.onPrimaryContainer)),
                        )
                      : Container(
                          color: scheme.primaryContainer,
                          child: Icon(Icons.school,
                              color: scheme.onPrimaryContainer),
                        ),
                  if (course.isMandatory == true)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.rejected,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Required',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: AppTextStyles.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    if (course.myProgress != null &&
                        (course.myProgress as double) > 0) ...[
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: (course.myProgress as double) / 100,
                                minHeight: 5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${(course.myProgress as double).toStringAsFixed(0)}%',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: _purple,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── My Learning Tab ───────────────────────────────────────────────────────────

class _MyLearningTab extends StatelessWidget {
  const _MyLearningTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingBloc, TrainingState>(
      builder: (context, state) {
        if (state is TrainingLoading) return const ShimmerListLoader();
        if (state is MyLearningLoaded) {
          if (state.inProgress.isEmpty && state.completed.isEmpty) {
            return const EmptyState(
              icon: Icons.play_circle_outline_rounded,
              title: 'No courses in progress',
              subtitle: 'Enrol in courses from the Library tab.',
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.inProgress.isNotEmpty) ...[
                Text('In Progress', style: AppTextStyles.titleSmall),
                const SizedBox(height: 10),
                ...state.inProgress.map((c) => _LearningCard(course: c)),
              ],
              if (state.completed.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text('Completed', style: AppTextStyles.titleSmall),
                const SizedBox(height: 10),
                ...state.completed.map((c) => _LearningCard(course: c)),
              ],
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _LearningCard extends StatelessWidget {
  final course;
  const _LearningCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => context.goNamed(
        RouteNames.courseDetail,
        pathParameters: {'courseId': course.id.toString()},
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.school, color: scheme.onPrimaryContainer),
          ),
          title: Text(course.title,
              maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: course.myProgress != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (course.myProgress as double) / 100,
                      minHeight: 5,
                    ),
                  ),
                )
              : null,
          trailing: Text(
            '${(course.myProgress ?? 0).toStringAsFixed(0)}%',
            style: AppTextStyles.labelSmall
                .copyWith(color: _purple, fontWeight: FontWeight.w700),
          ),
        ),
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
        if (state is CertificatesLoaded) {
          if (state.certificates.isEmpty) {
            return const EmptyState(
              icon: Icons.workspace_premium_rounded,
              title: 'No certificates yet',
              subtitle: 'Complete courses to earn certificates.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
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
                onTap: () => context.goNamed(
                  RouteNames.certificateView,
                  pathParameters: {'id': cert.id.toString()},
                ),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
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
