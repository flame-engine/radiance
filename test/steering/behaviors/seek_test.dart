import 'dart:math';

import 'package:radiance/steering.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../utils/close_to_vector.dart';
import '../../utils/simple_steerable.dart';
import '../../utils/test_random.dart';

void main() {
  group('Seek', () {
    group(':LightKinematics', () {
      test('properties', () {
        final agent = SimpleSteerable(kinematics: LightKinematics(10));
        final behavior = Seek(owner: agent, point: Vector2(20, 50));

        expect(behavior.own, agent);
        expect(behavior.target, closeToVector(20, 50));
      });

      // The seeker will go towards the target at full speed, irrespective of
      // its initial velocity. Thus, the expected time is the distance from
      // target divided by the max speed.
      //
      // In addition, MaxSpeedKinematics allows the agent to make sudden stops,
      // thus we expect that in the end the seeker will come at rest at the
      // destination point (like Arrival behavior).
      testRandom('random simulation', (Random rng) {
        const maxSpeed = 10.0;
        const dt = 0.01;
        final origin = Vector2.random(rng) * 50;
        final target = Vector2.random(rng) * 100;
        final seeker = SimpleSteerable(
          velocity: Vector2.random() * maxSpeed,
          position: origin.clone(),
          kinematics: LightKinematics(maxSpeed),
        );
        seeker.behavior = Seek(owner: seeker, point: target);

        final expectedTime = (target - origin).length / maxSpeed;
        for (var time = 0.0; time <= expectedTime; time += dt) {
          seeker.update(dt);
        }
        seeker.update(dt);
        expect(
          seeker.position,
          closeToVector(target.x, target.y, epsilon: 1e-5),
        );
        expect(seeker.velocity, closeToVector(0, 0));
        expect(seeker.angle, closeTo(vectorToAngle(target - origin), 1e-10));
      });
    });

    group(':HeavyKinematics', () {
      test('properties', () {
        final agent = SimpleSteerable(
          kinematics: HeavyKinematics(
            maxSpeed: 10,
            maxAcceleration: 20,
          ),
        );
        final behavior = Seek(owner: agent, point: Vector2(20, 50));

        expect(behavior.own, agent);
        expect(behavior.target, closeToVector(20, 50));
      });

      // If the agent starts at rest, the optimal strategy is to accelerate
      // towards the target at max force. Using equation `d = 1/2 a*t^2` we
      // can compute the time when agent should reach the target.
      test('starting at rest', () {
        const dt = 0.01;
        const acceleration = 10.0;
        final agent = SimpleSteerable(
          position: Vector2.zero(),
          velocity: Vector2.zero(),
          kinematics: HeavyKinematics(
            maxSpeed: 1000,
            maxAcceleration: acceleration,
          ),
        );
        final behavior = Seek(owner: agent, point: Vector2(30, 40));
        agent.behavior = behavior;
        final distance = (behavior.target - agent.position).length;
        final expectedTime = sqrt(2 * distance / acceleration);
        for (var time = 0.0; time <= expectedTime; time += dt) {
          agent.update(dt);
        }
        expect(agent.position, closeToVector(30, 40, epsilon: 0.1));
      });

      // When the agent starts with a non-zero initial velocity, calculating
      // time before reaching the target becomes too hard. Instead, we merely
      // check the target will be reached eventually.
      testRandom('random simulation', (Random rng) {
        const maxSpeed = 10.0;
        const acceleration = 15.0;
        const dt = 0.01;
        final origin = Vector2.random(rng) * 50;
        final target = Vector2.random(rng) * 100;
        final seeker = SimpleSteerable(
          velocity: Vector2.random() * maxSpeed,
          position: origin,
          kinematics: HeavyKinematics(
            maxSpeed: maxSpeed,
            maxAcceleration: acceleration,
          ),
        );
        seeker.behavior = Seek(owner: seeker, point: target);

        var reached = false;
        for (var time = 0.0; time <= 1000; time += dt) {
          seeker.update(dt);
          if ((seeker.position - target).length < 0.1) {
            reached = true;
            break;
          }
        }
        expect(reached, isTrue);
      });

      // Helper function to compute how long it would take for the seeker to
      // reach the origin given the initial configuration.
      double seekTime({
        required Vector2 initialPosition,
        required Vector2 initialVelocity,
        required double maxSpeed,
        required double maxAcceleration,
        double arriveRadius = 0.1,
      }) {
        const dt = 0.01;
        final seeker = SimpleSteerable(
          velocity: initialVelocity,
          position: initialPosition,
          kinematics: HeavyKinematics(
            maxSpeed: maxSpeed,
            maxAcceleration: maxAcceleration,
          ),
        );
        seeker.behavior = Seek(owner: seeker, point: Vector2.zero());

        for (var time = 0.0; time <= 1000; time += dt) {
          seeker.update(dt);
          if (seeker.position.length < arriveRadius) {
            return time;
          }
        }
        return double.infinity;
      }

      // The following tests are to ensure that any changes in Seek behavior
      // do not degrade the timings.
      test('seek 1', () {
        final time = seekTime(
          initialPosition: Vector2(100, 20),
          initialVelocity: Vector2(10, 5),
          maxSpeed: 20,
          maxAcceleration: 3,
        );
        expect(time, closeTo(13.11, 0.01));
      });

      test('seek 2', () {
        final time = seekTime(
          initialPosition: Vector2(-30, 40),
          initialVelocity: Vector2(0, 5),
          maxSpeed: 30,
          maxAcceleration: 50,
        );
        expect(time, closeTo(2.05, 0.01));
      });

      test('seek 3', () {
        final time = seekTime(
          initialPosition: Vector2(70, 140),
          initialVelocity: Vector2(20, 10),
          maxSpeed: 30,
          maxAcceleration: 10,
        );
        expect(time, closeTo(9.36, 0.01));
      });

      test('seek 4', () {
        final time = seekTime(
          initialPosition: Vector2(0, 1),
          initialVelocity: Vector2(5, 0),
          maxSpeed: 10,
          maxAcceleration: 5,
        );
        expect(time, closeTo(6.06, 0.01));
      });
    });
  });
}
