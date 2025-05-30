import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  static final NotificationsService _instance =
      NotificationsService._internal();

  late InitializationSettings initializationSettings;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidInitializationSettings initializationSettingsAndroid;
  late DarwinInitializationSettings initializationSettingsDarwin;

  factory NotificationsService() {
    return _instance;
  }

  NotificationsService._internal() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializationSettingsForAndroid();
    _initializationSettingsDarwinForIos();

    initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
  }

  void _initializationSettingsForAndroid() => initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  void _initializationSettingsDarwinForIos() =>
      initializationSettingsDarwin = const DarwinInitializationSettings();

  Future<bool?> requestNotificationsPermission() async =>
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

  Future<void> ensureChannelExists(String channelId, String channelName) async {
    // Check if the channel already exists by querying the existing channels
    final List<AndroidNotificationChannel>? channels =
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.getNotificationChannels();

    // If the channel doesn't exist, create it
    if (channels == null ||
        !channels.any((channel) => channel.id == channelId)) {
      AndroidNotificationChannel androidNotificationChannel =
          AndroidNotificationChannel(
        channelId,
        channelName,
        importance: Importance.high,
        enableLights: true,
        showBadge: true,
      );

      // Create the channel
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidNotificationChannel);
    }
  }

  void showNotification({
    required String title,
    required String body,
    String payload = "myschedules", // <-- هنا نرسل اسم الشاشة
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'my_child_app',
      'my_child_app',
      ticker: 'New message',
      enableLights: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    int uniqueId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await flutterLocalNotificationsPlugin.show(
      uniqueId,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
