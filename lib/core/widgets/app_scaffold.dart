import 'package:flutter/material.dart';
import 'offline_banner.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showOfflineBanner;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showOfflineBanner = true,
    this.leading,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              actions: actions,
              leading: leading,
              bottom: bottom,
            )
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );

    if (!showOfflineBanner) return scaffold;
    return OfflineBanner(child: scaffold);
  }
}
