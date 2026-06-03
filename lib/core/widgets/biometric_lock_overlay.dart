import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../services/biometric_service.dart';
import '../storage/hive_storage.dart';
import '../theme/app_text_styles.dart';

class BiometricLockObserver extends StatefulWidget {
  final Widget child;

  const BiometricLockObserver({super.key, required this.child});

  @override
  State<BiometricLockObserver> createState() =>
      _BiometricLockObserverState();
}

class _BiometricLockObserverState extends State<BiometricLockObserver>
    with WidgetsBindingObserver {
  DateTime? _backgroundAt;
  bool _locked = false;
  int _failCount = 0;
  final _bio = BiometricService();

  static const _lockAfterSeconds = 300;
  static const _maxFails = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _backgroundAt = DateTime.now();
    }
    if (state == AppLifecycleState.resumed) {
      _checkLock();
    }
  }

  void _checkLock() {
    final biometricEnabled = HiveStorage.app.get(
          HiveKeys.biometricEnabled,
          defaultValue: false,
        ) as bool;
    if (!biometricEnabled) return;
    if (_backgroundAt == null) return;
    final diff = DateTime.now().difference(_backgroundAt!).inSeconds;
    if (diff >= _lockAfterSeconds) {
      setState(() => _locked = true);
      _authenticate();
    }
  }

  Future<void> _authenticate() async {
    final success =
        await _bio.authenticate('Verify your identity to continue');
    if (success) {
      setState(() {
        _locked = false;
        _failCount = 0;
      });
    } else {
      _failCount++;
      if (_failCount >= _maxFails) {
        context.read<AuthBloc>().add(LogoutRequested());
        setState(() => _locked = false);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_locked)
          Positioned.fill(
            child: Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      size: 64,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'App Locked',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Verify your identity to continue',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: _authenticate,
                      icon: const Icon(Icons.fingerprint_rounded),
                      label: const Text('Authenticate'),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
