import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

const _navy   = Color(0xFF1B2064);
const _purple = Color(0xFF7367F0);

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  // Logo: elastic scale-in + fade
  late final AnimationController _logoCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final Animation<double> _logoScale = Tween(begin: 0.25, end: 1.0)
      .animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
  late final Animation<double> _logoOpacity = Tween(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(
          parent: _logoCtrl, curve: const Interval(0.0, 0.4)));

  // Text block: fade + slide up
  late final AnimationController _textCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 550),
  );
  late final Animation<double> _textOpacity = Tween(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn));
  late final Animation<double> _textSlide = Tween(begin: 24.0, end: 0.0)
      .animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));

  // Dots pulsing loader
  late final AnimationController _dotsCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void initState() {
    super.initState();
    _logoCtrl.forward().then((_) => _textCtrl.forward());
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _dotsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.goNamed(RouteNames.dashboard);
        } else if (state is AuthUnauthenticated || state is AuthError) {
          context.goNamed(RouteNames.login);
        }
      },
      child: Scaffold(
        backgroundColor: _navy,
        body: Stack(
          children: [
            // Purple glow circle top-right
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _purple.withOpacity(0.15),
                ),
              ),
            ),
            // Purple glow circle bottom-left
            Positioned(
              bottom: -60,
              left: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _purple.withOpacity(0.10),
                ),
              ),
            ),

            // Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo
                  AnimatedBuilder(
                    animation: _logoCtrl,
                    builder: (_, child) => Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: child,
                      ),
                    ),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.all(18),
                      child: Image.asset(
                        AppConfig.logoAsset,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.business_center_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Animated app name + subtitle
                  AnimatedBuilder(
                    animation: _textCtrl,
                    builder: (_, child) => Opacity(
                      opacity: _textOpacity.value,
                      child: Transform.translate(
                        offset: Offset(0, _textSlide.value),
                        child: child,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppConfig.clientName,
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Human Resource Management',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white54,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Pulsing dots at bottom
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _dotsCtrl,
                builder: (_, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final interval = Interval(
                      i * 0.25,
                      0.6 + i * 0.15,
                      curve: Curves.easeInOut,
                    );
                    final t = interval.transform(_dotsCtrl.value);
                    final scale = 0.5 + 0.5 * t;
                    final opacity = 0.3 + 0.7 * t;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Opacity(
                        opacity: opacity.clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: _purple,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
