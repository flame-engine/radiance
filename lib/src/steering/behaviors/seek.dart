import 'package:vector_math/vector_math_64.dart';

import '../behavior.dart';
import '../kinematics/max_speed_kinematics.dart';
import '../steerable.dart';

/// [Seek] behavior acts to move the agent towards the specified static point.
///
/// In practice, the target point is stored as a reference, which means it can
/// be modified externally. If this happens, the behavior will adjust to seek
/// towards the updated target position.
///
/// The goal of this behavior is to reach the target point as fast as possible.
/// There is no attempt to make the agent being able to stop at that point.
/// Consider `Arrive` behavior if you need the agent to reach the target and
/// stay there.
abstract class Seek extends Behavior {
  factory Seek({required Steerable owner, required Vector2 point}) {
    return owner.kinematics.seek(point);
  }

  Seek._(Steerable owner, Vector2 point)
      : _target = point,
        super(owner);

  Vector2 _target;

  double arrivalEpsilon = 1e-5;
}

class SeekAtMaxSpeed extends Seek {
  SeekAtMaxSpeed({required Steerable owner, required Vector2 point})
      : assert(owner.kinematics is MaxSpeedKinematics),
        super._(owner, point);

  @override
  void update(double dt) {
    final offset = _target - own.position;
    final distance = offset.normalize();
    final locomotion = own.kinematics as MaxSpeedKinematics;
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
