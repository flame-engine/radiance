import 'dart:math';

import 'package:vector_math/vector_math_64.dart';

import '../behavior.dart';
import '../steerable.dart';
import 'seek.dart';

/// [Pursue] behavior steers the agent to intercept the [target] by predicting
/// its future position and seeking towards that point.
///
/// The parameter [predictionTime] governs how far into the future we're able
/// to predict the target's movement. Setting it to zero makes the [Pursue]
/// behavior being equivalent to [Seek]. At the same time, if this parameter is
/// set too high, the evader will be able to easily fool the target by changing
/// the direction frequently.
///
/// This behavior attempts to intercept the target at maximum possible speed.
class Pursue extends Behavior {
  Pursue({
    required Steerable owner,
    required this.target,
    this.predictionTime = 3.0,
  })  : assert(predictionTime >= 0, 'predictionTime cannot be negative'),
        super(owner) {
    _seek = Seek(owner: owner, point: Vector2.zero());
  }

  /// An entity that the pursuer is trying to catch, a quarry, an evader.
  final Steerable target;

  /// Helper behavior used to implement Pursue: we estimate the target's future
  /// position and then Seek to that position using this behavior.
  late final Seek _seek;

  /// The prediction horizon for the target's future position. We will attempt
  /// to predict where the target will be after this amount of time. Set this
  /// to smaller values when dealing with targets whose behavior is very
  /// chaotic, or to reduce the pursuer's intelligence.
  double predictionTime;

  @override
  void update(double dt) {
    var actualPredictionTime = predictionTime;

    // Adjust prediction time if we're getting close to the target
    final sqrSpeed = (own.velocity - target.velocity).length2;
    if (sqrSpeed > 0) {
      final sqrDistance = (own.position - target.position).length2;
      final sqrPredictionTime = predictionTime * predictionTime;
      if (sqrSpeed * sqrPredictionTime > sqrDistance) {
        actualPredictionTime = sqrt(sqrDistance / sqrSpeed);
      }
    }
    final predictedPosition =
        target.position + target.velocity * actualPredictionTime;
    _seek.target.setFrom(predictedPosition);
    _seek.update(dt);
  }
}
