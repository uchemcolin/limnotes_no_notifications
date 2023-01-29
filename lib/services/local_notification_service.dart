import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {

  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();
  
  Future<void> initialize() async {
    tz.initializeTimeZones();

    //const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("app_icon"); //android settings
    //const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("@mipmap/ic_launcher"); //android settings

    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("@drawable/ic_stat_limnotes_icon"); //android settings

    IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings
    );

    //So the payload redirects to the page screen
    //if app was closed after the notification was created
    //if you dont do this it wont take you to the actual page
    //it will take you to the app's homepage
    //like the app was just opened
    final details = await _localNotificationService.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp) {
      onNotificationClick.add(details.payload);
    }

    await _localNotificationService.initialize(
      settings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      "channel_id",
      "channel_name",
      channelDescription: "description",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true
    );

    const IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails
    );
  }

  //Show a notification that shows immediately its called
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);

    /*if(title == "" && body != "") {
      title = null;
      await _localNotificationService.show(id, title, body, details);
    }*/
  }

  //Show a scheduled notification
  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required int seconds,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        DateTime.now().add(
          Duration(seconds: seconds)
        ), 
        tz.local,
      ),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }

  //Show a scheduled notification with payload
  Future<void> showScheduledWithPayloadNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required int seconds,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        DateTime.now().add(
          Duration(seconds: seconds)
        ), 
        tz.local,
      ),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload
    );
  }

  //show notifications with payload
  Future<void> showNotificationWithPayload({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(
      id,
      title,
      body,
      details,
      payload: payload
    );
  }

  //Delete/cancel a particular flutter notification from the memory and showing
  Future<void> cancelNotification(int notificationId) async {
    await _localNotificationService.cancel(notificationId);
  }

  //Delete/cancel all flutter notifications from the memory and showing
  Future<void> cancelAllNotification() async {
    await _localNotificationService.cancelAll();
  }

  void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    print("id $id");
  }

  void onSelectNotification(String? payload) {
    print("payload $payload");

    if(payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }
}