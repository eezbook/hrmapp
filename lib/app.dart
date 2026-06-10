import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/storage/hive_storage.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';

Future<void> runHrmApp({Widget Function(Widget child)? wrapWith}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  HiveStorage.registerAdapters();
  await HiveStorage.openBoxes();
  await configureDependencies();
  getIt<ConnectivityService>().initialize();
  await getIt<NotificationService>().initialize();
  final app = const HrmApp();
  runApp(wrapWith != null ? wrapWith(app) : app);
}

class HrmApp extends StatefulWidget {
  const HrmApp({super.key});

  @override
  State<HrmApp> createState() => _HrmAppState();
}

class _HrmAppState extends State<HrmApp> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  late final StreamSubscription<String> _syncSub;

  @override
  void initState() {
    super.initState();
    _syncSub = getIt<ConnectivityService>().syncMessages.listen((message) {
      _messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.cloud_done_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    });
  }

  @override
  void dispose() {
    _syncSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => getIt<AuthBloc>()..add(AppStarted())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          final router = getIt<AppRouter>().router;
          return MaterialApp.router(
            title: 'HRM App',
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: _messengerKey,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeMode,
            routerConfig: router,
            supportedLocales: const [Locale('en'), Locale('ur')],
          );
        },
      ),
    );
  }
}
