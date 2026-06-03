import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/assessment_cubit.dart';

class AssessmentPage extends StatefulWidget {
  final int courseId;

  const AssessmentPage({super.key, required this.courseId});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    context.read<AssessmentCubit>().loadAssessment();
  }

  void _startTimer(int seconds) {
    _remainingSeconds = seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds == 0) {
        t.cancel();
        context.read<AssessmentCubit>().submit();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment'),
        actions: [
          if (_remainingSeconds > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  '${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:'
                  '${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: _remainingSeconds < 60
                        ? scheme.error
                        : scheme.onSurface,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: BlocConsumer<AssessmentCubit, AssessmentState>(
        listener: (context, state) {
          if (state is AssessmentReady && _timer == null) {
            // Start timer if timed assessment
          }
        },
        builder: (context, state) {
          if (state is AssessmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AssessmentReady) {
            if (state.questions.isEmpty) {
              return const Center(child: Text('No questions available'));
            }
            final question = state.questions[state.currentIndex];
            final isLast =
                state.currentIndex == state.questions.length - 1;
            final selectedOption = state.answers[question.id];

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: (state.currentIndex + 1) /
                        state.questions.length,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Q ${state.currentIndex + 1} of ${state.questions.length}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        question.question,
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...question.options.indexed.map((e) {
                    final (i, option) = e;
                    final label =
                        ['A', 'B', 'C', 'D'][i < 4 ? i : 0];
                    final isSelected = selectedOption == i;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () => context
                            .read<AssessmentCubit>()
                            .selectAnswer(question.id, i),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? scheme.primary
                                  : scheme.outline.withOpacity(0.3),
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected
                                ? scheme.primaryContainer
                                : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? scheme.primary
                                      : scheme.surfaceVariant,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      color: isSelected
                                          ? scheme.onPrimary
                                          : scheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(option)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const Spacer(),
                  AppButton(
                    label: isLast ? 'Submit' : 'Next',
                    onPressed: selectedOption == null
                        ? null
                        : () {
                            if (isLast) {
                              context
                                  .read<AssessmentCubit>()
                                  .submit();
                            } else {
                              context
                                  .read<AssessmentCubit>()
                                  .nextQuestion();
                            }
                          },
                  ),
                ],
              ),
            );
          }
          if (state is Submitting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PassResult) {
            return _ResultScreen(
              score: state.score,
              passed: true,
              certificate: state.certificate,
              attemptsRemaining: null,
            );
          }
          if (state is FailResult) {
            return _ResultScreen(
              score: state.score,
              passed: false,
              certificate: null,
              attemptsRemaining: state.attemptsRemaining,
            );
          }
          if (state is AssessmentError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ResultScreen extends StatelessWidget {
  final double score;
  final bool passed;
  final dynamic cert;
  final int? attemptsRemaining;

  const _ResultScreen({
    required this.score,
    required this.passed,
    required dynamic certificate,
    required this.attemptsRemaining,
  }) : cert = certificate;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              passed
                  ? Icons.workspace_premium_rounded
                  : Icons.close_rounded,
              size: 80,
              color: passed ? Colors.amber : scheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              passed ? 'Congratulations!' : 'Not Passed',
              style: AppTextStyles.headlineMedium,
            ),
            Text(
              'Score: ${score.toStringAsFixed(1)}%',
              style: AppTextStyles.titleMedium.copyWith(
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            if (passed && cert != null)
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: const Text('Download Certificate'),
              )
            else if (!passed) ...[
              if (attemptsRemaining != null && attemptsRemaining! > 0)
                FilledButton.icon(
                  onPressed: () =>
                      context.read<AssessmentCubit>().loadAssessment(),
                  icon: const Icon(Icons.refresh),
                  label: Text('Retry ($attemptsRemaining left)'),
                )
              else
                Text(
                  'No more attempts remaining',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: scheme.error,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
