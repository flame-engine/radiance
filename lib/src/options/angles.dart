import 'dart:math';

import 'package:vector_math/vector_math_64.dart';

/// Method to convert an orientation angle into a unit vector facing in that
/// direction.
///
/// Every `Steerable` object has property `angle` that describes its
/// orientation in the 2D world. However, this property is somewhat ambiguous
/// in that it doesn't describe which direction corresponds to angle `0`.
/// This method removes such ambiguity. The default implementation corresponds
/// to angle 0 pointing rightwards, and angles growing in the counterclockwise
/// direction.
Vector2 Function(double angle) angleToVector = _defaultAngleToVector;

/// Method to compute the orientation angle of a non-zero vector.
///
/// This method must be the inverse of [angleToVector], modulo τ.
double Function(Vector2 vector) vectorToAngle = _defaultVectorToAngle;

Vector2 _defaultAngleToVector(double angle) {
  return Vector2(cos(angle), -sin(angle));
}

double _defaultVectorToAngle(Vector2 vector) {
  return atan2(-vector.y, vector.x);
}
