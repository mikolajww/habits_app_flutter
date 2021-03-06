import 'package:flutter/material.dart';

import 'arc_painter.dart';

class PieChart extends StatelessWidget {
  PieChart({this.width, this.height, this.percentCompleted, this.strokeWidth = 35.0});
  double width;
  double height;
  double percentCompleted;
  double strokeWidth;
  @override
  Widget build(BuildContext context) {
    Tween<double> tween = Tween(begin: 0, end: percentCompleted);
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.loose,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: width - strokeWidth,
          height: height - strokeWidth,
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeInOutBack,
            tween: tween,
            builder: (context, value, child) {
              return CustomPaint(
                painter: ArcPainter(value, Colors.red, strokeWidth),
              );
            },
            child: CustomPaint(
              painter: ArcPainter(percentCompleted, Colors.red, strokeWidth),
            ),
          ),
        ),
        Container(
          width: width - strokeWidth,
          height: height - strokeWidth,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xff2e2e2e),
          ),
        ),
        SizedBox(
            width: width * 0.8,
            height: height * 0.8,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You have completed",
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "${(percentCompleted * 100).toStringAsFixed(2)}%",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text("of your tasks for today!")
                ],
              ),
            ))
      ],
    );
  }
}
