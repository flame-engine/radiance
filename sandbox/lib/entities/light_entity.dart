import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:radiance/steering.dart';
import 'package:vector_math/vector_math_64.dart';

import 'entity.dart';

class LightEntity extends Entity {
  LightEntity({
    Vector2? position,
    Vector2? velocity,
    required double maxSpeed,
    double size = 6,
  }) : super(
          position: position,
          size: size,
          velocity: velocity,
          kinematics: LightKinematics(maxSpeed),
        ) {
    path = Path()
      ..moveTo(size * 0.5, 0)
      ..lineTo(0.25 * size, 0.13 * size)
      ..arcToPoint(
        Offset(0.25 * size, -0.13 * size),
        radius: Radius.elliptical(size * 0.4, size * 0.2),
        largeArc: true,
      )
      ..close();
    paint = Paint()..color = const Color(0xfffffcb8);
  }

  late final Path path;
  late final Paint paint;

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(position.x, position.y);
    canvas.rotate(angle);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  List<Vector2> get vectors => [velocity];
}
