import 'package:radiance/steering.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

import '../utils/close_to_vector.dart';
import '../utils/simple_steerable.dart';

void main() {
  group('Steerable', () {
    test('properties:read', () {
      final Steerable steerable = SimpleSteerable(velocity: Vector2.all(10));
      expect(steerable.position, closeToVector(0, 0));
      expect(steerable.velocity, closeToVector(10, 10));
      expect(steerable.angle, 0);
      expect(steerable.angularVelocity, 0);
    });

    // Check that Steerable interface allows updating the state of the object.
    test('properties:write', () {
      final Steerable steerable = SimpleSteerable();
      steerable.position.setValues(5, 7);
      steerable.velocity.setValues(-11, 13);
      steerable.angle = 3.14;
      steerable.angularVelocity = -0.6;
      expect(steerable.position, closeToVector(5, 7));
      expect(steerable.velocity, closeToVector(-11, 13));
      expect(steerable.angle, 3.14);
      expect(steerable.angularVelocity, -0.6);
    });

    // Steerable's [kinematics] must always have a valid back-reference to its
    // containing Steerable object.
    test('kinematics.own', () {
      final Steerable steerable = SimpleSteerable();
      expect(steerable.kinematics.owner, steerable);
    });
  });
}
