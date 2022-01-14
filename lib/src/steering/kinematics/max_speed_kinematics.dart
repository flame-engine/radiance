import 'package:vector_math/vector_math_64.dart';

import '../behaviors/flee.dart';
import '../behaviors/seek.dart';
import 'basic_kinematics.dart';

/// [MaxSpeedKinematics] describes a character who can move freely in any
/// direction with speeds up to `maxSpeed`, and change their velocity
/// instantaneously with no regard to inertia.
///
/// Use this for very small creatures like ants, or in situations where physical
/// realism is not needed.
class MaxSpeedKinematics extends BasicKinematics {
  MaxSpeedKinematics(this._maxSpeed)
      : assert(_maxSpeed > 0, 'maxSpeed must be positive');

  double get maxSpeed => _maxSpeed;
  double _maxSpeed;
  set maxSpeed(double value) {
    assert(value > 0, 'maxSpeed must be positive');
    _maxSpeed = value;
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

  @override
  Seek seek(Vector2 target) => SeekAtMaxSpeed(owner: own, point: target);

  @override
  Flee flee(List<Vector2> targets) =>
      FleeAtMaxSpeed(owner: own, targets: targets);
}

typedef LightKinematics = MaxSpeedKinematics;
