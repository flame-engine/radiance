import 'package:vector_math/vector_math_64.dart';

import '../../options/angles.dart';
import '../behaviors/flee.dart';
import '../behaviors/seek.dart';
import 'basic_kinematics.dart';

/// [LightKinematics] describes an agent who can move freely in any direction
/// with speeds up to `maxSpeed`, and change their velocity instantaneously
/// without any inertia.
///
/// This kinematics also forces the agent to always look in the direction of its
/// velocity, turning instantly when the velocity changes.
///
/// Use this for small lightweight creatures, like ants, or in situations where
/// physical realism is not needed.
class LightKinematics extends BasicKinematics {
  LightKinematics(this._maxSpeed)
      : assert(_maxSpeed > 0, 'maxSpeed must be positive');

  /// Maximum speed with which this agent can move.
  ///
  /// This speed cannot be negative or zero. Reducing the `maxSpeed` will also
  /// reduce the current agent's velocity, if it's greater than the new speed
  /// limit.
  double get maxSpeed => _maxSpeed;
  double _maxSpeed;
  set maxSpeed(double value) {
    assert(value > 0, 'maxSpeed must be positive');
    _maxSpeed = value;
    setVelocitySafe(owner.velocity);
  }

  void stop() {
    owner.velocity.setZero();
  }

  void setVelocity(Vector2 value) {
    assert(
      value.length2 <= maxSpeed * maxSpeed * (1 + 1e-8),
      'Trying to set velocity=$value larger than maxSpeed=$maxSpeed',
    );
    owner.velocity.setFrom(value);
    owner.angle = vectorToAngle(owner.velocity);
  }

  void setVelocitySafe(Vector2 value) {
    final speed = value.length;
    owner.velocity.setFrom(value);
    owner.angle = vectorToAngle(owner.velocity);
    if (speed > maxSpeed) {
      owner.velocity.scale(maxSpeed / speed);
    }
  }

  @override
  Seek seek(Vector2 target) => SeekLight(owner: owner, point: target);

  @override
  Flee flee(List<Vector2> targets) => FleeLight(owner: owner, targets: targets);
}
