import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/api/api_response.dart';
import '../models/notification_model.dart';

part 'notifications_remote_datasource.g.dart';

@RestApi()
abstract class NotificationsRemoteDataSource {
  factory NotificationsRemoteDataSource(Dio dio) =
      _NotificationsRemoteDataSource;

  @GET('notifications')
  Future<ApiResponse<List<NotificationModel>>> getNotifications({
    @Query('page') int? page,
  });

  @PUT('notifications/{id}/read')
  Future<ApiResponse<void>> markRead(@Path('id') int id);

  @PUT('notifications/read-all')
  Future<ApiResponse<void>> markAllRead();

  @DELETE('notifications/{id}')
  Future<ApiResponse<void>> deleteNotification(@Path('id') int id);
}
