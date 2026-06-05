import 'dart:io';

import 'package:flutter/material.dart';

import '../config/app_config.dart';
import 'dev_config_storage.dart';
import 'dev_url_screen.dart';

/// Wraps the app with a persistent DEV banner at the bottom of the screen.
///
/// Long-pressing the banner opens [DevUrlScreen] so developers can update the
/// API base URL. After saving, the app exits (next launch picks up the new URL).
/// Cancelling returns to the running app without losing navigation state.
///
/// Only used from [main_dev.dart] — never referenced in staging/prod entry points.
class DevApp extends StatefulWidget {
  final Widget child;

  const DevApp({super.key, required this.child});

  @override
  State<DevApp> createState() => _DevAppState();
}

class _DevAppState extends State<DevApp> {
  bool _showingUrlInput = false;

  void _openUrlInput() => setState(() => _showingUrlInput = true);
  void _closeUrlInput() => setState(() => _showingUrlInput = false);

  @override
  Widget build(BuildContext context) {
    // When resetting: replace the entire UI with a fresh MaterialApp so we
    // have a Navigator without nesting inside the app's GoRouter.
    // On cancel the child is restored; on save the process exits.
    if (_showingUrlInput) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DevUrlScreen(
          initialUrl: DevConfigStorage.getApiBaseUrl(),
          canCancel: true,
          onCancel: _closeUrlInput,
          onSave: (url) async {
            await DevConfigStorage.saveApiBaseUrl(url);
            exit(0);
          },
        ),
      );
    }

    // Normal mode: app fills available space, DEV banner sits below it.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          Expanded(child: widget.child),
          _DevBanner(onLongPress: _openUrlInput),
        ],
      ),
    );
  }
}

class _DevBanner extends StatelessWidget {
  final VoidCallback onLongPress;

  const _DevBanner({required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    // Show the actual resolved URL (AppConfig has host + path already merged)
    final url = AppConfig.apiBaseUrl;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: onLongPress,
      child: Container(
        width: double.infinity,
        color: const Color(0xFFDC2626),
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          'DEV  •  $url  •  long press to change URL',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontFamily: 'monospace',
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
