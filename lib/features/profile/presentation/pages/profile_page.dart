import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/hive_storage.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/avatar_widget.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

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
    final scheme = Theme.of(context).colorScheme;
    final employeeRaw =
        HiveStorage.employee.get(HiveKeys.employee) as Map?;
    final name = employeeRaw?['name'] as String? ?? 'Employee';
    final email = employeeRaw?['email'] as String? ?? '';
    final designation =
        employeeRaw?['designation'] as String? ?? '';
    final department =
        employeeRaw?['department'] as String? ?? '';
    final photo = employeeRaw?['photo'] as String?;
    final employeeCode =
        employeeRaw?['employee_code'] as String? ?? '';

    return AppScaffold(
      title: 'Profile',
      body: ListView(
        children: [
          // Profile header
          Container(
            color: scheme.primary,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                AvatarWidget(
                  imageUrl: photo,
                  name: name,
                  radius: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: scheme.onPrimary,
                  ),
                ),
                if (designation.isNotEmpty)
                  Text(
                    '$designation · $department',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                if (employeeCode.isNotEmpty)
                  Text(
                    '#$employeeCode',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.onPrimary.withOpacity(0.6),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Info section
          _Section(
            title: 'Account Information',
            children: [
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                subtitle: Text(email),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Settings
          _Section(
            title: 'Security',
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.fingerprint_rounded),
                title: const Text('Biometric Login'),
                subtitle: const Text(
                    'Use fingerprint or face ID to sign in'),
                value: _biometricEnabled,
                onChanged: _toggleBiometric,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Sign out
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: Icon(Icons.logout, color: scheme.error),
              label: Text(
                'Sign Out',
                style: TextStyle(color: scheme.error),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: scheme.error.withOpacity(0.5)),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: scheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: children),
        ),
      ],
    );
  }
}
