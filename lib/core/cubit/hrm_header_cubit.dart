import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HrmHeaderState {
  final String subtitle;
  final Widget? bottom;
  final bool isOffline;

  const HrmHeaderState({
    this.subtitle = '',
    this.bottom,
    this.isOffline = false,
  });

  HrmHeaderState copyWith({
    String? subtitle,
    Widget? bottom,
    bool clearBottom = false,
    bool? isOffline,
  }) =>
      HrmHeaderState(
        subtitle: subtitle ?? this.subtitle,
        bottom: clearBottom ? null : (bottom ?? this.bottom),
        isOffline: isOffline ?? this.isOffline,
      );
}

/// Singleton cubit that owns the shell header state:
///  - subtitle line below "Hi, Name!"
///  - optional bottom slot widget (tabs, time pills, etc.)
///  - real-time offline flag (single connectivity subscription for the whole app)
///
/// Each shell page calls [update] in its initState. Detail pages pushed to the
/// root navigator do NOT call update — the header is hidden under their own
/// AppScaffold while they are on screen.
class HrmHeaderCubit extends Cubit<HrmHeaderState> {
  StreamSubscription<List<ConnectivityResult>>? _sub;

  HrmHeaderCubit() : super(const HrmHeaderState()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final r = await Connectivity().checkConnectivity();
      _handle(r);
      _sub = Connectivity().onConnectivityChanged.listen(_handle);
    } catch (_) {}
  }

  void _handle(List<ConnectivityResult> r) {
    final offline = r.isEmpty || r.every((x) => x == ConnectivityResult.none);
    if (offline != state.isOffline) emit(state.copyWith(isOffline: offline));
  }

  /// Called by shell pages in initState.
  /// [clearBottom] removes any existing bottom widget (pages with no tabs).
  void update({String? subtitle, Widget? bottom, bool clearBottom = false}) {
    emit(HrmHeaderState(
      subtitle: subtitle ?? state.subtitle,
      bottom: clearBottom ? null : (bottom ?? state.bottom),
      isOffline: state.isOffline,
    ));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
