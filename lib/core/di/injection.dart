import 'package:get_it/get_it.dart';
import 'package:local_notifications/data/storage/notifications_storage.dart';
import 'package:local_notifications/utils/notification_service.dart';

void initializeDi(GetIt getIt) {
  getIt.registerSingleton<NotificationsStorage>(NotificationsStorage());
  getIt.registerSingleton<NotificationService>(NotificationService());
}
