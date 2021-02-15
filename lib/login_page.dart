import 'package:Habitect/main_page.dart';
import 'package:Habitect/services/google_account_service.dart';
import 'package:Habitect/services/to_do_service.dart';
import 'package:Habitect/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
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
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutExpo).drive(Tween<double>(begin: 0, end: 250))
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
    ToDoService toDoService = Provider.of(context);
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
                child: ClipRRect(
                    child: Image.asset('graphics/sloth.png', height: 250, width: 250),
                    borderRadius: BorderRadius.circular(200.0)),
              ),
              SizedBox(height: 80),
              SignInButton(
                Buttons.GoogleDark,
                onPressed: () async {
                  try {
                    await googleAccountService.login();
                    await toDoService.fetchTodos();
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Center(
                                child: const Text(
                              "About Habitect",
                              style: TextStyle(fontSize: 20),
                            )),
                            content: RichText(
                              text: TextSpan(
                                style: TextStyle(fontSize: 16),
                                children: [
                                  WidgetSpan(
                                    child: Icon(Icons.assignment_outlined, size: 20),
                                  ),
                                  TextSpan(
                                    text: " Keep track of your daily tasks. \n\n",
                                  ),
                                  WidgetSpan(
                                    child: Icon(Icons.mic, size: 20),
                                  ),
                                  TextSpan(
                                    text: " Record voice notes. \n\n",
                                  ),
                                  WidgetSpan(
                                    child: Icon(Icons.date_range, size: 20),
                                  ),
                                  TextSpan(
                                    text: " Access it all in a built-in calendar. \n\n",
                                  ),
                                  WidgetSpan(
                                    child: Icon(Icons.add_to_drive, size: 20),
                                  ),
                                  TextSpan(
                                    text: " Synchronize with Google Drive. \n\n",
                                  ),
                                ],
                              ),
                            ));
                      },
                    );
                    //Notifications.sendNotification("Workout", "Keep up the streak!");
                  },
                  child: Text("About"))
            ],
          ),
        ),
      ),
    );
  }
}
