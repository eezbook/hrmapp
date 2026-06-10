import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/cubit/hrm_header_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../data/datasources/notifications_remote_datasource.dart';
import '../../data/models/notification_model.dart';

const _pageBg = Color(0xFFF5F7FF);

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationModel> _notifications = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    getIt<NotificationService>().clearUnreadCount();
    getIt<HrmHeaderCubit>().update(
      subtitle: 'Your inbox',
      clearBottom: true,
    );
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res =
          await getIt<NotificationsRemoteDataSource>().getNotifications();
      setState(() {
        _notifications = res.data ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _markRead(NotificationModel n) async {
    if (n.isRead) return;
    try {
      await getIt<NotificationsRemoteDataSource>().markRead(n.id);
      setState(() {
        final idx = _notifications.indexWhere((x) => x.id == n.id);
        if (idx != -1) {
          _notifications[idx] = _notifications[idx].copyWith(isRead: true);
        }
      });
    } catch (_) {}
  }

  Future<void> _markAllRead() async {
    try {
      await getIt<NotificationsRemoteDataSource>().markAllRead();
      setState(() {
        _notifications =
            _notifications.map((n) => n.copyWith(isRead: true)).toList();
      });
    } catch (_) {}
  }

  Future<void> _delete(NotificationModel n) async {
    try {
      await getIt<NotificationsRemoteDataSource>().deleteNotification(n.id);
      setState(() => _notifications.removeWhere((x) => x.id == n.id));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: _pageBg,
      body: Column(
        children: [
          // Mark all read row
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: _markAllRead,
                  icon: const Icon(Icons.done_all_rounded, size: 16),
                  label: const Text('Mark all read'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF7367F0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const ShimmerListLoader()
                : _error != null
                    ? ErrorView(
                        message: _error!, onRetry: _loadNotifications)
                    : _notifications.isEmpty
                        ? const EmptyState(
                            icon: Icons.notifications_none_rounded,
                            title: 'No notifications',
                          )
                        : RefreshIndicator(
                            onRefresh: _loadNotifications,
                            child: ListView.separated(
                              itemCount: _notifications.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (_, i) {
                                final n = _notifications[i];
                                return Dismissible(
                                  key: Key('notif_${n.id}'),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: scheme.error,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(
                                        right: 20),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  onDismissed: (_) => _delete(n),
                                  child: InkWell(
                                    onTap: () async {
                                      await _markRead(n);
                                      if (n.route != null && mounted) {
                                        context.go(n.route!);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      color: n.isRead
                                          ? null
                                          : scheme.primaryContainer
                                              .withOpacity(0.3),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (!n.isRead)
                                            Container(
                                              width: 8,
                                              height: 8,
                                              margin: const EdgeInsets.only(
                                                  top: 6, right: 8),
                                              decoration: BoxDecoration(
                                                color: scheme.primary,
                                                shape: BoxShape.circle,
                                              ),
                                            )
                                          else
                                            const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  n.title,
                                                  style: n.isRead
                                                      ? AppTextStyles
                                                          .bodyMedium
                                                      : AppTextStyles
                                                          .bodyMedium
                                                          .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  n.body,
                                                  style: AppTextStyles
                                                      .bodySmall
                                                      .copyWith(
                                                    color: scheme
                                                        .onSurfaceVariant,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  HrmDateUtils.timeAgo(
                                                      DateTime.parse(
                                                          n.createdAt)),
                                                  style: AppTextStyles
                                                      .bodySmall
                                                      .copyWith(
                                                    color: scheme
                                                        .onSurfaceVariant
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
