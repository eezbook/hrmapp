import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.goNamed(RouteNames.dashboard);
        } else if (state is AuthUnauthenticated || state is AuthError) {
          context.goNamed(RouteNames.login);
        }
      },
      child: Scaffold(
        backgroundColor: scheme.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppConfig.logoAsset,
                width: 120,
                height: 120,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.business_center_rounded,
                  size: 80,
                  color: scheme.onPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppConfig.clientName,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Human Resource Management',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: scheme.onPrimary.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 48),
              CircularProgressIndicator(
                color: scheme.onPrimary.withOpacity(0.7),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
