import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {

    await _notificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.requestNotificationsPermission();
    tz_data.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon'); // Usa tu icono

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: DarwinInitializationSettings(),
        );

    await _notificationsPlugin.initialize(settings: initializationSettings);
  }

  static Future<void> scheduleWeeklyReminder() async {
    
    await _notificationsPlugin.cancelAll();

    final message = getAleatoryMessage();

    await _notificationsPlugin.zonedSchedule(
      id: 159,
      title: message.title,
      body: message.body,
      scheduledDate: tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1)),
      notificationDetails: const NotificationDetails(
        
        android: AndroidNotificationDetails(
          'puzzle_reminder_channel',
          'Recordatorios de Juego',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: .inexact,
    );
  }
}


class NotificationContent {
  final String title;
  final String body;
  NotificationContent(this.title, this.body);
}

NotificationContent getAleatoryMessage() {
  List<NotificationContent> messages = [
    NotificationContent('🏆 ¿Te rindes tan fácil?', '¡Entra y demuestra quién es el maestro del puzzle!'),
    NotificationContent('📸 Tus fotos te extrañan...', '¿Qué recuerdo vamos a armar hoy? Entra y elige una foto.'),
    NotificationContent('🧩 ¡Tu puzzle está listo!', 'Tómate un respiro de 2 minutos y resuelve un desafío.'),
    NotificationContent('🔥 ¡Racha en peligro!', 'No dejes que tu racha de juego se pierda. ¡Juega ahora!'),
  ];
  
  messages.shuffle(); // Mezcla la lista
  return messages.first; // Retorna el primero
}