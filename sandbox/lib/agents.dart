
import 'dart:ui';

import 'package:radiance/src/steering/kinematics/basic_kinematics.dart';
import 'package:radiance/steering.dart';
import 'package:vector_math/vector_math_64.dart';

abstract class Agent implements Steerable {
  Agent({
    Vector2? position,
    Vector2? velocity,
    double? angle,
    double? angularVelocity,
    Kinematics? kinematics,
  })  : position = position ?? Vector2.zero(),
        velocity = velocity ?? Vector2.zero(),
        angle = angle ?? 0,
        angularVelocity = angularVelocity ?? 0,
        kinematics = kinematics ?? BasicKinematics() {
    this.kinematics.handleAttach(this);
  }

  @override
  Vector2 position;

  @override
  Vector2 velocity;

  @override
  double angle;

  @override
  double angularVelocity;

  @override
  Kinematics kinematics;

  void render(Canvas canvas);
}

class StaticTarget extends Agent {
  StaticTarget(Vector2 position, {this.size = 5}) : super(position: position) {
    final a = size / 8;
    path = Path()
      ..moveTo(0, a) ..lineTo(0, 4*a)
      ..moveTo(0, -a) ..lineTo(0, -4*a)
      ..moveTo(a, 0) ..lineTo(4*a, 0)
      ..moveTo(-a, 0) ..lineTo(-4*a, 0);
    paint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
  }

  final double size;
  late final Path path;
  late final Paint paint;

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(position.x, position.y);
    canvas.drawPath(path, paint);
    canvas.restore();
  }
}
