import 'package:radiance/src/steering/behaviors/flee.dart';
import 'package:radiance/src/steering/behaviors/seek.dart';
import 'package:radiance/steering.dart';
import 'package:test/test.dart' hide throws;
import 'package:vector_math/vector_math_64.dart';

import '../../utils/close_to_vector.dart';
import '../../utils/simple_steerable.dart';
import '../../utils/throws.dart';

void main() {
  group('HeavyKinematics', () {
    test('basic properties', () {
      final kinematics = HeavyKinematics(maxSpeed: 5, maxAcceleration: 3);
      expect(kinematics.maxSpeed, 5);
      expect(kinematics.maxAcceleration, 3);
    });

    test('maxSpeed', () {
      final kinematics = HeavyKinematics(maxSpeed: 5, maxAcceleration: 3);
      kinematics.maxSpeed = 1;
      expect(kinematics.maxSpeed, 1);
      expect(
        () => kinematics.maxSpeed = 0,
        throws<AssertionError>('maxSpeed must be positive'),
      );
    });

    test('maxAcceleration', () {
      final kinematics = HeavyKinematics(maxSpeed: 5, maxAcceleration: 3);
      kinematics.maxAcceleration = 1;
      expect(kinematics.maxAcceleration, 1);
      expect(
        () => kinematics.maxAcceleration = 0,
        throws<AssertionError>('maxAcceleration must be positive'),
      );
    });

    test('setAcceleration', () {
      final kinematics = HeavyKinematics(maxSpeed: 10, maxAcceleration: 10);
      final agent = SimpleSteerable(kinematics: kinematics);
      // First update is a no-op since the velocity and acceleration is zero
      agent.update(1);
      expect(agent.velocity, closeToVector(0, 0));
      kinematics.setAcceleration(Vector2(10, 0));
      // Second update changes velocity (because there's acceleration set)
      agent.update(1);
      expect(agent.position, closeToVector(0, 0));
      expect(agent.velocity, closeToVector(10, 0));
      // Third update can no longer increase velocity since it's at max
      agent.update(1);
      expect(agent.position, closeToVector(10, 0));
      expect(agent.velocity, closeToVector(10, 0));

      expect(
        () => kinematics.setAcceleration(Vector2(10, 10)),
        throws<AssertionError>(
          'Trying to set acceleration=[10.0,10.0] larger than max=10.0',
        ),
      );
    });

    test('errors', () {
      expect(
        () => HeavyKinematics(maxSpeed: 0, maxAcceleration: 5),
        throws<AssertionError>('maxSpeed must be positive'),
      );
      expect(
        () => HeavyKinematics(maxSpeed: 10, maxAcceleration: 0),
        throws<AssertionError>('maxAcceleration must be positive'),
      );
    });

    test('seek', () {
      final kinematics = HeavyKinematics(maxSpeed: 5, maxAcceleration: 3);
      final agent = SimpleSteerable(kinematics: kinematics);
      final seek = agent.kinematics.seek(Vector2.zero());
      expect(seek, isA<SeekHeavy>());
    });

    test('flee', () {
      final kinematics = HeavyKinematics(maxSpeed: 5, maxAcceleration: 3);
      final agent = SimpleSteerable(kinematics: kinematics);
      final flee = agent.kinematics.flee([Vector2.zero()]);
      expect(flee, isA<FleeHeavy>());
    });
  });
}
