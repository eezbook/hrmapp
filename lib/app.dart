import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/storage/hive_storage.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {
    return;
  }
  final box = await Hive.openBox(HiveKeys.notifications);
  final current = box.get(HiveKeys.unreadCount, defaultValue: 0) as int;
  await box.put(HiveKeys.unreadCount, current + 1);
}

Future<void> runHrmApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (_) {}
  await Hive.initFlutter();
  HiveStorage.registerAdapters();
  await HiveStorage.openBoxes();
  await configureDependencies();
  try {
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  } catch (_) {}
  await getIt<NotificationService>().initialize();
  runApp(const HrmApp());
}

class HrmApp extends StatelessWidget {
  const HrmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(AppStarted()),
      child: Builder(
        builder: (context) {
          final router = getIt<AppRouter>().router;
          return MaterialApp.router(
            title: 'HRM App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: ThemeMode.system,
            routerConfig: router,
            supportedLocales: const [Locale('en'), Locale('ur')],
          );
        },
      ),
    );
  }
}
