import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/repositories/auth_repository.dart';

class OtpVerifyPage extends StatefulWidget {
  final String email;

  const OtpVerifyPage({super.key, required this.email});

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  static const _otpLength = 6;
  static const _resendSeconds = 120;

  final _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final _focusNodes = List.generate(_otpLength, (_) => FocusNode());

  bool _loading = false;
  String? _error;
  int _countdown = _resendSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdown = _resendSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown == 0) {
        t.cancel();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_otp.length != _otpLength) {
      setState(() => _error = 'Please enter the 6-digit code');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await getIt<AuthRepository>()
        .verifyOtp(email: widget.email, otp: _otp);
    if (!mounted) return;
    result.fold(
      (f) => setState(() {
        _loading = false;
        _error = f.message;
      }),
      (_) {
        setState(() => _loading = false);
        context.goNamed(
          RouteNames.resetPassword,
          queryParameters: {'email': widget.email, 'otp': _otp},
        );
      },
    );
  }

  Future<void> _resend() async {
    await getIt<AuthRepository>().forgotPassword(widget.email);
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Enter verification code',
                style: AppTextStyles.titleLarge.copyWith(
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'We sent a 6-digit code to ${widget.email}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  _otpLength,
                  (i) => SizedBox(
                    width: 48,
                    child: TextFormField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                      style: AppTextStyles.titleLarge,
                      decoration: const InputDecoration(
                        counterText: '',
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && i < _otpLength - 1) {
                          _focusNodes[i + 1].requestFocus();
                        }
                        if (value.isEmpty && i > 0) {
                          _focusNodes[i - 1].requestFocus();
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _error!,
                  style:
                      AppTextStyles.bodySmall.copyWith(color: scheme.error),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Verify',
                isLoading: _loading,
                onPressed: _verify,
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: _countdown > 0
                    ? Text(
                        'Resend code in ${_countdown}s',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      )
                    : TextButton(
                        onPressed: _resend,
                        child: const Text('Resend code'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
