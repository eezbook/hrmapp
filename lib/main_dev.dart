import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/dev/dev_config_storage.dart';
import 'core/dev/dev_overlay.dart';
import 'core/dev/dev_url_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the dev_config box before everything else so we can read the saved
  // API URL before AppConfig.initialize() is called.
  await Hive.initFlutter();
  await DevConfigStorage.openBox();

  await dotenv.load(fileName: '.env.dev');

  // The path suffix (e.g. /api/v1/hrm) is taken from the .env.dev
  // API_BASE_URL so it stays configurable without touching code.
  // The user only types the host — we append the path automatically.
  final apiPath = Uri.parse(dotenv.env['API_BASE_URL']!).path; // '/api/v1/hrm'

  final savedHost = DevConfigStorage.getApiBaseUrl();
  final String apiBaseUrl;

  if (savedHost != null && savedHost.isNotEmpty) {
    apiBaseUrl = savedHost + apiPath;
  } else {
    // First launch: show URL input before anything else starts.
    final host = await _promptForApiUrl();
    apiBaseUrl = host + apiPath;
  }

  AppConfig.initialize(
    flavor:            Flavor.dev,
    apiBaseUrl:        apiBaseUrl,
    clientName:        dotenv.env['CLIENT_NAME']!,
    primaryColorValue: int.parse(dotenv.env['PRIMARY_COLOR']!),
    logoAsset:         dotenv.env['LOGO_ASSET']!,
    devHost:           dotenv.env['DEV_HOST'],
  );

  await runHrmApp(
    wrapWith: (child) => DevApp(child: child),
  );
}

/// Runs a minimal bootstrap [MaterialApp] with [DevUrlScreen], waits for the
/// user to submit a URL, persists it, then returns the value so [main] can
/// continue initializing the real app.
Future<String> _promptForApiUrl() {
  final completer = Completer<String>();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DevUrlScreen(
      onSave: (url) async {
        await DevConfigStorage.saveApiBaseUrl(url);
        completer.complete(url);
      },
    ),
  ));
  return completer.future;
}
