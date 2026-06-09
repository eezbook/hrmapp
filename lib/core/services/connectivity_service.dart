import 'dart:async';
import 'package:get_it/get_it.dart';
import '../network/network_info.dart';
import '../sync/sync_queue_service.dart';

class ConnectivityService {
  final StreamController<bool> _controller =
      StreamController<bool>.broadcast();

  Stream<bool> get isOnlineStream => _controller.stream;

  Future<bool> isOnline() => GetIt.instance<NetworkInfo>().isConnected;

  void initialize() {
    GetIt.instance<NetworkInfo>().onConnectivityChanged.listen((online) {
      _controller.add(online);
      if (online) {
        GetIt.instance<SyncQueueService>().processPendingQueue();
      }
    });
  }
}
