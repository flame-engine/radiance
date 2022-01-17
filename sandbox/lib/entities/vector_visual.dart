import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class VectorVisual {
  VectorVisual(this.origin, this.vector, this.styleIndex)
      : assert(styleIndex < lineStyles.length);

  final Vector2 origin;
  final Vector2 vector;
  final int styleIndex;

  static List<Paint> lineStyles = [
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.2
      ..color = const Color(0xffffc655),
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4
      ..color = const Color(0xff5ed9ff),
  ];
  static List<Paint> arrowStyles = [
    Paint()..color = const Color(0xffffc655),
    Paint()..color = const Color(0xff5ed9ff),
  ];
  static const arrowLength = 3.0;

  void render(Canvas canvas) {
    final path = Path();
    path.moveTo(origin.x, origin.y);
    path.relativeLineTo(vector.x, vector.y);
    canvas.drawPath(path, lineStyles[styleIndex]);
    if (vector.length >= arrowLength * 1.5) {
      final normal = vector.normalized();
      final arrowBase = normal.scaled(arrowLength);
      final arrowHalfWidth = lineStyles[styleIndex].strokeWidth * 2;
      normal.scaleOrthogonalInto(arrowHalfWidth, normal);
      path.reset();
      path.moveTo(origin.x + vector.x, origin.y + vector.y);
      path.relativeLineTo(-arrowBase.x + normal.x, -arrowBase.y + normal.y);
      path.relativeLineTo(-normal.x * 2, -normal.y * 2);
      path.relativeLineTo(arrowBase.x + normal.x, arrowBase.y + normal.y);
      canvas.drawPath(path, arrowStyles[styleIndex]);
      // path.close();
    }
  }
}
