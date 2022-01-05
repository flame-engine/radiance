import 'package:vector_math/vector_math_64.dart';

import 'kinematics.dart';

abstract class Steerable {
  Vector2 get position;
  Vector2 get velocity;
  double get angle;
  set angle(double value);
  double get angularVelocity;
  Kinematics get locomotion;
}
