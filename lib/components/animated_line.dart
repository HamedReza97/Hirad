import 'dart:ui';
import 'package:flutter/material.dart';

class AnimatedLinePainter extends CustomPainter {
  final List<Offset> starts;
  final List<Offset> ends;
  final double animationValue;
  final double radius;

  AnimatedLinePainter({
    required this.starts,
    required this.ends,
    required this.animationValue,
    this.radius = 30.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withAlpha(20);

    for (int i = 0; i < starts.length; i++) {
      Path path = createPath(starts[i], ends[i]);
      PathMetrics pathMetrics = path.computeMetrics();
      for (PathMetric metric in pathMetrics) {
        double length = metric.length * animationValue;
        Path extractPath = metric.extractPath(0, length);
        canvas.drawPath(extractPath, paint);
      }
    }
  }

  Path createPath(Offset start, Offset end) {
    Path path = Path();
    path.moveTo(start.dx, start.dy);
    double xTurn;
    bool isLeftStart = start.dx == 0;

    if (isLeftStart) {
      xTurn = end.dx - radius; // Turn point before the end
      if (start.dy < end.dy) {
        // Start above end: curve downward
        path.lineTo(xTurn, start.dy);
        path.arcToPoint(
          Offset(end.dx, start.dy + radius),
          radius: Radius.circular(radius),
          clockwise: true,
        );
        path.lineTo(end.dx, end.dy);
      } else if (start.dy > end.dy) {
        // Start below end: curve upward
        path.lineTo(xTurn, start.dy);
        path.arcToPoint(
          Offset(end.dx, start.dy - radius),
          radius: Radius.circular(radius),
          clockwise: false,
        );
        path.lineTo(end.dx, end.dy);
      } else {
        // Same vertical level
        path.lineTo(end.dx, end.dy);
      }
    } else {
      xTurn = end.dx + radius; // Turn point after the end
      if (start.dy < end.dy) {
        // Start above end: curve downward
        path.lineTo(xTurn, start.dy);
        path.arcToPoint(
          Offset(end.dx, start.dy + radius),
          radius: Radius.circular(radius),
          clockwise: false,
        );
        path.lineTo(end.dx, end.dy);
      } else if (start.dy > end.dy) {
        // Start below end: curve upward
        path.lineTo(xTurn, start.dy);
        path.arcToPoint(
          Offset(end.dx, start.dy - radius),
          radius: Radius.circular(radius),
          clockwise: true,
        );
        path.lineTo(end.dx, end.dy);
      } else {
        // Same vertical level
        path.lineTo(end.dx, end.dy);
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}