import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/repositories/auth_repository.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _loading = false;
  String? _error;
  double _strength = 0;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _onPasswordChanged(String value) {
    double s = 0;
    if (value.length >= 8) s += 0.25;
    if (value.contains(RegExp(r'[A-Z]'))) s += 0.25;
    if (value.contains(RegExp(r'[0-9]'))) s += 0.25;
    if (value.contains(RegExp(r'[!@#\$%^&*]'))) s += 0.25;
    setState(() => _strength = s);
  }

  Color get _strengthColor {
    if (_strength < 0.25) return Colors.red;
    if (_strength < 0.5) return Colors.orange;
    if (_strength < 0.75) return Colors.amber;
    return Colors.green;
  }

  String get _strengthLabel {
    if (_strength < 0.25) return 'Weak';
    if (_strength < 0.5) return 'Fair';
    if (_strength < 0.75) return 'Good';
    return 'Strong';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await getIt<AuthRepository>().resetPassword(
      email: widget.email,
      otp: widget.otp,
      password: _passwordCtrl.text,
      passwordConfirmation: _confirmCtrl.text,
    );
    if (!mounted) return;
    result.fold(
      (f) => setState(() {
        _loading = false;
        _error = f.message;
      }),
      (_) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successfully')),
        );
        context.goNamed(RouteNames.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Create new password',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscure1,
                  onChanged: _onPasswordChanged,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure1
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscure1 = !_obscure1),
                    ),
                  ),
                  validator: Validators.password,
                ),
                if (_strength > 0) ...[
                  const SizedBox(height: AppSpacing.sm),
                  LinearProgressIndicator(
                    value: _strength,
                    color: _strengthColor,
                    backgroundColor:
                        scheme.surfaceVariant,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Password strength: $_strengthLabel',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _strengthColor,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: _obscure2,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure2
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscure2 = !_obscure2),
                    ),
                  ),
                  validator: (v) =>
                      Validators.confirmPassword(v, _passwordCtrl.text),
                ),
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _error!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Reset Password',
                  isLoading: _loading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
