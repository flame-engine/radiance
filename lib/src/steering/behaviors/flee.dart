import 'dart:math';

import 'package:radiance/src/utils.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2;

import '../behavior.dart';
import '../kinematics/max_acceleration_kinematics.dart';
import '../kinematics/max_speed_kinematics.dart';
import '../steerable.dart';

/// [Flee] behavior forces the owner to move as far away and as fast as possible
/// from the given set of [targets].
///
/// The agent attempts to flee from all the given targets. In order to do this,
/// we find the centroid of all targets, weighing them inversely proportional
/// to the distance from the agent. The weighing is needed to ensure that the
/// agent prioritizes avoiding targets that are nearby versus those that are
/// farther away.
///
/// In the original C.Reynolds article, Flee behavior is the opposite of Seek:
/// a fleeing agent makes decisions that are opposite to the actions of a
/// seeker. However, this symmetry doesn't exist here, since we allow multiple
/// fleeing targets.
abstract class Flee extends Behavior {
  factory Flee({
    required Steerable owner,
    required List<Vector2> targets,
  }) {
    assert(targets.isNotEmpty, 'The list of targets to Flee cannot be empty');
    return owner.kinematics.flee(targets);
  }

  Flee._(Steerable owner, this.targets) : super(owner);

  /// All points that the agent is fleeing from.
  final List<Vector2> targets;

  /// Compute the best direction for fleeing. The returned vector is normalized.
  /// If the set of fleeing targets is so balanced that their centroid coincides
  /// with the agent's current position exactly, then return the direction in
  /// which the character is currently looking at.
  Vector2 get fleeDirection {
    final currentPosition = own.position;
    final result = Vector2.zero();
    if (targets.length == 1) {
      result.setFrom(currentPosition - targets.first);
    } else {
      for (final target in targets) {
        final delta = currentPosition - target;
        result.add(delta / delta.length2);
      }
    }
    final l = result.length;
    if (l == 0) {
      result..setFrom(Utils.angleToVector(own.angle));
    } else {
      result.scale(1 / l);
    }
    return result;
  }
}

/// [Flee] behavior for [MaxSpeedKinematics].
class FleeAtMaxSpeed extends Flee {
  FleeAtMaxSpeed({required Steerable owner, required List<Vector2> targets})
      : assert(owner.kinematics is MaxSpeedKinematics),
        super._(owner, targets);

  @override
  void update(double dt) {
    final kinematics = own.kinematics as MaxSpeedKinematics;
    final steering = fleeDirection..scale(kinematics.maxSpeed);
    kinematics.setVelocity(steering);
  }
}

/// [Flee] behavior for objects with [MaxAccelerationKinematics].
class FleeForMaxAcceleration extends Flee {
  FleeForMaxAcceleration({
    required Steerable owner,
    required List<Vector2> targets,
  })  : assert(owner.kinematics is MaxAccelerationKinematics),
        super._(owner, targets);

  @override
  void update(double dt) {
    final kinematics = own.kinematics as MaxAccelerationKinematics;
    final steering = fleeDirection..scale(kinematics.maxAcceleration);
    kinematics.setAcceleration(steering);
  }
}
