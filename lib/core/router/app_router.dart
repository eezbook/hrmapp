import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../config/route_names.dart';
import '../di/injection.dart';
import '../permissions/hrm_permissions.dart';
import '../services/connectivity_service.dart';
import '../sync/sync_queue_service.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/otp_verify_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/leave/presentation/bloc/leave_bloc.dart';
import '../../features/leave/presentation/cubit/leave_balance_cubit.dart';
import '../../features/leave/presentation/cubit/leave_requests_cubit.dart';
import '../../features/leave/presentation/cubit/leave_approvals_cubit.dart';
import '../../features/leave/presentation/pages/apply_leave_page.dart';
import '../../features/leave/presentation/pages/leave_home_page.dart';
import '../../features/leave/presentation/pages/leave_request_detail_page.dart';
import '../../features/leave/presentation/pages/team_calendar_page.dart';
import '../../features/attendance/presentation/cubit/attendance_cubit.dart';
import '../../features/attendance/presentation/pages/attendance_home_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/overtime/presentation/cubit/overtime_cubit.dart';
import '../../features/overtime/presentation/pages/overtime_apply_page.dart';
import '../../features/overtime/presentation/pages/overtime_home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/training/presentation/bloc/assessment_cubit.dart';
import '../../features/training/presentation/bloc/course_player_cubit.dart';
import '../../features/training/presentation/bloc/training_bloc.dart';
import '../../features/training/presentation/pages/add_training_request_page.dart';
import '../../features/training/presentation/pages/assessment_page.dart';
import '../../features/training/presentation/pages/course_player_page.dart';
import '../../features/training/presentation/pages/training_home_page.dart';
import '../../features/travel/presentation/bloc/travel_bloc.dart';
import '../../features/travel/presentation/pages/expense_claim_page.dart';
import '../../features/travel/presentation/pages/travel_home_page.dart';
import '../../features/travel/presentation/pages/travel_request_page.dart';
import '../widgets/biometric_lock_overlay.dart';

class AppRouter {
  late final GoRouter router;

  AppRouter(AuthBloc authBloc) {
    router = GoRouter(
      initialLocation: '/splash',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isOnAuthRoute = state.matchedLocation.startsWith('/login') ||
            state.matchedLocation.startsWith('/forgot') ||
            state.matchedLocation.startsWith('/otp') ||
            state.matchedLocation.startsWith('/reset') ||
            state.matchedLocation == '/splash';

        if (authState is AuthUnauthenticated && !isOnAuthRoute) {
          return '/login';
        }
        if (authState is AuthAuthenticated && isOnAuthRoute) {
          return '/';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          name: RouteNames.splash,
          builder: (_, __) => const SplashPage(),
        ),
        GoRoute(
          path: '/login',
          name: RouteNames.login,
          builder: (_, __) => const LoginPage(),
        ),
        GoRoute(
          path: '/forgot-password',
          name: RouteNames.forgotPassword,
          builder: (_, __) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: '/otp-verify',
          name: RouteNames.otpVerify,
          builder: (context, state) {
            final email =
                state.uri.queryParameters['email'] ?? '';
            return OtpVerifyPage(email: email);
          },
        ),
        GoRoute(
          path: '/reset-password',
          name: RouteNames.resetPassword,
          builder: (context, state) => ResetPasswordPage(
            email: state.uri.queryParameters['email'] ?? '',
            otp: state.uri.queryParameters['otp'] ?? '',
          ),
        ),
        ShellRoute(
          builder: (context, state, child) => BiometricLockObserver(
            child: _ScaffoldWithNav(child: child),
          ),
          routes: [
            GoRoute(
              path: '/',
              redirect: (_, __) => '/dashboard',
            ),
            GoRoute(
              path: '/dashboard',
              name: RouteNames.dashboard,
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<DashboardCubit>(),
                child: const DashboardPage(),
              ),
            ),
            GoRoute(
              path: '/leave',
              name: RouteNames.leave,
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => getIt<LeaveBalanceCubit>()),
                  BlocProvider(create: (_) => getIt<LeaveRequestsCubit>()),
                  BlocProvider(create: (_) => getIt<LeaveApprovalsCubit>()),
                ],
                child: const LeaveHomePage(),
              ),
              routes: [
                GoRoute(
                  path: 'apply',
                  name: RouteNames.leaveApply,
                  builder: (context, state) => BlocProvider(
                    create: (_) => getIt<LeaveBloc>(),
                    child: const ApplyLeavePage(),
                  ),
                ),
                GoRoute(
                  path: 'requests/:id',
                  name: RouteNames.leaveDetail,
                  builder: (context, state) => BlocProvider(
                    create: (_) => getIt<LeaveBloc>(),
                    child: LeaveRequestDetailPage(
                      id: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                ),
                GoRoute(
                  path: 'approvals',
                  name: RouteNames.leaveApprovals,
                  redirect: (_, __) {
                    if (!HrmPermissions.canApproveLeave) {
                      return '/dashboard';
                    }
                    return null;
                  },
                  builder: (context, state) => MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (_) => getIt<LeaveBalanceCubit>()),
                      BlocProvider(create: (_) => getIt<LeaveRequestsCubit>()),
                      BlocProvider(create: (_) => getIt<LeaveApprovalsCubit>()),
                    ],
                    child: const LeaveHomePage(initialTab: 2),
                  ),
                ),
                GoRoute(
                  path: 'calendar',
                  name: RouteNames.leaveCalendar,
                  builder: (context, state) => BlocProvider(
                    create: (_) => getIt<LeaveBloc>(),
                    child: const TeamCalendarPage(),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: '/travel',
              name: RouteNames.travel,
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<TravelBloc>(),
                child: const TravelHomePage(),
              ),
              routes: [
                GoRoute(
                  path: 'request',
                  name: RouteNames.travelRequest,
                  builder: (context, state) => BlocProvider(
                    create: (_) => getIt<TravelBloc>(),
                    child: const TravelRequestPage(),
                  ),
                ),
                GoRoute(
                  path: 'requests/:id',
                  name: RouteNames.travelDetail,
                  builder: (context, state) =>
                      const SizedBox.shrink(), // TravelRequestDetailPage
                ),
                GoRoute(
                  path: 'approvals',
                  name: RouteNames.travelApprovals,
                  redirect: (_, __) {
                    if (!HrmPermissions.canApproveTravel) {
                      return '/dashboard';
                    }
                    return null;
                  },
                  builder: (context, state) => BlocProvider(
                    create: (_) => getIt<TravelBloc>(),
                    child: const TravelHomePage(),
                  ),
                ),
                GoRoute(
                  path: 'expenses/claim',
                  name: RouteNames.expenseClaim,
                  builder: (context, state) => BlocProvider(
                    create: (_) => getIt<TravelBloc>(),
                    child: ExpenseClaimPage(
                      travelRequestId: int.tryParse(
                          state.uri.queryParameters['travelId'] ?? ''),
                    ),
                  ),
                ),
                GoRoute(
                  path: 'expenses/:claimId',
                  name: RouteNames.expenseDetail,
                  builder: (context, state) =>
                      const SizedBox.shrink(), // ClaimDetailPage
                ),
              ],
            ),
            GoRoute(
              path: '/training',
              name: RouteNames.training,
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<TrainingBloc>(),
                child: const TrainingHomePage(),
              ),
              routes: [
                GoRoute(
                  path: 'request',
                  name: RouteNames.trainingRequest,
                  builder: (context, state) => BlocProvider(
                    create: (_) => getIt<TrainingBloc>(),
                    child: const AddTrainingRequestPage(),
                  ),
                ),
                GoRoute(
                  path: ':courseId',
                  name: RouteNames.courseDetail,
                  builder: (context, state) => BlocProvider(
                    create: (_) => getIt<TrainingBloc>(),
                    child: const SizedBox.shrink(), // CourseDetailPage
                  ),
                  routes: [
                    GoRoute(
                      path: 'player',
                      name: RouteNames.coursePlayer,
                      builder: (context, state) {
                        final courseId = int.parse(
                            state.pathParameters['courseId']!);
                        return BlocProvider(
                          create: (_) => CoursePlayerCubit(
                            getIt(),
                            courseId,
                          ),
                          child: CoursePlayerPage(courseId: courseId),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'assessment',
                      name: RouteNames.assessment,
                      builder: (context, state) {
                        final courseId = int.parse(
                            state.pathParameters['courseId']!);
                        return BlocProvider(
                          create: (_) => AssessmentCubit(getIt(), courseId),
                          child:
                              AssessmentPage(courseId: courseId),
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'certificates',
                  name: RouteNames.certificates,
                  builder: (context, state) => BlocProvider(
                    create: (_) => getIt<TrainingBloc>(),
                    child: const TrainingHomePage(),
                  ),
                  routes: [
                    GoRoute(
                      path: ':id',
                      name: RouteNames.certificateView,
                      builder: (context, state) =>
                          const SizedBox.shrink(), // CertificateViewPage
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: '/overtime',
              name: RouteNames.overtime,
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<OvertimeCubit>(),
                child: const OvertimeHomePage(),
              ),
              routes: [
                GoRoute(
                  path: 'apply',
                  name: RouteNames.overtimeApply,
                  builder: (context, state) => BlocProvider(
                    create: (_) => getIt<OvertimeCubit>(),
                    child: const OvertimeApplyPage(),
                  ),
                ),
                GoRoute(
                  path: 'approvals',
                  name: RouteNames.overtimeApprovals,
                  redirect: (_, __) {
                    if (!HrmPermissions.canApproveOvertime) {
                      return '/dashboard';
                    }
                    return null;
                  },
                  builder: (context, state) => BlocProvider(
                    create: (_) => getIt<OvertimeCubit>(),
                    child: const OvertimeHomePage(),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: '/attendance',
              name: RouteNames.attendance,
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<AttendanceCubit>(),
                child: const AttendanceHomePage(),
              ),
            ),
            GoRoute(
              path: '/notifications',
              name: RouteNames.notifications,
              builder: (_, __) => const NotificationsPage(),
            ),
            GoRoute(
              path: '/profile',
              name: RouteNames.profile,
              builder: (_, __) => const ProfilePage(),
            ),
          ],
        ),
      ],
    );
  }
}

class _ScaffoldWithNav extends StatefulWidget {
  final Widget child;
  const _ScaffoldWithNav({required this.child});

  @override
  State<_ScaffoldWithNav> createState() => _ScaffoldWithNavState();
}

class _ScaffoldWithNavState extends State<_ScaffoldWithNav> {
  static const _navy   = Color(0xFF1B2064);
  static const _purple = Color(0xFF7367F0);

  List<_NavItem> get _items {
    return [
      const _NavItem(
        icon:       Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Home',
        route: '/dashboard',
        show: true,
      ),
      _NavItem(
        icon:       Icons.event_note_outlined,
        activeIcon: Icons.event_note_rounded,
        label: 'Leave',
        route: '/leave',
        show: HrmPermissions.canApplyLeave,
      ),
      _NavItem(
        icon:       Icons.flight_takeoff_outlined,
        activeIcon: Icons.flight_takeoff_rounded,
        label: 'Travel',
        route: '/travel',
        show: HrmPermissions.canApplyTravel,
      ),
      _NavItem(
        icon:       Icons.menu_book_outlined,
        activeIcon: Icons.menu_book_rounded,
        label: 'Training',
        route: '/training',
        show: HrmPermissions.canEnrollTraining,
      ),
      _NavItem(
        icon:       Icons.access_time_outlined,
        activeIcon: Icons.access_time_filled_rounded,
        label: 'Attendance',
        route: '/attendance',
        show: HrmPermissions.canViewAttendance,
      ),
      const _NavItem(
        icon:       Icons.grid_view_outlined,
        activeIcon: Icons.grid_view_rounded,
        label: 'More',
        route: '/profile',
        show: true,
      ),
    ].where((i) => i.show).toList();
  }

  int _indexFromLocation(String location, List<_NavItem> items) {
    for (int i = 0; i < items.length; i++) {
      if (location.startsWith(items[i].route)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/dashboard');
        }
      },
      child: Builder(
        builder: (context) {
          final items = _items;
          final location = GoRouterState.of(context).matchedLocation;
          final currentIndex = _indexFromLocation(location, items);
          return Scaffold(
            body: widget.child,
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<bool>(
                  stream: getIt<ConnectivityService>().isOnlineStream,
                  builder: (context, snapshot) {
                    return FutureBuilder<int>(
                      future: getIt<SyncQueueService>().pendingCount,
                      builder: (context, countSnapshot) {
                        final count = countSnapshot.data ?? 0;
                        if (count == 0) return const SizedBox.shrink();
                        return Container(
                          width: double.infinity,
                          color: Colors.amber.shade700,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: Row(
                            children: [
                              const Icon(Icons.sync,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                '$count action(s) pending sync...',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                _CustomNavBar(
                  items: items,
                  currentIndex: currentIndex,
                  onTap: (i) => context.go(items[i].route),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CustomNavBar extends StatelessWidget {
  final List<_NavItem> items;
  final int currentIndex;
  final void Function(int) onTap;

  static const _navy   = Color(0xFF1B2064);
  static const _purple = Color(0xFF7367F0);

  const _CustomNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final selected = i == currentIndex;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon with animated pill background
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: selected
                              ? _purple.withOpacity(0.22)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          selected ? item.activeIcon : item.icon,
                          color: selected ? Colors.white : Colors.white38,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Label
                      Text(
                        item.label,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.white38,
                          fontSize: 10,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          letterSpacing: 0.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      // Active dot indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: selected ? 16 : 0,
                        height: 3,
                        decoration: BoxDecoration(
                          color: _purple,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  final bool show;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    required this.show,
  });
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
