import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz_data.initializeTimeZones();

    // 1. Configuración del icono (Asegúrate de usar 'ic_launcher')
    // Nota: Eliminamos el '@mipmap/' si solo pasamos el nombre,
    // pero lo más seguro en Flutter es 'ic_launcher'
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launch_background');

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: DarwinInitializationSettings(),
        );

    // 2. Inicializar el plugin
    await _notificationsPlugin.initialize(settings: initializationSettings);

    // 3. Solicitar permisos después de inicializar (Para Android 13+ e iOS)
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

    // Importante: No uses .exact para evitar bloqueos en Google Play
    await _notificationsPlugin.zonedSchedule(
      id: 159,
      title: message.title,
      body: message.body,
      scheduledDate: tz.TZDateTime.now(
        tz.local,
      ).add(const Duration(days: 3)), // Bajamos a 3 días
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'puzzle_reminder_channel',
          'Recordatorios de Juego',
          channelDescription: 'Notificaciones para recordar jugar puzzles',
          importance: Importance.max,
          priority: Priority.high,
          // ✅ Esto asegura que use el icono por defecto si el personalizado falla
          icon: 'ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // ✅ Sintaxis corregida:
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
