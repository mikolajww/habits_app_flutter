import 'package:Habitect/services/google_account_service.dart';
import 'package:Habitect/services/notification_plugin.dart';
import 'package:Habitect/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:Habitect/main_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutExpo).drive(Tween<double>(begin: 0, end: 250))
      ..addListener(() {
        setState(() {
          // Mark the frame dirty for redraw
        });
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GoogleAccountService googleAccountService = Provider.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Habitect', style: AppStyles.BIG_MONTSERRAT),
              SizedBox(height: 10),
              Container(
                height: _animation.value,
                width: _animation.value,
                child: ClipRRect(child: Image.asset('graphics/sloth.png', height: 250, width: 250), borderRadius: BorderRadius.circular(200.0)),
              ),
              SizedBox(height: 80),
              SignInButton(
                Buttons.GoogleDark,
                onPressed: () async {
                  try {
                    await googleAccountService.login();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    );
                  } catch (error) {
                    print(error);
                  }
                },
              ),
              FlatButton(
                  onPressed: () async {
                    await googleAccountService.logout();
                  },
                  child: Text("Disconect")),
              FlatButton(
                  onPressed: () async {
                    var plugin = NotificationPlugin.plugin;
                    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
                        'your channel id', 'your channel name', 'your channel description',
                        sound: RawResourceAndroidNotificationSound("slow_spring_board"),
                        importance: Importance.max, priority: Priority.high, showWhen: false);
                    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
                    await plugin.show(0, 'Workout', 'time for the gainz', platformChannelSpecifics, payload: 'item x');
                  },
                  child: Text("Notify"))
            ],
          ),
        ),
      ),
    );
  }
}
