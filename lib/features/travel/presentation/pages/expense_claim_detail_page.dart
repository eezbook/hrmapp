import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../domain/entities/expense_claim.dart';
import '../bloc/travel_bloc.dart';
import '../bloc/travel_event.dart';
import '../bloc/travel_state.dart';

class ExpenseClaimDetailPage extends StatefulWidget {
  final int claimId;
  const ExpenseClaimDetailPage({super.key, required this.claimId});

  @override
  State<ExpenseClaimDetailPage> createState() => _ExpenseClaimDetailPageState();
}

class _ExpenseClaimDetailPageState extends State<ExpenseClaimDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<TravelBloc>().add(LoadExpenseClaimDetail(widget.claimId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Claim')),
      body: BlocConsumer<TravelBloc, TravelState>(
        listener: (context, state) {
          if (state is ExpenseSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Claim submitted for approval'),
                backgroundColor: Colors.green,
              ),
            );
            // Reload to reflect updated status
            context
                .read<TravelBloc>()
                .add(LoadExpenseClaimDetail(widget.claimId));
          } else if (state is TravelError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TravelLoading) return const ShimmerListLoader();
          if (state is TravelError) {
            return ErrorView(
              message: state.failure.message,
              onRetry: () => context
                  .read<TravelBloc>()
                  .add(LoadExpenseClaimDetail(widget.claimId)),
            );
          }
          if (state is ExpenseClaimDetailLoaded) {
            return _Body(claim: state.claim);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final ExpenseClaim claim;
  const _Body({required this.claim});

  bool get _isDraft => claim.status == 'draft';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Claim header ──────────────────────────────────────────
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _InfoRow('Title', claim.title),
                        _InfoRow('Status', '', status: claim.status),
                        if (claim.createdAt != null)
                          _InfoRow(
                            'Created',
                            HrmDateUtils.formatDisplay(
                                DateTime.parse(claim.createdAt!)),
                          ),
                        if (claim.travelRequestDestination != null)
                          _InfoRow('Travel', claim.travelRequestDestination!),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Budget summary card ───────────────────────────────────
                Card(
                  color: scheme.primaryContainer.withValues(alpha: 0.4),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Claimed',
                                style: AppTextStyles.bodySmall.copyWith(
                                    color: scheme.onSurfaceVariant)),
                            Text(
                              CurrencyUtils.formatPkr(claim.total),
                              style: AppTextStyles.titleSmall.copyWith(
                                  color: scheme.primary),
                            ),
                          ],
                        ),
                        if (claim.budgetAmount != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Budget Limit',
                                  style: AppTextStyles.bodySmall.copyWith(
                                      color: scheme.onSurfaceVariant)),
                              Text(
                                CurrencyUtils.formatPkr(claim.budgetAmount!),
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Remaining',
                                  style: AppTextStyles.bodySmall.copyWith(
                                      color: scheme.onSurfaceVariant)),
                              Text(
                                CurrencyUtils.formatPkr(claim.remaining),
                                style: AppTextStyles.titleSmall.copyWith(
                                  color: claim.remaining >= 0
                                      ? Colors.green.shade700
                                      : scheme.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Expense items ─────────────────────────────────────────
                Text('Expense Items', style: AppTextStyles.titleSmall),
                const SizedBox(height: AppSpacing.sm),

                if (claim.items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'No items added.',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: scheme.onSurfaceVariant),
                    ),
                  )
                else
                  ...claim.items.map((item) => _ItemCard(item: item)),
              ],
            ),
          ),
        ),

        // ── Bottom submit bar (draft only) ────────────────────────────────
        if (_isDraft)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: scheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BlocBuilder<TravelBloc, TravelState>(
              builder: (context, state) => SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: state is TravelLoading
                      ? null
                      : () async {
                          final confirm = await ConfirmationDialog.show(
                            context,
                            title: 'Submit for Approval',
                            message:
                                'Submit this expense claim for manager approval?',
                            confirmLabel: 'Submit',
                          );
                          if (confirm == true && context.mounted) {
                            context
                                .read<TravelBloc>()
                                .add(SubmitExpenseClaim(claim.id));
                          }
                        },
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('Submit for Approval'),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ItemCard extends StatelessWidget {
  final ExpenseItem item;
  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.category,
                    style: AppTextStyles.bodySmall
                        .copyWith(fontWeight: FontWeight.w600)),
                if (item.description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(item.description,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: scheme.onSurfaceVariant)),
                ],
                const SizedBox(height: 2),
                Text(
                  HrmDateUtils.formatDisplay(DateTime.parse(item.date)),
                  style: AppTextStyles.bodySmall
                      .copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            CurrencyUtils.formatPkr(item.amount),
            style: AppTextStyles.titleSmall.copyWith(color: scheme.primary),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final String? status;

  const _InfoRow(this.label, this.value, {this.status});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            flex: 3,
            child: status != null
                ? StatusPill(status!)
                : Text(value, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}
