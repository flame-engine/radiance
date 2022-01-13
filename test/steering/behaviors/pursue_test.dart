import 'package:radiance/steering.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../utils/simple_steerable.dart';

void main() {
  group('Pursue', () {
    test('properties', () {
      final target = SimpleSteerable();
      final pursuer = SimpleSteerable(kinematics: LightKinematics(10));
      final behavior = Pursue(owner: pursuer, target: target);
      pursuer.behavior = behavior;

      expect(behavior.own, pursuer);
      expect(behavior.target, target);
      expect(behavior.predictionTime, 3.0);
    });

    test('pursuit exact', () {
      final t = simulateFastPursuit(
        targetVelocity: Vector2(-20, 0),
        initialPosition: Vector2(100, 0),
        initialVelocity: Vector2.zero(),
        kinematics: HeavyKinematics(maxSpeed: 50, maxAcceleration: 10),
        captureDistance: 15,
      );
      // At acceleration 10, the agent will gain max speed in 5 seconds; since
      // it needs to be within distance 15 from the target, the capture must
      // occur in 7 seconds:
      //   100 + 20t == 50(t - 5) + 1/2*10*5^2 + 15  => t = 7
      expect(t, closeTo(7, 0.01));
    });

    // All other tests simply try various configurations, and then assert that
    // the capture time should be close to what was observed at previous runs
    // of the same test. Future improvements to the pursuit algorithm may
    // bring these times down. If they go up, then it wasn't an improvement.

    test('pursuit 1', () {
      final t = simulateFastPursuit(
        initialPosition: Vector2(100, 30),
        targetVelocity: Vector2(-10, -10),
        initialVelocity: Vector2.zero(),
        kinematics: HeavyKinematics(maxSpeed: 50, maxAcceleration: 20),
        predictionTime: 5,
      );
      expect(t, closeTo(4.40, 0.01));
    });

    test('pursuit 2', () {
      final t = simulateFastPursuit(
        initialPosition: Vector2(100, 30),
        initialVelocity: Vector2(-10, -10),
        targetVelocity: Vector2(0, 40),
        kinematics: HeavyKinematics(maxSpeed: 50, maxAcceleration: 10),
      );
      expect(t, closeTo(16.20, 0.01));
    });

    test('pursuit 3', () {
      final t = simulateFastPursuit(
        initialPosition: Vector2(-50, 0),
        initialVelocity: Vector2.zero(),
        targetVelocity: Vector2(0, -20),
        kinematics: HeavyKinematics(maxSpeed: 50, maxAcceleration: 20),
      );
      expect(t, closeTo(2.75, 0.01));
    });

    test('pursuit 4', () {
      final t = simulateFastPursuit(
        targetVelocity: Vector2(0, 20),
        initialPosition: Vector2(-30, 0),
        initialVelocity: Vector2(40, -10),
        kinematics: HeavyKinematics(maxSpeed: 50, maxAcceleration: 20),
        captureDistance: 10,
      );
      expect(t, closeTo(5.01, 0.01));
    });

    test('pursuit 5', () {
      final t = simulateFastPursuit(
        targetVelocity: Vector2(-20, -10),
        initialPosition: Vector2(-40, 0),
        initialVelocity: Vector2(10, 30),
        kinematics: HeavyKinematics(maxSpeed: 50, maxAcceleration: 10),
      );
      expect(t, closeTo(10.84, 0.01));
    });

    test('pursuit 6', () {
      final t = simulateFastPursuit(
        targetVelocity: Vector2(20, -10),
        initialPosition: Vector2(40, 0),
        initialVelocity: Vector2(-20, 30),
        kinematics: HeavyKinematics(maxSpeed: 50, maxAcceleration: 1000),
      );
      expect(t, closeTo(0.53, 0.01));
    });

    test('pursuit 6-2', () {
      final t = simulateFastPursuit(
        targetVelocity: Vector2(20, -10),
        initialPosition: Vector2(40, 0),
        initialVelocity: Vector2(-20, 30),
        kinematics: LightKinematics(50),
      );
      expect(t, closeTo(0.51, 0.01));
    });

    test('chase 1', () {
      final distance = simulateSlowPursuit(
        targetPosition: Vector2(50, 30),
        targetVelocity: Vector2(0, 30),
        agentInitialVelocity: Vector2.zero(),
        kinematics: HeavyKinematics(maxSpeed: 25, maxAcceleration: 20),
      );
      expect(distance, closeTo(300.04, 0.01));
    });

    test('chase 2', () {
      final distance = simulateSlowPursuit(
        targetPosition: Vector2(50, -20),
        targetVelocity: Vector2(0, 30),
        agentInitialVelocity: Vector2.zero(),
        kinematics: HeavyKinematics(maxSpeed: 25, maxAcceleration: 120),
      );
      expect(distance, closeTo(240.5, 0.01));
    });

    test('chase 3', () {
      final distance = simulateSlowPursuit(
        targetPosition: Vector2(50, 0),
        targetVelocity: Vector2(0, 30),
        agentInitialVelocity: Vector2.zero(),
        kinematics: HeavyKinematics(maxSpeed: 30, maxAcceleration: 200),
      );
      expect(distance, closeTo(9.01, 0.01));
    });
  });
}

/// Given the target that starts at the origin and then moves at a constant
/// [targetVelocity], and the pursuer that starts at [initialPosition] and moves
/// at [initialVelocity] -- calculate the time it would take the pursuer to
/// capture the target. The max speed of the pursuer must exceed the max speed
/// of the target.
///
/// The return value is the amount of time it took for the pursuer to
/// reach its target, assuming the capture happens when the distance
/// between the pursuer and the target is less than [captureDistance].
double simulateFastPursuit({
  required Vector2 initialVelocity,
  required Vector2 initialPosition,
  required Vector2 targetVelocity,
  required Kinematics kinematics,
  double predictionTime = 3.0,
  double captureDistance = 5.0,
}) {
  const dt = 0.01;
  const timeout = 1000.0;
  final target = SimpleSteerable(velocity: targetVelocity);
  final pursuer = SimpleSteerable(
    position: initialPosition,
    velocity: initialVelocity,
    kinematics: kinematics,
  );
  pursuer.behavior = Pursue(
    owner: pursuer,
    target: target,
    predictionTime: predictionTime,
  );
  var timer = 0.0;
  while ((pursuer.position - target.position).length > captureDistance &&
      timer < timeout) {
    target.update(dt);
    pursuer.update(dt);
    timer += dt;
    // print('target=${target.position}, pursuer=${pursuer.position}');
  }
  return timer;
}

/// Similar to `simulateFastPursuit`, but this time the target is moving
/// faster than the pursuer, so we expect the agent will never catch up.
/// Thus, this function returns the distance between the target and the
/// agent after the [duration] seconds. The capture is not simulated
/// (even if the pursuer is lucky and the target moves straight at them).
double simulateSlowPursuit({
  required Vector2 targetPosition,
  required Vector2 targetVelocity,
  required Vector2 agentInitialVelocity,
  required Kinematics kinematics,
  double dt = 0.02,
  double duration = 50,
}) {
  final target = SimpleSteerable(
    position: targetPosition,
    velocity: targetVelocity,
  );
  final pursuer = SimpleSteerable(
    velocity: agentInitialVelocity,
    kinematics: kinematics,
  );
  pursuer.behavior = Pursue(owner: pursuer, target: target);

  var totalTime = 0.0;
  while (totalTime < duration) {
    target.update(dt);
    pursuer.update(dt);
    totalTime += dt;
  }
  return (target.position - pursuer.position).length;
}
