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

  void update(double dt) {
    kinematics.update(dt);
  }
}
