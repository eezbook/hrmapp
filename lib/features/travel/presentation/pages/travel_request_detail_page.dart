import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../domain/entities/travel_request.dart';
import '../bloc/travel_bloc.dart';
import '../bloc/travel_event.dart';
import '../bloc/travel_state.dart';

class TravelRequestDetailPage extends StatefulWidget {
  final int id;
  const TravelRequestDetailPage({super.key, required this.id});

  @override
  State<TravelRequestDetailPage> createState() =>
      _TravelRequestDetailPageState();
}

class _TravelRequestDetailPageState extends State<TravelRequestDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<TravelBloc>().add(LoadTravelRequestDetail(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel Request')),
      body: BlocConsumer<TravelBloc, TravelState>(
        listener: (context, state) {
          if (state is TravelActionSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Request cancelled')),
            );
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
                  .add(LoadTravelRequestDetail(widget.id)),
            );
          }
          if (state is TravelRequestDetailLoaded) {
            return _Body(request: state.request);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final TravelRequest request;
  const _Body({required this.request});

  bool get _canCancel =>
      request.status == 'draft' || request.status == 'pending';

  int get _totalDays {
    try {
      final dep = DateTime.parse(request.departureDate);
      final ret = DateTime.parse(request.returnDate);
      return ret.difference(dep).inDays + 1;
    } catch (_) {
      return 0;
    }
  }

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
                // ── Status + header card ──────────────────────────────────
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _InfoRow('Status', '', status: request.status),
                        _InfoRow('Purpose', request.purpose),
                        _InfoRow('Type', request.transportMode.isNotEmpty
                            ? 'Via ${request.transportMode}'
                            : '—'),
                        _InfoRow('From', request.origin.isNotEmpty
                            ? request.origin
                            : '—'),
                        _InfoRow('To', request.destination),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Dates card ─────────────────────────────────────────────
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _InfoRow(
                          'Departure',
                          HrmDateUtils.formatDisplay(
                              DateTime.parse(request.departureDate)),
                        ),
                        _InfoRow(
                          'Return',
                          HrmDateUtils.formatDisplay(
                              DateTime.parse(request.returnDate)),
                        ),
                        _InfoRow('Total Days', '$_totalDays day(s)'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Budget card ────────────────────────────────────────────
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _InfoRow(
                          'Estimated Budget',
                          CurrencyUtils.formatPkr(request.estimatedBudget),
                        ),
                        if (request.budgetLimit != null)
                          _InfoRow(
                            'Policy Limit',
                            CurrencyUtils.formatPkr(request.budgetLimit!),
                          ),
                        if (request.createdAt != null)
                          _InfoRow(
                            'Requested On',
                            HrmDateUtils.formatDisplay(
                                DateTime.parse(request.createdAt!)),
                          ),
                      ],
                    ),
                  ),
                ),

                // ── New Expense Claim button ───────────────────────────────
                if (request.isApproved) ...[
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => context.goNamed(
                        RouteNames.expenseClaim,
                        queryParameters: {
                          'travelId': request.id.toString(),
                        },
                      ),
                      icon: const Icon(Icons.receipt_long_outlined),
                      label: const Text('File Expense Claim'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // ── Bottom cancel bar ─────────────────────────────────────────────
        if (_canCancel)
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
            child: SizedBox(
              width: double.infinity,
              child: BlocBuilder<TravelBloc, TravelState>(
                builder: (context, state) => OutlinedButton.icon(
                  onPressed: state is TravelLoading
                      ? null
                      : () async {
                          final confirm = await ConfirmationDialog.show(
                            context,
                            title: 'Cancel Request',
                            message:
                                'Are you sure you want to cancel this travel request?',
                            confirmLabel: 'Cancel Request',
                            isDangerous: true,
                          );
                          if (confirm == true && context.mounted) {
                            context
                                .read<TravelBloc>()
                                .add(CancelTravelRequest(request.id));
                          }
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: scheme.error,
                  ),
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancel Request'),
                ),
              ),
            ),
          ),
      ],
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
