import 'package:Habitect/services/google_account_service.dart';
import 'package:Habitect/services/notifications.dart';
import 'package:Habitect/services/to_do_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Habitect/login_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(HabitsApp());
  Notifications.init();
}

const colors = ["1c1c1c","292929","2e2e2e","2c632d","4caf50","8ecd90","d4edd4","ffffff"];


class HabitsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: ThemeData.dark().canvasColor,
    ));
    return MultiProvider(
      providers: [
        Provider(create: (_) => GoogleAccountService()),
        Provider(create: (_) => ToDoService())
      ],
      child: MaterialApp(
        title: 'Habitect',
        theme: ThemeData.dark(),
        home: LoginPage(),
      ),
    );
  }
}
