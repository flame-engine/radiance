import 'package:vector_math/vector_math_64.dart';

import '../behaviors/flee.dart';
import '../behaviors/seek.dart';
import '../kinematics.dart';

/// [HeavyKinematics] describes an agent who can move in any direction
/// with speed up to `maxSpeed`, and change their velocity with acceleration
/// not exceeding `maxAcceleration`. This acceleration can be applied equally
/// in all directions, regardless of the direction where the character is
/// currently moving or facing.
///
/// This kinematics model is described by Craig Reynolds in his 1999 report on
/// steering behaviors, and is considered "standard" for game AI. It produces
/// reasonably looking behaviors and can be used in a variety of situations.
class HeavyKinematics extends Kinematics {
  HeavyKinematics({
    required double maxSpeed,
    required double maxAcceleration,
  })  : assert(maxSpeed > 0, 'maxSpeed must be positive'),
        assert(maxAcceleration > 0, 'maxAcceleration must be positive'),
        _maxSpeed = maxSpeed,
        _maxAcceleration = maxAcceleration,
        _acceleration = Vector2.zero();

  double get maxSpeed => _maxSpeed;
  double _maxSpeed;
  set maxSpeed(double value) {
    assert(value > 0, 'maxSpeed must be positive');
    _maxSpeed = value;
  }

  double get maxAcceleration => _maxAcceleration;
  double _maxAcceleration;
  set maxAcceleration(double value) {
    assert(value > 0, 'maxAcceleration must be positive');
    _maxAcceleration = value;
  }

  final Vector2 _acceleration;

  void setAcceleration(Vector2 value) {
    assert(
      value.length2 <= maxAcceleration * maxAcceleration * (1 + 1e-8),
      'Trying to set acceleration=$value larger than max=$maxAcceleration',
    );
    _acceleration.setFrom(value);
  }

  @override
  void update(double dt) {
    own.position.addScaled(own.velocity, dt);
    own.velocity.addScaled(_acceleration, dt);
    final v = own.velocity.length;
    if (v > maxSpeed) {
      own.velocity.scale(maxSpeed / v);
    }
  }

  @override
  Seek seek(Vector2 point) => SeekHeavy(owner: own, point: point);

  @override
  Flee flee(List<Vector2> targets) {
    return FleeHeavy(owner: own, targets: targets);
  }
}
