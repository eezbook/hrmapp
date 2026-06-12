import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/location_cubit.dart';

const _navy   = Color(0xFF1B2064);
const _purple = Color(0xFF7367F0);
const _pageBg = Color(0xFFF5F7FF);
const _green  = Color(0xFF28C76F);

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocationCubit>()..load(),
      child: const _LocationView(),
    );
  }
}

class _LocationView extends StatefulWidget {
  const _LocationView();

  @override
  State<_LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<_LocationView> {
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();

  bool _useManual = false;

  @override
  void dispose() {
    _latCtrl.dispose();
    _lngCtrl.dispose();
    super.dispose();
  }

  void _onDetect() {
    context.read<LocationCubit>().detectAndSubmit();
  }

  void _onManualSubmit() {
    final lat = double.tryParse(_latCtrl.text.trim());
    final lng = double.tryParse(_lngCtrl.text.trim());

    if (lat == null || lat < -90 || lat > 90) {
      _showError('Latitude must be a number between -90 and 90.');
      return;
    }
    if (lng == null || lng < -180 || lng > 180) {
      _showError('Longitude must be a number between -180 and 180.');
      return;
    }

    context.read<LocationCubit>().submitManual(
      latitude: lat,
      longitude: lng,
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _goBack(BuildContext context) => context.goNamed(RouteNames.dashboard);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => _goBack(context),
      child: Scaffold(
        backgroundColor: _pageBg,
        appBar: AppBar(
          backgroundColor: _navy,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => _goBack(context),
          ),
          title: const Text(
            'My Location',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: BlocConsumer<LocationCubit, LocationState>(
        listener: (ctx, state) {
          if (state is LocationError) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
            // reload so it goes back to loaded state
            ctx.read<LocationCubit>().clearError();
          }
        },
        builder: (ctx, state) {
          if (state is LocationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LocationSubmitted) {
            return _SuccessView(
              latitude: state.latitude,
              longitude: state.longitude,
            );
          }

          if (state is LocationLoaded) {
            if (!state.allowUpdate) {
              return _NotPermittedView(
                hasExistingLocation: state.currentLatitude != null,
                existingLatitude: state.currentLatitude,
                existingLongitude: state.currentLongitude,
                locationName: state.currentLocationName,
              );
            }

            return _UpdateFormView(
              state: state,
              useManual: _useManual,
              latCtrl: _latCtrl,
              lngCtrl: _lngCtrl,
              onToggleManual: () => setState(() => _useManual = !_useManual),
              onDetect: _onDetect,
              onManualSubmit: _onManualSubmit,
            );
          }

          if (state is LocationDetecting || state is LocationSubmitting) {
            final msg = state is LocationDetecting
                ? 'Getting your GPS location…'
                : 'Saving location…';
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(msg, style: AppTextStyles.bodyMedium),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    ),
    );
  }
}

// ── Not permitted view ────────────────────────────────────────────────────────

class _NotPermittedView extends StatelessWidget {
  final bool hasExistingLocation;
  final double? existingLatitude;
  final double? existingLongitude;
  final String locationName;

  const _NotPermittedView({
    required this.hasExistingLocation,
    required this.existingLatitude,
    required this.existingLongitude,
    required this.locationName,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: _purple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_outline_rounded,
                color: _purple, size: 40),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Location Update Not Enabled',
            style: TextStyle(
              color: _navy,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Your administrator has not enabled location update permission for your account. '
            'Please contact your administrator to allow you to set your home/WFH location.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          if (hasExistingLocation && existingLatitude != null) ...[
            const SizedBox(height: AppSpacing.lg),
            _InfoCard(
              icon: Icons.location_on_rounded,
              iconColor: _green,
              title: 'Current Saved Location',
              subtitle: '${locationName.isNotEmpty ? locationName : 'Home'}'
                  '\n${existingLatitude!.toStringAsFixed(6)}, '
                  '${existingLongitude!.toStringAsFixed(6)}',
            ),
          ],
        ],
      ),
    );
  }
}

// ── Update form view ──────────────────────────────────────────────────────────

class _UpdateFormView extends StatelessWidget {
  final LocationLoaded state;
  final bool useManual;
  final TextEditingController latCtrl;
  final TextEditingController lngCtrl;
  final VoidCallback onToggleManual;
  final VoidCallback onDetect;
  final VoidCallback onManualSubmit;

  const _UpdateFormView({
    required this.state,
    required this.useManual,
    required this.latCtrl,
    required this.lngCtrl,
    required this.onToggleManual,
    required this.onDetect,
    required this.onManualSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // info banner
          _InfoCard(
            icon: Icons.info_outline_rounded,
            iconColor: _purple,
            title: 'One-Time Location Update',
            subtitle: 'You can update your home / WFH location once. '
                'After saving, this permission will be automatically revoked '
                'and your administrator will need to re-enable it.',
          ),

          const SizedBox(height: AppSpacing.lg),

          // existing location
          if (state.currentLatitude != null) ...[
            _InfoCard(
              icon: Icons.location_on_rounded,
              iconColor: _green,
              title: 'Current Saved Location',
              subtitle:
                  '${state.currentLocationName}\n'
                  '${state.currentLatitude!.toStringAsFixed(6)}, '
                  '${state.currentLongitude!.toStringAsFixed(6)}',
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // mode toggle
          Row(
            children: [
              Expanded(
                child: _ModeChip(
                  label: 'Auto-detect GPS',
                  icon: Icons.my_location_rounded,
                  selected: !useManual,
                  onTap: useManual ? onToggleManual : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ModeChip(
                  label: 'Enter manually',
                  icon: Icons.edit_location_alt_outlined,
                  selected: useManual,
                  onTap: !useManual ? onToggleManual : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          if (!useManual) ...[
            // auto-detect mode
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GPS Auto-Detect',
                    style: AppTextStyles.titleSmall.copyWith(color: _navy),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Go to your home / WFH location and tap the button below. '
                    'The app will capture your current GPS coordinates.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onDetect,
                      icon: const Icon(Icons.my_location_rounded),
                      label: const Text(
                        'Detect My Location & Save',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // manual mode
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manual Coordinates',
                    style: AppTextStyles.titleSmall.copyWith(color: _navy),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Open Google Maps at your location, long-press the pin, '
                    'and copy the lat/lng shown at the bottom.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: latCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[-0-9.]'),
                      ),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      hintText: 'e.g. 24.860966',
                      prefixIcon: Icon(Icons.north),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: lngCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[-0-9.]'),
                      ),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      hintText: 'e.g. 67.010232',
                      prefixIcon: Icon(Icons.east),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onManualSubmit,
                      icon: const Icon(Icons.save_alt_rounded),
                      label: const Text(
                        'Save Location',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

// ── Success view ──────────────────────────────────────────────────────────────

class _SuccessView extends StatelessWidget {
  final double latitude;
  final double longitude;

  const _SuccessView({
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: _green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_outline_rounded,
                color: _green, size: 44),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Location Saved!',
            style: TextStyle(
              color: _navy,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Your work location has been updated successfully. '
            'The update permission has been automatically revoked.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          _InfoCard(
            icon: Icons.location_on_rounded,
            iconColor: _green,
            title: 'Saved Location',
            subtitle:
                '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}',
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ─────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const _ModeChip({
    required this.label,
    required this.icon,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? _purple : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? _purple : Colors.grey.shade300,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _purple.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: selected ? Colors.white : Colors.grey.shade600),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

