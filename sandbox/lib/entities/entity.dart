import 'dart:ui';

import 'package:radiance/steering.dart';
import 'package:vector_math/vector_math_64.dart';

abstract class Entity implements Steerable {
  Entity({
    Vector2? position,
    Vector2? velocity,
    double? angle,
    double? angularVelocity,
    Kinematics? kinematics,
    double? size,
    this.behavior,
  })  : position = position ?? Vector2.zero(),
        velocity = velocity ?? Vector2.zero(),
        angle = angle ?? 0,
        angularVelocity = angularVelocity ?? 0,
        size = size ?? 0,
        kinematics = kinematics ?? BasicKinematics() {
    this.kinematics.handleAttach(this);
  }

  final double size;

  @override
  final Vector2 position;

  @override
  final Vector2 velocity;

  @override
  double angle;

  @override
  double angularVelocity;

  @override
  Kinematics kinematics;

  Behavior? behavior;

  void render(Canvas canvas);

  void update(double dt) {
    behavior?.update(dt);
    kinematics.update(dt);
  }
}
