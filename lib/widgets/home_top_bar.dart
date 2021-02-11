import 'package:Habitect/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getTimeOfTheDayGreeting() {
  var now = DateTime.now().hour;
  if(now >= 5 && now <= 11) {
    return "Good Morning";
  }
  else if(now > 11 && now <= 18) {
    return "Good Afternoon";
  }
  else if(now > 18 && now <= 21) {
    return "Good Evening";
  }
  return "Hi";
}

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({Key key, @required this.username, @required this.photoUrl, this.isExpanded = true})
      : super(key: key);

  final String username;
  final bool isExpanded;
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    var today = DateTime.now();
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOutBack,
      height: isExpanded ? 120 : 80,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: isExpanded ? Colors.green : null,
          boxShadow: isExpanded ? [BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 10))] : null
        ),
        child: Row(
          mainAxisAlignment: isExpanded ? MainAxisAlignment.spaceAround : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (isExpanded)
              Container(
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${getTimeOfTheDayGreeting()}, $username!',
                        style: AppStyles.MED_ROBOTO,
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
              child: ClipOval(
                child: Container(
                  decoration: BoxDecoration(color: Colors.black26),
                  child: Image.network(
                    photoUrl,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
