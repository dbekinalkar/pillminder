import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'notification_service.dart';
import 'storage_service.dart';
import 'package:timezone/data/latest.dart' as tz;


void main() async {
 WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();  // Initialize the time zones
  await NotificationService().init();
  await StorageService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Reminder',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: HomeScreen(),
    );
  }
}

