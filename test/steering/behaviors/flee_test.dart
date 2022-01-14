import 'package:radiance/steering.dart';
import 'package:test/test.dart' hide throws;
import 'package:vector_math/vector_math_64.dart';

import '../../utils/close_to_vector.dart';
import '../../utils/simple_steerable.dart';
import '../../utils/throws.dart';

void main() {
  group('Flee', () {
    group('common', () {
      test('errors', () {
        final agent = SimpleSteerable(kinematics: MaxSpeedKinematics(10));
        expect(
          () => Flee(owner: agent, targets: []),
          throws<AssertionError>('The list of targets to Flee cannot be empty'),
        );
      });

      /// Return flee direction against the set of [targets], for an agent with
      /// initial facing direction given by [orientation].
      Vector2 getFleeDirection(
        List<Vector2> targets, {
        double orientation = 0,
      }) {
        final agent = SimpleSteerable(kinematics: MaxSpeedKinematics(10));
        agent.angle = orientation;
        final behavior = Flee(owner: agent, targets: targets);
        expect(agent.position, closeToVector(0, 0));
        return behavior.fleeDirection;
      }

      // Fleeing from the point you're currently at
      test('fleeDirection: on target', () {
        final direction1 = getFleeDirection([Vector2.zero()]);
        expect(direction1, closeToVector(1, 0));
        final direction2 = getFleeDirection([Vector2.zero()], orientation: 1);
        expect(direction2, closeToVector(0.540302, -0.841471, epsilon: 1e-5));
      });

      // Fleeing when in the middle of a square
      test('fleeDirection: surrounded', () {
        final targets = [
          Vector2(0, 10),
          Vector2(10, 0),
          Vector2(-10, 0),
          Vector2(0, -10),
        ];
        final direction = getFleeDirection(targets);
        expect(direction, closeToVector(1, 0));
      });

      // When much closer to one of the targets, it becomes dominant
      test('fleeDirection: uneven', () {
        final targets = [Vector2(1, 0), Vector2(-5, 5), Vector2(-5, -5)];
        final direction = getFleeDirection(targets);
        expect(direction, closeToVector(-1, 0));
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

      test('flee 1', () {
        final distance = fleeDistance(
          initialPosition: Vector2(5, 0),
          initialVelocity: Vector2.zero(),
          kinematics: MaxSpeedKinematics(10),
          duration: 10,
        );
        expect(distance, closeTo(105, 0.1));
      });

      test('flee 2', () {
        final distance = fleeDistance(
          initialPosition: Vector2(12, -10),
          initialVelocity: Vector2(3, 5),
          kinematics: MaxSpeedKinematics(10),
        );
        expect(distance, closeTo(1015.62, 0.01));
      });

      test('flee 3', () {
        final distance = fleeDistance(
          initialPosition: Vector2(0, 0.01),
          initialVelocity: Vector2.zero(),
          kinematics: MaxSpeedKinematics(10),
          targets: [Vector2(10, 0), Vector2(-10, 3), Vector2(-10, -3)],
        );
        expect(distance, closeTo(999.71, 0.01));
      });

      /// Normally, the agent is able to escape even if completely surrounded.
      test('flee 4', () {
        final distance = fleeDistance(
          initialPosition: Vector2(0.02, 0.01),
          initialVelocity: Vector2.zero(),
          kinematics: MaxSpeedKinematics(10),
          targets: [
            Vector2(10, 0),
            Vector2(-10, 0),
            Vector2(0, 10),
            Vector2(0, -10),
            Vector2(7, 7),
            Vector2(7, -7),
            Vector2(-7, 7),
            Vector2(-7, -7),
          ],
        );
        expect(distance, closeTo(998.22, 0.01));
      });

      /// However, when the initial configuration is symmetrical with respect
      /// to the targets, the agent may get "stuck" in infinite loop.
      test('flee 5', () {
        final distance = fleeDistance(
          initialPosition: Vector2.zero(),
          initialVelocity: Vector2.zero(),
          kinematics: MaxSpeedKinematics(10),
          targets: [Vector2(10, 0), Vector2(-10, 4), Vector2(-10, -4)],
        );
        expect(distance, closeTo(6.33, 0.01));
      });
    });

    group(':MaxAccelerationKinematics', () {
      test('properties', () {
        final agent = SimpleSteerable(
          kinematics: MaxAccelerationKinematics(
            maxSpeed: 20,
            maxAcceleration: 15,
          ),
        );
        final behavior = Flee(owner: agent, targets: [Vector2(20, 10)]);
        expect(behavior.own, agent);
        expect(behavior.targets.length, 1);
        expect(behavior.targets.first, closeToVector(20, 10));
      });

      test('flee 1', () {
        const x0 = 5.0;
        const vMax = 10.0;
        const aMax = 5.0;
        const t0 = 10.0;
        final distance = fleeDistance(
          initialPosition: Vector2(x0, 0),
          initialVelocity: Vector2.zero(),
          kinematics: MaxAccelerationKinematics(
            maxSpeed: vMax,
            maxAcceleration: aMax,
          ),
          duration: t0,
        );
        const t1 = vMax / aMax; // time to gain full speed
        // expected coordinate after t0 time
        const x1 = x0 + (t0 - t1) * vMax + 1 / 2 * aMax * t1 * t1;
        expect(distance, closeTo(x1, 0.1));
      });

      test('flee 2', () {
        final distance = fleeDistance(
          initialPosition: Vector2(12, -10),
          initialVelocity: Vector2(3, 5),
          kinematics: MaxAccelerationKinematics(
            maxSpeed: 10,
            maxAcceleration: 5,
          ),
        );
        expect(distance, closeTo(1006.42, 0.01));
      });

      test('flee 3', () {
        final distance = fleeDistance(
          initialPosition: Vector2(0, 0.01),
          initialVelocity: Vector2.zero(),
          kinematics: MaxAccelerationKinematics(
            maxSpeed: 10,
            maxAcceleration: 5,
          ),
          targets: [Vector2(10, 0), Vector2(-10, 3), Vector2(-10, -3)],
        );
        expect(distance, closeTo(966.64, 0.01));
      });

      test('flee 4', () {
        final distance = fleeDistance(
          initialPosition: Vector2(0.02, 0.01),
          initialVelocity: Vector2.zero(),
          kinematics: MaxAccelerationKinematics(
            maxSpeed: 10,
            maxAcceleration: 5,
          ),
          targets: [
            Vector2(10, 0),
            Vector2(-10, 0),
            Vector2(0, 10),
            Vector2(0, -10),
            Vector2(7, 7),
            Vector2(7, -7),
            Vector2(-7, 7),
            Vector2(-7, -7),
          ],
        );
        expect(distance, closeTo(978.90, 0.01));
      });
    });
  });
}

/// Return the distance between the runner and his flee target(s) after the
/// [duration] seconds.
double fleeDistance({
  required Vector2 initialPosition,
  required Vector2 initialVelocity,
  required Kinematics kinematics,
  List<Vector2>? targets,
  double duration = 100.0,
  double dt = 0.01,
}) {
  final runner = SimpleSteerable(
    velocity: initialVelocity,
    position: initialPosition,
    kinematics: kinematics,
  );
  runner.behavior = Flee(
    owner: runner,
    targets: targets ?? [Vector2.zero()],
  );

  for (var time = 0.0; time <= duration; time += dt) {
    runner.update(dt);
  }
  if (targets == null) {
    return runner.position.length;
  } else {
    final sum = Vector2.zero();
    for (final target in targets) {
      sum.x += runner.position.x - target.x;
      sum.y += runner.position.y - target.y;
    }
    return sum.length / targets.length;
  }
}
