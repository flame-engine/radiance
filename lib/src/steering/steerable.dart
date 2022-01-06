import 'package:vector_math/vector_math_64.dart';
import 'kinematics.dart';

/// [Steerable] is the simple interface that describes a mobile agent, vehicle,
/// character, or an entity.
///
/// This interface is the primary tool for integrating the Radiance library into
/// another project. Do the following:
///   1. Create a `MySteerable` class that implements [Steerable].
///   2. When setting the [kinematics] property of the object, make sure to call
///      the `kinematics.handleAttach()` method.
///   3. Repeatedly call `kinematics.update()` method as time progresses.
///   4. If the object needs to be steered, then instantiate an appropriate
///      [Behavior] and periodically call its `update()` method.
abstract class Steerable {
  Vector2 get position;
  Vector2 get velocity;
  double get angle;
  double get angularVelocity;
  Kinematics get kinematics;

  set angle(double value);
  set angularVelocity(double value);
}
