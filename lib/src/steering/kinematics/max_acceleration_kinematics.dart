import 'package:vector_math/vector_math_64.dart';

import '../kinematics.dart';

class MaxAccelerationKinematics extends Kinematics {
  MaxAccelerationKinematics({
    required this.maxSpeed,
    required this.maxAcceleration,
  })  : assert(maxSpeed > 0),
        assert(maxAcceleration >= 0),
        acceleration = Vector2.zero();

  double maxSpeed;
  double maxAcceleration;
  Vector2 acceleration;

  @override
  void update(double dt) {
    own.position.addScaled(own.velocity, dt);
    own.velocity.addScaled(acceleration, dt);
    final v = own.velocity.length;
    if (v > maxSpeed) {
      own.velocity.scale(maxSpeed / v);
    }
  }
}
