
import 'dart:math';

import 'package:vector_math/vector_math_64.dart';

import '../kinematics.dart';

/// [MaxSpeedKinematics] describes a character who can move freely in any
/// direction with speeds up to `maxSpeed`, and change their velocity
/// instantaneously with no regard to inertia.
///
class MaxSpeedKinematics extends Kinematics {
  MaxSpeedKinematics(this.maxSpeed)
    : assert(maxSpeed > 0, 'maxSpeed must be positive');

  double maxSpeed;


  void setBearing(double angle) {
    own.velocity.x = maxSpeed * cos(angle);
    own.velocity.y = -maxSpeed * sin(angle);
  }

  void stop() {
    own.velocity.setZero();
  }

  void setVelocity(Vector2 value) {
    assert(
      value.length2 <= maxSpeed * maxSpeed * (1 + 1e-8),
      'Trying to set velocity=$value larger than maxSpeed=$maxSpeed',
    );
    own.velocity.setFrom(value);
  }

  void setVelocitySafe(Vector2 value) {
    final speed = value.length;
    own.velocity.setFrom(value);
    if (speed > maxSpeed) {
      own.velocity.scale(maxSpeed / speed);
    }
  }
}
