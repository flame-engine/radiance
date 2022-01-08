import 'dart:ui';

import 'package:vector_math/vector_math_64.dart';

class VectorVisual {
  VectorVisual(this.origin, this.vector);

  final Vector2 origin;
  final Vector2 vector;
  final Paint paint = Paint()..style = PaintingStyle.stroke;
  final double arrowHalfWidth = 0.5;
  final double arrowLength = 3;

  void render(Canvas canvas) {
    final path = Path();
    path.moveTo(origin.x, origin.y);
    path.relativeLineTo(vector.x, vector.y);
    if (vector.length >= arrowLength * 1.5) {
      final normal = vector.normalized();
      final arrowBase = normal.scaled(arrowLength);
      normal.scaleOrthogonalInto(arrowHalfWidth, normal);
      path.relativeLineTo(-arrowBase.x + normal.x, -arrowBase.y + normal.y);
      path.relativeLineTo(-normal.x * 2, -normal.y * 2);
      path.close();
    }
    canvas.drawPath(path, paint);
  }
}
