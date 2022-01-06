import 'package:radiance/src/steering/kinematics/basic_kinematics.dart';
import 'package:radiance/steering.dart';
import 'package:vector_math/vector_math_64.dart';

class SimpleSteerable implements Steerable {
  SimpleSteerable({
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
}
