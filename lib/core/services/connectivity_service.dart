import 'dart:async';
import 'package:get_it/get_it.dart';
import '../network/network_info.dart';
import '../sync/sync_queue_service.dart';

class ConnectivityService {
  final StreamController<bool> _onlineController =
      StreamController<bool>.broadcast();

  // Emits a human-readable message each time the offline queue is synced.
  final StreamController<String> _syncController =
      StreamController<String>.broadcast();

  Stream<bool> get isOnlineStream => _onlineController.stream;
  Stream<String> get syncMessages => _syncController.stream;

  Future<bool> isOnline() => GetIt.instance<NetworkInfo>().isConnected;

  void initialize() {
    GetIt.instance<NetworkInfo>().onConnectivityChanged.listen((online) {
      _onlineController.add(online);
      if (online) {
        _processQueueAndNotify();
      }
    });
  }

  Future<void> _processQueueAndNotify() async {
    try {
      final count =
          await GetIt.instance<SyncQueueService>().processPendingQueue();
      if (count > 0) {
        _syncController.add(
          count == 1
              ? '1 offline record synced successfully'
              : '$count offline records synced successfully',
        );
      }
    } catch (_) {}
  }
}
