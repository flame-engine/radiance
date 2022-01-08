import 'dart:math';

import 'package:vector_math/vector_math_64.dart';

import '../behavior.dart';
import '../kinematics/max_acceleration_kinematics.dart';
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
///
/// This class is abstract because its implementation depends on the kinematics
/// of the owner. However, because of the factory constructor, you can
/// instantiate this class as if it was concrete.
abstract class Seek extends Behavior {
  factory Seek({required Steerable owner, required Vector2 point}) {
    return owner.kinematics.seek(point);
  }

  Seek._(Steerable owner, this.target) : super(owner);

  /// The point that the behavior is seeking towards.
  final Vector2 target;
}

/// [Seek] behavior for objects that have [MaxSpeedKinematics].
class SeekAtMaxSpeed extends Seek {
  SeekAtMaxSpeed({required Steerable owner, required Vector2 point})
      : assert(owner.kinematics is MaxSpeedKinematics),
        super._(owner, point);

  @override
  void update(double dt) {
    final kinematics = own.kinematics as MaxSpeedKinematics;
    final offset = target - own.position;
    final distance = offset.normalize();
    var maxSpeed = kinematics.maxSpeed;
    if (maxSpeed * dt > distance) {
      maxSpeed = distance / dt;
    }
    kinematics.setVelocity(offset..scale(maxSpeed));
  }
}

/// [Seek] behavior for objects with [MaxAccelerationKinematics].
class SeekForMaxAcceleration extends Seek {
  SeekForMaxAcceleration({required Steerable owner, required Vector2 point})
      : assert(owner.kinematics is MaxAccelerationKinematics),
        super._(owner, point);

  @override
  void update(double dt) {
    final kinematics = own.kinematics as MaxAccelerationKinematics;
    final offset = target - own.position;
    final targetVelocity = offset..length = kinematics.maxSpeed;
    final velocityDelta = targetVelocity - own.velocity;
    final acceleration = min(
      kinematics.maxAcceleration,
      velocityDelta.length / dt,
    );
    kinematics.setAcceleration(velocityDelta..length = acceleration);
  }
}
