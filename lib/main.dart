import 'package:Habitect/login_page.dart';
import 'package:Habitect/services/google_account_service.dart';
import 'package:Habitect/services/notifications.dart';
import 'package:Habitect/services/to_do_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation("Europe/Warsaw"));
  runApp(HabitsApp());
  Notifications.init();
}

const colors = ["1c1c1c", "292929", "2e2e2e", "2c632d", "4caf50", "8ecd90", "d4edd4", "ffffff"];

class HabitsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: ThemeData.dark().canvasColor,
    ));
    return MultiProvider(
      providers: [
        Provider(create: (_) => GoogleAccountService()),
        ProxyProvider<GoogleAccountService, ToDoService>(
          update: (_, gAccServ, __) => ToDoService(gAccServ),
        )
      ],
      child: MaterialApp(
        title: 'Habitect',
        theme: ThemeData.dark(),
        home: LoginPage(),
      ),
    );
  }
}
