import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myapp/provider/test_provider.dart';
import 'package:myapp/screens/account.dart';
import 'package:myapp/screens/news_add.dart';
import 'package:myapp/screens/news_feed.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late PageController pageController;

  TestProvider? testProvider;

  @override
  void initState() {
    super.initState();

    testProvider = Provider.of<TestProvider>(context, listen: false);
    testProvider!.getDateTime();

    pageController = PageController();
    getToken();
    _setupLocalNotifications();
    _requestNotificationPermission();
    listenNotification();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    return token;
  }

  void _requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  listenNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message Datamessage ${message.notification}");

      _showLocalNotification(message);
    });
  }

  void _setupLocalNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // channel id
      'your_channel_name', // channel name
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  @override
  Widget build(BuildContext context) {
    String? datetime = context.watch<TestProvider>().currenttime;
    print("DateTime : $datetime");
    getToken();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: context.watch<TestProvider>().isLoading
                ? const CircularProgressIndicator()
                : Text(datetime.toString())),
        bottomNavigationBar: BottomNavyBar(
          itemPadding: const EdgeInsets.only(
            left: 10,
          ),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          selectedIndex: _currentIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _currentIndex = index;
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
              activeColor: Colors.red,
            ),
            BottomNavyBarItem(
                icon: const Icon(Icons.publish),
                title: const Text('Publish'),
                activeColor: Colors.pink),
            BottomNavyBarItem(
                icon: const Icon(Icons.person),
                title: const Text('Account'),
                activeColor: Colors.blue),
          ],
        ),
        body: SizedBox.expand(
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: const [NewsFeed(), NewsAdd(), Account()],
          ),
        ),
      ),
    );
  }
}
