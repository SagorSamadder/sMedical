import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:s_medi/doctor/all%20reviews/all_reviews.dart';
import 'package:s_medi/general/consts/consts.dart';

import '../../notification/notification_details.dart';
import '../../settings/view/setting_view.dart';
import '../../total_appintment/view/total_appointment_view.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  int selectedIndex = 0;
  List screenList = [
    const TotalAppointment(),
    const AllReviewsScreen(),
    const SettingsView(),
  ];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    _initializeNotifications();

    messaging
        .requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      criticalAlert: true,
    )
        .then((NotificationSettings settings) async {
      // Check the permission status and call submitData if allowed
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        String? deviceToken = await messaging.getToken();
        submitData(deviceToken.toString());
      }
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Received a foreground message: ${message.notification?.title}');
      }
      _showNotification(
        message.notification?.title,
        message.notification?.body,
        message.data,
      );
    });

    // Handle background and terminated message taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print(
            'Notification clicked! Opened app from background or terminated.');
      }
      _navigateToDetails(message);
    });

    // Check for messages when app is launched from a terminated state
    _checkForInitialMessage();
  }

  // Initialize and create notification channel
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Define how to handle notification responses (taps)
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationDetailsPage(
                title: 'Notification Tapped',
                body: response.payload.toString(),
              ),
            ),
          );
        }
      },
    );

    // Create a notification channel (only for Android 8.0 or higher)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Function to show a notification using flutter_local_notifications
  Future<void> _showNotification(
      String? title, String? body, Map<String, dynamic> data) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: body,
    );
  }

  void _navigateToDetails(RemoteMessage message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailsPage(
          title: message.notification?.title ?? 'No Title',
          body: message.notification?.body ?? 'No Body',
        ),
      ),
    );
  }

  Future<void> _checkForInitialMessage() async {
    // Check if the app was opened via a notification when the app was terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _navigateToDetails(initialMessage);
    }
  }

  void submitData(String token) async {
    // Get the current user's UID
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      if (kDebugMode) {
        print("User is not authenticated");
      }
      return;
    }

    try {
      // Reference to the document of the current user in the 'doctors' collection
      DocumentReference doctorRef =
          FirebaseFirestore.instance.collection('doctors').doc(uid);

      // Get the document to check the current deviceToken
      DocumentSnapshot doctorDoc = await doctorRef.get();

      if (doctorDoc.exists) {
        var data = doctorDoc.data() as Map<String, dynamic>;
        String? currentDeviceToken = data['deviceToken'];

        if (currentDeviceToken == null || currentDeviceToken.isEmpty) {
          // If deviceToken is empty or null, update with the new token
          await doctorRef.update({'deviceToken': token});
          if (kDebugMode) {
            print("Token updated: $token");
          }
        } else if (currentDeviceToken == token) {
          // If the token is the same, do nothing
          if (kDebugMode) {
            print("Token is already up-to-date");
          }
        } else {
          // If the token is different, update it
          await doctorRef.update({'deviceToken': token});
          if (kDebugMode) {
            print("Token updated: $token");
          }
        }
      } else {
        if (kDebugMode) {
          print("Doctor document does not exist");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to update token: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primeryColor,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: "Appointments",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews),
            label: "Review",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
