import 'package:radiance/steering.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../utils/close_to_vector.dart';
import '../../utils/simple_steerable.dart';
import '../../utils/throws_assertion_error.dart';

void main() {
  group('Flee', () {
    group('common', () {
      test('errors', () {
        final agent = SimpleSteerable(kinematics: MaxSpeedKinematics(10));
        expect(
          () => Flee(owner: agent, targets: []),
          throwsAssertionError('The list of targets to Flee cannot be empty'),
        );
      });

      Vector2 getFleeDirection(List<Vector2> targets) {
        final agent = SimpleSteerable(kinematics: MaxSpeedKinematics(10));
        final behavior = Flee(owner: agent, targets: targets);
        expect(agent.position, closeToVector(0, 0));
        return behavior.fleeDirection;
      }

      // Fleeing from the point you're currently at
      test('fleeDirection: on target', () {
        final direction = getFleeDirection([Vector2.zero()]);
        expect(direction.length, closeTo(1, 1e-10));
        final direction2 = getFleeDirection([Vector2.zero()]);
        expect(direction == direction2, false);
      });

      // Fleeing when in the middle of a square
      test('fleeDirection: surrounded', () {
        final targets = [
          Vector2(0, 10),
          Vector2(10, 0),
          Vector2(-10, 0),
          Vector2(0, -10),
        ];
        final direction1 = getFleeDirection(targets);
        final direction2 = getFleeDirection(targets);
        expect(direction1.length, closeTo(1, 1e-10));
        expect(direction2.length, closeTo(1, 1e-10));
        expect(direction1 == direction2, false);
      });

      // When much closer to one of the targets, it becomes dominant
      test('fleeDirection: uneven', () {
        final targets = [Vector2(-1, 0), Vector2(5, 5), Vector2(5, -5)];
        final direction = getFleeDirection(targets);
        expect(direction, closeToVector(1, 0));
      });
    });

    group(':MaxSpeedKinematics', () {
      test('properties', () {
        final agent = SimpleSteerable(kinematics: MaxSpeedKinematics(10));
        final behavior = Flee(owner: agent, targets: [Vector2(20, 10)]);
        expect(behavior.own, agent);
        expect(behavior.targets.length, 1);
        expect(behavior.targets.first, closeToVector(20, 10));
      });
    });

    group(':MaxAccelerationKinematics', () {});
  });
}
