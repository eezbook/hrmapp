import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../cubit/leave_balance_cubit.dart';

const _navy   = Color(0xFF1B2064);
const _purple = Color(0xFF7367F0);

class LeaveBalanceTab extends StatelessWidget {
  const LeaveBalanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveBalanceCubit, LeaveBalanceState>(
      builder: (context, state) {
        if (state is LeaveBalanceLoading) {
          return const ShimmerBalanceList();
        }
        if (state is LeaveBalanceError) {
          return ErrorView(
            message: state.message,
            onRetry: () => context.read<LeaveBalanceCubit>().load(),
          );
        }
        if (state is LeaveBalanceLoaded) {
          if (state.balances.isEmpty) {
            return const EmptyState(
              icon: Icons.beach_access_rounded,
              title: 'No leave balances',
              subtitle:
                  'No leave types have been configured. Contact admin.',
            );
          }
          return RefreshIndicator(
            color: _purple,
            onRefresh: () => context.read<LeaveBalanceCubit>().load(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              itemCount: state.balances.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final b = state.balances[i];
                final usedRatio = b.allocated > 0
                    ? (b.used / b.allocated).clamp(0.0, 1.0)
                    : 0.0;
                return _BalanceCard(
                  leaveTypeName: b.leaveTypeName,
                  allocated: b.allocated,
                  used: b.used,
                  pending: b.pending,
                  remaining: b.remaining,
                  usedRatio: usedRatio,
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

class _BalanceCard extends StatelessWidget {
  final String leaveTypeName;
  final double allocated;
  final double used;
  final double pending;
  final double remaining;
  final double usedRatio;

  const _BalanceCard({
    required this.leaveTypeName,
    required this.allocated,
    required this.used,
    required this.pending,
    required this.remaining,
    required this.usedRatio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + remaining pill
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.beach_access_rounded,
                          color: _purple, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        leaveTypeName,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: _navy,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${remaining.toStringAsFixed(1)} left',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _purple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: usedRatio,
              minHeight: 8,
              backgroundColor: _purple.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation(_purple),
            ),
          ),

          const SizedBox(height: 14),

          // Stats row
          Row(
            children: [
              _StatBox(
                  label: 'Allocated',
                  value: allocated.toStringAsFixed(1)),
              _Divider(),
              _StatBox(label: 'Used', value: used.toStringAsFixed(1)),
              _Divider(),
              _StatBox(
                  label: 'Pending', value: pending.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.titleSmall.copyWith(
              color: _navy,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey.shade500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      color: Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
