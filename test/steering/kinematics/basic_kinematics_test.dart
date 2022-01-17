import 'package:radiance/src/steering/kinematics/basic_kinematics.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../utils/close_to_vector.dart';
import '../../utils/simple_steerable.dart';

void main() {
  group('BasicKinematics', () {
    test('clone', () {
      final kinematics = BasicKinematics();
      final copy = kinematics.clone();
      expect(copy, isA<BasicKinematics>());
      expect(copy == kinematics, false);
    });

    test('update', () {
      final agent = SimpleSteerable(
        position: Vector2(5, 10),
        velocity: Vector2(2, 5),
        angularVelocity: 1,
        kinematics: BasicKinematics(),
      );

      agent.kinematics.update(0.5);
      expect(agent.position, closeToVector(6, 12.5));
      expect(agent.angle, closeTo(0.5, 1e-15));
    });
  });
}
