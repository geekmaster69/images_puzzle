import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz_data.initializeTimeZones();

 
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launch_background');

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: DarwinInitializationSettings(),
        );


    await _notificationsPlugin.initialize(settings: initializationSettings);

 
    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  static Future<void> scheduleWeeklyReminder() async {
    await _notificationsPlugin.cancelAll();

    final message = getAleatoryMessage();

    await _notificationsPlugin.zonedSchedule(
      id: 159,
      title: message.title,
      body: message.body,
      scheduledDate: tz.TZDateTime.now(
        tz.local,
      ).add(const Duration(days: 3)), 
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'puzzle_reminder_channel',
          'Recordatorios de Juego',
          channelDescription: 'Notificaciones para recordar jugar puzzles',
          importance: Importance.max,
          priority: Priority.high,
       
          icon: 'launch_background',
        ),
        iOS: DarwinNotificationDetails(),
      ),

      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}

class NotificationContent {
  final String title;
  final String body;
  NotificationContent(this.title, this.body);
}

NotificationContent getAleatoryMessage() {
  final messages = [
    NotificationContent(
      '🏆 ¿Te rindes tan fácil?',
      '¡Entra y demuestra quién es el maestro del puzzle!',
    ),
    NotificationContent(
      '📸 Tus fotos te extrañan...',
      '¿Qué recuerdo vamos a armar hoy? Entra y elige una foto.',
    ),
    NotificationContent(
      '🧩 ¡Tu puzzle está listo!',
      'Tómate un respiro de 2 minutos y resuelve un desafío.',
    ),
    NotificationContent(
      '🔥 ¡Racha en peligro!',
      'No dejes que tu racha de juego se pierda. ¡Juega ahora!',
    ),
  ];

  messages.shuffle();
  return messages.first;
}
