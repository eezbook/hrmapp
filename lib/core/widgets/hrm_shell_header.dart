import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../config/route_names.dart';
import '../cubit/hrm_header_cubit.dart';
import '../di/injection.dart';
import '../storage/hive_storage.dart';
import '../theme/app_text_styles.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/models/company_model.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';

const _navy   = Color(0xFF1B2064);
const _purple = Color(0xFF7367F0);

/// Placed ONCE in the shell scaffold body. Reads from [HrmHeaderCubit] so
/// it never remounts — only the subtitle and bottom slot change reactively.
class HrmShellHeader extends StatelessWidget {
  const HrmShellHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final raw    = HiveStorage.employee.get(HiveKeys.employee) as Map?;
    final name   = raw?['name']  as String? ?? 'Employee';
    final photo  = raw?['photo'] as String?;
    final first  = name.trim().split(' ').first;
    final initials = name
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return BlocBuilder<HrmHeaderCubit, HrmHeaderState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: _navy,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Main row ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Hamburger / company switcher
                      GestureDetector(
                        onTap: () => _showCompanySwitcher(context),
                        child: const Icon(Icons.menu_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),

                      // Greeting + subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, $first!',
                              style: AppTextStyles.titleLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                            if (state.subtitle.isNotEmpty) ...[
                              const SizedBox(height: 1),
                              Text(
                                state.subtitle,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Offline chip
                      if (state.isOffline) ...[
                        _OfflineChip(),
                        const SizedBox(width: 8),
                      ],

                      // Notification bell
                      GestureDetector(
                        onTap: () => context.goNamed(RouteNames.notifications),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.notifications_outlined,
                                  color: Colors.white, size: 22),
                            ),
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFC107),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Avatar
                      GestureDetector(
                        onTap: () => context.goNamed(RouteNames.profile),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white.withOpacity(0.15),
                          backgroundImage:
                              photo != null ? NetworkImage(photo) : null,
                          child: photo == null
                              ? Text(
                                  initials,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Bottom slot (tabs / time pills / etc.) ─────────────────
                if (state.bottom != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: state.bottom!,
                  )
                else
                  const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCompanySwitcher(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CompanySwitcherSheet(
        onSwitch: (id) {
          Navigator.pop(context);
          context.read<AuthBloc>().add(SwitchCompanyRequested(id));
        },
      ),
    );
  }
}

// ── Offline chip ──────────────────────────────────────────────────────────────

class _OfflineChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'No internet — working offline',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.red.shade700,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.white, size: 14),
            SizedBox(width: 4),
            Text(
              'Offline',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Company switcher (used by hamburger) ──────────────────────────────────────

class _CompanySwitcherSheet extends StatefulWidget {
  final void Function(int companyId) onSwitch;
  const _CompanySwitcherSheet({required this.onSwitch});

  @override
  State<_CompanySwitcherSheet> createState() => _CompanySwitcherSheetState();
}

class _CompanySwitcherSheetState extends State<_CompanySwitcherSheet> {
  List<CompanyModel> _companies = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await getIt<AuthRemoteDataSource>().getCompanies();
      setState(() {
        _companies = res.data ?? [];
        _loading   = false;
      });
    } catch (_) {
      setState(() {
        _error   = 'Failed to load companies';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Text('Switch Company',
                      style: AppTextStyles.titleSmall),
                ],
              ),
            ),
            const Divider(height: 16),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(color: _purple),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_error!,
                    style: const TextStyle(color: Colors.red)),
              )
            else
              ..._companies.map(
                (c) => ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20),
                  leading: CircleAvatar(
                    backgroundColor:
                        c.isCurrent ? _purple : Colors.grey.shade100,
                    child: Text(
                      c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: c.isCurrent ? Colors.white : _navy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(c.name),
                  trailing: c.isCurrent
                      ? const Icon(Icons.check_circle_rounded,
                          color: _purple)
                      : null,
                  onTap: c.isCurrent ? null : () => widget.onSwitch(c.id),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
