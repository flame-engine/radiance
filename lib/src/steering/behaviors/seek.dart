
import 'package:vector_math/vector_math_64.dart';

import '../behavior.dart';
import '../kinematics.dart';
import '../kinematics/max_speed_kinematics.dart';

/// [Seek] behavior acts to steer the agent towards the specified static point.
///
/// In practice, the target point is stored as a reference, which means it can
/// be modified externally. If this happens, the behavior will adjust to seek
/// towards the updated target position.
///
/// The goal of this behavior is to reach the target point as fast as possible.
/// There is no attempt to make the agent being able to stop at that point.
/// Consider `Arrive` behavior if you need the agent to reach the target and
/// stay there.
abstract class Seek<L extends Kinematics> extends Behavior {
  factory Seek(Vector2 point) {
    if (L == MaxSpeedKinematics) {
      return _SeekAtMaxSpeed(point) as Seek<L>;
    }
    throw UnsupportedError(
      'Seek behavior is not available for targets of type $L',
    );
  }

  Seek._(Vector2 point)
    : _target = point;

  Vector2 _target;

  double arrivalEpsilon = 1e-5;
}


class _SeekAtMaxSpeed extends Seek<MaxSpeedKinematics> {
  _SeekAtMaxSpeed(Vector2 point) : super._(point);

  @override
  void calculateSteering(double dt) {
    final offset = _target - owner.position;
    final distance = offset.normalize();
    final locomotion = owner.locomotion as MaxSpeedKinematics;
    if (distance < arrivalEpsilon) {
      locomotion.stop();
    } else {
      var maxSpeed = locomotion.maxSpeed;
      if (maxSpeed * dt > distance) {
        maxSpeed = distance / dt;
      }
      locomotion.setVelocity(offset..scale(maxSpeed));
    }
  }
}
