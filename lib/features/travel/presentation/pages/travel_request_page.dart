import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/travel_bloc.dart';
import '../bloc/travel_event.dart';
import '../bloc/travel_state.dart';

class TravelRequestPage extends StatefulWidget {
  const TravelRequestPage({super.key});

  @override
  State<TravelRequestPage> createState() => _TravelRequestPageState();
}

class _TravelRequestPageState extends State<TravelRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _purposeCtrl = TextEditingController();
  final _originCtrl = TextEditingController();
  final _destinationCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  DateTime? _departure;
  DateTime? _returnDate;
  String _transportMode = 'flight';
  String? _error;

  final _transportModes = ['flight', 'train', 'bus', 'car', 'other'];

  @override
  void dispose() {
    _purposeCtrl.dispose();
    _originCtrl.dispose();
    _destinationCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isDeparture) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isDeparture ? (_departure ?? now) : (_returnDate ?? now),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isDeparture) {
          _departure = picked;
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_departure == null || _returnDate == null) {
      setState(() => _error = 'Please select travel dates');
      return;
    }
    context.read<TravelBloc>().add(
          CreateTravelRequest({
            'purpose': _purposeCtrl.text.trim(),
            'origin': _originCtrl.text.trim(),
            'destination': _destinationCtrl.text.trim(),
            'departure_date': HrmDateUtils.formatApi(_departure!),
            'return_date': HrmDateUtils.formatApi(_returnDate!),
            'transport_mode': _transportMode,
            'estimated_budget':
                double.tryParse(_budgetCtrl.text.replaceAll(',', '')) ?? 0,
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('New Travel Request')),
      body: BlocListener<TravelBloc, TravelState>(
        listener: (ctx, state) {
          if (state is TravelRequestCreated) {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(
                content: Text('Travel request submitted'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is TravelError) {
            setState(() => _error = state.failure.message);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _purposeCtrl,
                  decoration: const InputDecoration(labelText: 'Purpose'),
                  validator: (v) => Validators.required(v, 'Purpose'),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _originCtrl,
                  decoration: const InputDecoration(labelText: 'Origin'),
                  validator: (v) => Validators.required(v, 'Origin'),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _destinationCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Destination'),
                  validator: (v) =>
                      Validators.required(v, 'Destination'),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _DateField(
                        label: 'Departure',
                        value: _departure,
                        onTap: () => _pickDate(true),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _DateField(
                        label: 'Return',
                        value: _returnDate,
                        onTap: () => _pickDate(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  value: _transportMode,
                  decoration:
                      const InputDecoration(labelText: 'Transport Mode'),
                  items: _transportModes
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(
                                m[0].toUpperCase() + m.substring(1)),
                          ))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _transportMode = v!),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _budgetCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Estimated Budget',
                    prefixText: 'PKR ',
                  ),
                  validator: Validators.amount,
                ),
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(_error!,
                      style: TextStyle(color: scheme.error)),
                ],
                const SizedBox(height: AppSpacing.lg),
                BlocBuilder<TravelBloc, TravelState>(
                  builder: (_, state) => AppButton(
                    label: 'Submit Request',
                    isLoading: state is TravelLoading,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: scheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outline.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 16),
            const SizedBox(width: 8),
            Text(
              value != null
                  ? HrmDateUtils.formatDisplay(value!)
                  : label,
              style: TextStyle(
                color: value != null
                    ? scheme.onSurface
                    : scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
