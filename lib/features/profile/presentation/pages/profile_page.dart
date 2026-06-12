import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/cubit/hrm_header_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/hive_storage.dart';
import '../../../../core/widgets/avatar_widget.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

const _navy   = Color(0xFF1B2064);
const _purple = Color(0xFF7367F0);
const _pageBg = Color(0xFFF5F7FF);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _biometricEnabled = HiveStorage.app.get(
          HiveKeys.biometricEnabled,
          defaultValue: false,
        ) as bool;
    getIt<HrmHeaderCubit>().update(
      subtitle: 'More & Settings',
      clearBottom: true,
    );
  }

  Future<void> _toggleBiometric(bool value) async {
    await HiveStorage.app.put(HiveKeys.biometricEnabled, value);
    setState(() => _biometricEnabled = value);
  }

  Future<void> _logout() async {
    final confirm = await ConfirmationDialog.show(
      context,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
      confirmLabel: 'Sign Out',
      isDangerous: true,
    );
    if (confirm == true && mounted) {
      context.read<AuthBloc>().add(LogoutRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeRaw =
        HiveStorage.employee.get(HiveKeys.employee) as Map?;
    final name        = employeeRaw?['name']          as String? ?? 'Employee';
    final email       = employeeRaw?['email']         as String? ?? '';
    final designation = employeeRaw?['designation']   as String? ?? '';
    final department  = employeeRaw?['department']    as String? ?? '';
    final photo       = employeeRaw?['photo']         as String?;
    final empCode     = employeeRaw?['employee_code'] as String? ?? '';

    return Scaffold(
      backgroundColor: _pageBg,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 48),
        children: [
          _ProfileCard(
            name: name,
            designation: designation,
            department: department,
            empCode: empCode,
            photo: photo,
          ),
          const SizedBox(height: 24),
          _SectionLabel('Account'),
          const SizedBox(height: 8),
          _MenuCard(children: [
            _MenuItem(
              icon: Icons.email_outlined,
              iconColor: _purple,
              title: 'Email Address',
              subtitle: email.isNotEmpty ? email : '—',
            ),
            _Divider(),
            _MenuItem(
              icon: Icons.badge_outlined,
              iconColor: const Color(0xFF0EA5E9),
              title: 'Employee Code',
              subtitle: empCode.isNotEmpty ? '#$empCode' : '—',
            ),
          ]),
          const SizedBox(height: 20),
          _SectionLabel('Work'),
          const SizedBox(height: 8),
          _MenuCard(children: [
            _MenuItem(
              icon: Icons.location_on_outlined,
              iconColor: const Color(0xFF28C76F),
              title: 'My Location',
              subtitle: 'Update your home / WFH check-in location',
              onTap: () => context.go('/location'),
            ),
          ]),
          const SizedBox(height: 20),
          _SectionLabel('Security'),
          const SizedBox(height: 8),
          _MenuCard(children: [
            _BiometricTile(
              value: _biometricEnabled,
              onChanged: _toggleBiometric,
            ),
          ]),
          const SizedBox(height: 20),
          _SectionLabel('Session'),
          const SizedBox(height: 8),
          _MenuCard(children: [
            _MenuItem(
              icon: Icons.logout_rounded,
              iconColor: Colors.redAccent,
              title: 'Sign Out',
              titleColor: Colors.redAccent,
              showChevron: false,
              onTap: _logout,
            ),
          ]),
        ],
      ),
    );
  }
}

// ── Profile card ──────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final String name;
  final String designation;
  final String department;
  final String empCode;
  final String? photo;

  const _ProfileCard({
    required this.name,
    required this.designation,
    required this.department,
    required this.empCode,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 64,
            decoration: const BoxDecoration(
              color: _navy,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -36),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: _navy.withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AvatarWidget(
                imageUrl: photo,
                name: name,
                radius: 38,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -28),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: _navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (designation.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      designation,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: [
                      if (department.isNotEmpty)
                        _Chip(
                          label: department,
                          icon: Icons.apartment_rounded,
                          color: _purple,
                        ),
                      if (empCode.isNotEmpty)
                        _Chip(
                          label: '#$empCode',
                          icon: Icons.tag_rounded,
                          color: const Color(0xFF0EA5E9),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _Chip({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section helpers ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<Widget> children;
  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 64),
      child: Container(height: 1, color: Colors.grey.shade100),
    );
  }
}

// ── Menu item ─────────────────────────────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color? titleColor;
  final String? subtitle;
  final bool showChevron;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.titleColor,
    this.subtitle,
    this.showChevron = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 19),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor ?? _navy,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
              Icon(Icons.chevron_right_rounded,
                  color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Biometric toggle ──────────────────────────────────────────────────────────

class _BiometricTile extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;
  const _BiometricTile({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.fingerprint_rounded,
                color: _purple, size: 21),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Biometric Login',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Use fingerprint or Face ID to sign in',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _purple,
            activeTrackColor: _purple.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
