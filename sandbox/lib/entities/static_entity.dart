import 'dart:ui';

import 'package:vector_math/vector_math_64.dart' hide Vector;

import 'entity.dart';

class StaticEntity extends Entity {
  StaticEntity({Vector2? position, double size = 5})
      : super(position: position, size: size) {
    final a = size / 6;
    path = Path()
      ..moveTo(0, a)
      ..lineTo(0, 3 * a)
      ..moveTo(0, -a)
      ..lineTo(0, -3 * a)
      ..moveTo(a, 0)
      ..lineTo(3 * a, 0)
      ..moveTo(-a, 0)
      ..lineTo(-3 * a, 0);
    paint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
  }

  late final Path path;
  late final Paint paint;

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(position.x, position.y);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  List<Vector2> get vectors => [];
}
