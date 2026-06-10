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

class HrmApp extends StatelessWidget {
  const HrmApp({super.key});

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
