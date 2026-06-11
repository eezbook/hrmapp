import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../bloc/training_bloc.dart';
import '../bloc/training_event.dart';
import '../bloc/training_state.dart';

const _purple = Color(0xFF7367F0);
const _navy = Color(0xFF1B2064);

class CourseDetailPage extends StatefulWidget {
  final int courseId;
  const CourseDetailPage({super.key, required this.courseId});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<TrainingBloc>().add(LoadCourse(widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: const Text('Course Detail'),
        elevation: 0,
      ),
      body: BlocConsumer<TrainingBloc, TrainingState>(
        listener: (context, state) {
          if (state is EnrolledSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Enrolled successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<TrainingBloc>().add(LoadCourse(widget.courseId));
          }
          if (state is TrainingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TrainingLoading) {
            return const ShimmerListLoader();
          }
          if (state is TrainingError) {
            return ErrorView(
              message: state.failure.message,
              onRetry: () =>
                  context.read<TrainingBloc>().add(LoadCourse(widget.courseId)),
            );
          }
          if (state is CourseDetailLoaded) {
            return _CourseDetailBody(
              course: state.course,
              courseId: widget.courseId,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CourseDetailBody extends StatelessWidget {
  final dynamic course;
  final int courseId;

  const _CourseDetailBody({required this.course, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isEnrolled = course.isEnrolled == true;
    final isCompleted = course.isCompleted == true;
    final hasContent = course.contentUrl != null;
    final hasAssessment = course.hasAssessment == true;
    final progress = (course.myProgress as double?) ?? 0.0;

    return Column(
      children: [
        // ── Header thumbnail / gradient ────────────────────────
        Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_navy, _purple],
            ),
          ),
          child: Stack(
            children: [
              const Center(
                child: Icon(Icons.school_rounded, size: 72, color: Colors.white30),
              ),
              // Mandatory badge
              if (course.isMandatory == true)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.rejected,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Required',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              // Type badge
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _typeIcon(course.type as String? ?? 'video'),
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _typeLabel(course.type as String? ?? 'video'),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Scrollable body ────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  course.title as String,
                  style: AppTextStyles.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.sm),

                // Category + duration row
                Row(
                  children: [
                    if (course.category != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          course.category as String,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: scheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    const Icon(Icons.schedule_rounded, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${course.durationMinutes ?? 0} min',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                    ),
                  ],
                ),

                // Deadline (if mandatory)
                if (course.isMandatory == true && course.deadlineDate != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(Icons.event_busy_rounded,
                          size: 14, color: AppColors.rejected),
                      const SizedBox(width: 4),
                      Text(
                        'Deadline: ${course.deadlineDate}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.rejected,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],

                // Progress bar (if enrolled)
                if (isEnrolled && progress > 0) ...[
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress / 100,
                            minHeight: 8,
                            backgroundColor: scheme.surfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${progress.toStringAsFixed(0)}%',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: _purple,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],

                // Assessment info
                if (hasAssessment) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.quiz_rounded,
                            color: _purple, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assessment included',
                                style: AppTextStyles.titleSmall
                                    .copyWith(color: _purple),
                              ),
                              if (course.assessmentPassScore != null)
                                Text(
                                  'Pass score: ${course.assessmentPassScore}%'
                                  '${course.assessmentAttemptsAllowed != null ? '  •  ${course.assessmentAttemptsAllowed} attempts' : ''}',
                                  style: AppTextStyles.bodySmall
                                      .copyWith(color: _purple),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Description
                if (course.description != null &&
                    (course.description as String).isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text('About this course',
                      style: AppTextStyles.titleSmall),
                  const SizedBox(height: 6),
                  Text(
                    course.description as String,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),

        // ── Sticky action bar ──────────────────────────────────
        _ActionBar(
          courseId: courseId,
          isEnrolled: isEnrolled,
          isCompleted: isCompleted,
          hasContent: hasContent,
          hasAssessment: hasAssessment,
          contentType: course.type as String? ?? 'video',
        ),
      ],
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'link':
        return Icons.link_rounded;
      case 'scorm':
        return Icons.web_rounded;
      default:
        return Icons.play_circle_outline_rounded;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'pdf':
        return 'PDF';
      case 'link':
        return 'Link';
      case 'scorm':
        return 'SCORM';
      default:
        return 'Video';
    }
  }
}

class _ActionBar extends StatelessWidget {
  final int courseId;
  final bool isEnrolled;
  final bool isCompleted;
  final bool hasContent;
  final bool hasAssessment;
  final String contentType;

  const _ActionBar({
    required this.courseId,
    required this.isEnrolled,
    required this.isCompleted,
    required this.hasContent,
    required this.hasAssessment,
    required this.contentType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isEnrolled)
            AppButton(
              label: 'Enroll Now',
              onPressed: () =>
                  context.read<TrainingBloc>().add(EnrollCourse(courseId)),
            )
          else ...[
            if (hasContent)
              AppButton(
                label: isCompleted ? 'Watch Again' : 'Continue Learning',
                onPressed: () => context.goNamed(
                  RouteNames.coursePlayer,
                  pathParameters: {'courseId': courseId.toString()},
                ),
              ),
            if (hasAssessment) ...[
              if (hasContent) const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.pushNamed(
                  RouteNames.assessment,
                  pathParameters: {'courseId': courseId.toString()},
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  foregroundColor: _purple,
                  side: const BorderSide(color: _purple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.quiz_rounded),
                label: const Text('Take Assessment'),
              ),
            ],
            if (!hasContent && !hasAssessment)
              const Center(
                child: Text('No content available yet',
                    style: TextStyle(color: Colors.grey)),
              ),
          ],
        ],
      ),
    );
  }
}
