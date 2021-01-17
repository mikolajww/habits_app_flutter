import 'dart:math';

import 'package:flutter/material.dart';

class ArcPainter extends CustomPainter {
  ArcPainter(this.percentage, this.color, this.strokeWidth);
  double percentage;
  Color color;
  double strokeWidth;

  @override
  bool shouldRepaint(ArcPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    var startArc = - pi / 2;
    var arcLength = percentage * 2 * pi;
    canvas.drawArc(
        rect,
        startArc,
        arcLength,
        false,
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
    );
  }
}
