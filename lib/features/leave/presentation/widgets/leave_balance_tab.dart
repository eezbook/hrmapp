import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../bloc/leave_bloc.dart';
import '../bloc/leave_event.dart';
import '../bloc/leave_state.dart';

class LeaveBalanceTab extends StatelessWidget {
  const LeaveBalanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveBloc, LeaveState>(
      builder: (context, state) {
        if (state is LeaveLoading) {
          return const ShimmerListLoader(itemHeight: 120);
        }
        if (state is LeaveError) {
          return ErrorView(
            message: state.failure.message,
            onRetry: () => context.read<LeaveBloc>().add(LoadBalance()),
          );
        }
        if (state is BalanceLoaded) {
          if (state.balances.isEmpty) {
            return const EmptyState(
              icon: Icons.beach_access_rounded,
              title: 'No leave balances',
            );
          }
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<LeaveBloc>().add(LoadBalance()),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.balances.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final b = state.balances[i];
                final usedRatio =
                    b.allocated > 0 ? (b.used / b.allocated).clamp(0.0, 1.0) : 0.0;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                b.leaveTypeName,
                                style: AppTextStyles.titleSmall,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '${b.remaining.toStringAsFixed(1)} left',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: usedRatio,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            _Stat(
                                'Allocated', b.allocated.toStringAsFixed(1)),
                            _Stat('Used', b.used.toStringAsFixed(1)),
                            _Stat('Pending', b.pending.toStringAsFixed(1)),
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

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(value, style: AppTextStyles.titleSmall),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
