import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz_data.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Usa tu icono

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: DarwinInitializationSettings(),
        );

    await _notificationsPlugin.initialize(settings: initializationSettings);
  }

  static Future<void> scheduleWeeklyReminder() async {
    
    await _notificationsPlugin.cancelAll();

    await _notificationsPlugin.zonedSchedule(
      id: 0,
      scheduledDate: tz.TZDateTime.now(tz.local).add(const Duration(days: 7)),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'puzzle_reminder_channel',
          'Recordatorios de Juego',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
