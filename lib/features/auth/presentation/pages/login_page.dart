import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/storage/hive_storage.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

const _navy = Color(0xFF1B2064);
const _purple = Color(0xFF7367F0);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _biometricEnabled = HiveStorage.app
        .get(HiveKeys.biometricEnabled, defaultValue: false) as bool;
    _rememberMe =
        HiveStorage.app.get('rememberMe', defaultValue: false) as bool;
    if (_rememberMe) {
      _emailCtrl.text =
          HiveStorage.app.get('savedEmail', defaultValue: '') as String;
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    HiveStorage.app.put('rememberMe', _rememberMe);
    if (_rememberMe) {
      HiveStorage.app.put('savedEmail', _emailCtrl.text.trim());
    } else {
      HiveStorage.app.delete('savedEmail');
    }
    context.read<AuthBloc>().add(
          LoginRequested(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.goNamed(RouteNames.dashboard);
          } else if (state is AuthError) {
            final msg = state.hrmCode == 'HRM_AUTH_001'
                ? 'You are not authorised to access this app. Contact HR Admin.'
                : state.message;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: scheme.error,
              ),
            );
          }
        },
        child: Column(
          children: [
            // ── White top section ──────────────────────────────────────────
            Expanded(
              flex: 45,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo top-left
                      _LogoWidget(),
                      // Illustration fills remaining space
                      const Expanded(child: _Illustration()),
                      // Dots indicator
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (i) {
                              return Container(
                                width: i == 0 ? 22 : 8,
                                height: 8,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: i == 0
                                      ? _purple
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Dark navy form section ─────────────────────────────────────
            Expanded(
              flex: 55,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: _navy,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(36),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 30, 28, 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ← Login
                        Row(
                          children: [
                            const Icon(Icons.arrow_back_rounded,
                                color: Colors.white, size: 22),
                            const SizedBox(width: 10),
                            Text(
                              'Login',
                              style: AppTextStyles.titleLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Username
                        _NavyField(
                          controller: _emailCtrl,
                          hintText: 'Username',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: Validators.email,
                        ),
                        const SizedBox(height: 16),

                        // Password
                        _NavyField(
                          controller: _passwordCtrl,
                          hintText: 'Password',
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          validator: Validators.password,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: Icon(
                                _obscurePassword
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.white38,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Go to Dashboard button
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) => SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed:
                                  state is AuthLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _purple,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor:
                                    _purple.withOpacity(0.5),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: state is AuthLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Go to Dashboard',
                                      style:
                                          AppTextStyles.labelLarge.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),

                        // Remember Me + Forgot Password
                        Row(
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: Checkbox(
                                value: _rememberMe,
                                activeColor: _purple,
                                checkColor: Colors.white,
                                side: const BorderSide(
                                    color: Colors.white38, width: 1.5),
                                shape: const CircleBorder(),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                onChanged: (v) =>
                                    setState(() => _rememberMe = v ?? false),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _rememberMe = !_rememberMe),
                              child: Text(
                                'Remember Me',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white60,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () =>
                                  context.goNamed(RouteNames.forgotPassword),
                              child: Text(
                                'Forgot Password?',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white60,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Biometric (if enabled)
                        if (_biometricEnabled) ...[
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: OutlinedButton.icon(
                              onPressed: () => context
                                  .read<AuthBloc>()
                                  .add(BiometricRequested()),
                              icon: const Icon(Icons.fingerprint_rounded,
                                  color: Colors.white),
                              label: const Text(
                                'Sign in with Biometrics',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Colors.white30, width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Logo widget ────────────────────────────────────────────────────────────────
class _LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppConfig.logoAsset,
      width: 44,
      height: 44,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => CustomPaint(
        size: const Size(44, 44),
        painter: _LogoPainter(),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    // Left leaf (navy)
    paint.color = _navy;
    final path1 = Path()
      ..moveTo(size.width * 0.35, size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.05, size.height * 0.5,
          size.width * 0.35, size.height * 0.85)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.5,
          size.width * 0.35, size.height * 0.15);
    canvas.drawPath(path1, paint);
    // Right leaf (purple)
    paint.color = _purple;
    final path2 = Path()
      ..moveTo(size.width * 0.38, size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.35,
          size.width * 0.65, size.height * 0.72)
      ..quadraticBezierTo(size.width * 0.45, size.height * 0.5,
          size.width * 0.38, size.height * 0.15);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Illustration widget ────────────────────────────────────────────────────────
class _Illustration extends StatelessWidget {
  const _Illustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260,
        height: 200,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Chart card (top-right)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 155,
                height: 130,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEECFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Globe / donut chart
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: CustomPaint(painter: _DonutPainter()),
                      ),
                    ),
                    const Spacer(),
                    // Bar chart
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _Bar(h: 32, color: _navy),
                        _Bar(h: 52, color: _navy),
                        _Bar(h: 24, color: _purple),
                        _Bar(h: 44, color: _navy),
                        _Bar(h: 38, color: _purple),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Calendar grid (bottom-left)
            Positioned(
              left: 0,
              bottom: 10,
              child: Container(
                width: 100,
                height: 85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    // Month header dot
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: _purple,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Calendar dots grid (3 rows x 5 cols)
                    ...List.generate(3, (row) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: List.generate(5, (col) {
                            final isHighlighted =
                                (row == 1 && col == 2) ||
                                    (row == 0 && col == 4);
                            return Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: isHighlighted
                                    ? _purple
                                    : (row == 0 && col == 1
                                        ? const Color(0xFFFFC107)
                                        : Colors.grey.shade200),
                                shape: BoxShape.circle,
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Person sitting (center-right of illustration)
            Positioned(
              left: 70,
              bottom: 0,
              child: _PersonFigure(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Donut/pie chart painter ────────────────────────────────────────────────────
class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    paint.color = const Color(0xFFFFC107);
    canvas.drawArc(rect, -1.57, 2.5, false, paint);

    paint.color = _navy;
    canvas.drawArc(rect, 0.93, 3.78, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Person figure (simplified geometric) ──────────────────────────────────────
class _PersonFigure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 110,
      child: CustomPaint(painter: _PersonPainter()),
    );
  }
}

class _PersonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;

    // Head
    paint.color = const Color(0xFFFFB74D);
    canvas.drawCircle(Offset(w * 0.55, h * 0.12), h * 0.09, paint);

    // Body / torso (purple shirt)
    paint.color = _purple;
    final torso = Path()
      ..moveTo(w * 0.35, h * 0.25)
      ..lineTo(w * 0.75, h * 0.25)
      ..lineTo(w * 0.78, h * 0.55)
      ..lineTo(w * 0.32, h * 0.55)
      ..close();
    canvas.drawPath(torso, paint);

    // Lap / legs (yellow)
    paint.color = const Color(0xFFFFC107);
    final legs = Path()
      ..moveTo(w * 0.15, h * 0.55)
      ..quadraticBezierTo(w * 0.25, h * 0.75, w * 0.45, h * 0.75)
      ..lineTo(w * 0.78, h * 0.55)
      ..close();
    canvas.drawPath(legs, paint);

    // Laptop screen
    paint.color = Colors.white;
    final screen = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.28, h * 0.42, w * 0.44, h * 0.22),
      const Radius.circular(4),
    );
    canvas.drawRRect(screen, paint);
    paint.color = const Color(0xFFEEECFF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.30, h * 0.44, w * 0.40, h * 0.18),
        const Radius.circular(3),
      ),
      paint,
    );

    // Left arm
    paint.color = const Color(0xFFFFB74D);
    final arm = Path()
      ..moveTo(w * 0.35, h * 0.30)
      ..quadraticBezierTo(w * 0.10, h * 0.45, w * 0.22, h * 0.58)
      ..lineTo(w * 0.28, h * 0.52)
      ..quadraticBezierTo(w * 0.18, h * 0.43, w * 0.40, h * 0.32)
      ..close();
    canvas.drawPath(arm, paint);

    // Shoes (navy)
    paint.color = _navy;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.10, h * 0.72, w * 0.20, h * 0.08),
        const Radius.circular(4),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.40, h * 0.72, w * 0.20, h * 0.08),
        const Radius.circular(4),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Bar widget ────────────────────────────────────────────────────────────────
class _Bar extends StatelessWidget {
  const _Bar({required this.h, required this.color});
  final double h;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 13,
      height: h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ── Dark field for navy background ────────────────────────────────────────────
class _NavyField extends StatelessWidget {
  const _NavyField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onFieldSubmitted,
    this.validator,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.35),
          fontSize: 14,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.07),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.18), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.18), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _purple, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Colors.orangeAccent, fontSize: 11),
      ),
    );
  }
}
