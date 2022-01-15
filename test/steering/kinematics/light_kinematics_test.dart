import 'package:radiance/src/steering/behaviors/flee.dart';
import 'package:radiance/src/steering/behaviors/seek.dart';
import 'package:radiance/steering.dart';
import 'package:test/test.dart' hide throws;
import 'package:vector_math/vector_math_64.dart';

import '../../utils/close_to_vector.dart';
import '../../utils/simple_steerable.dart';
import '../../utils/throws.dart';

void main() {
  group('LightKinematics', () {
    test('basic properties', () {
      final kinematics = LightKinematics(5);
      expect(kinematics.maxSpeed, 5);
      kinematics.maxSpeed = 10;
      expect(kinematics.maxSpeed, 10);
    });

    test('speed errors', () {
      expect(
        () => LightKinematics(0),
        throws<AssertionError>('maxSpeed must be positive'),
      );
      final kinematics = LightKinematics(1);
      expect(
        () => kinematics.maxSpeed = -1,
        throws<AssertionError>('maxSpeed must be positive'),
      );
    });

    test('stop', () {
      final kinematics = LightKinematics(10);
      final agent = SimpleSteerable(
        velocity: Vector2(10, 5),
        kinematics: kinematics,
      );
      expect(agent.velocity, closeToVector(10, 5));
      kinematics.stop();
      expect(agent.velocity, closeToVector(0, 0));
    });

    test('setVelocity', () {
      final kinematics = LightKinematics(10);
      final agent = SimpleSteerable(
        velocity: Vector2(3, 4),
        kinematics: kinematics,
      );
      kinematics.setVelocity(Vector2(5, 8));
      expect(agent.velocity, closeToVector(5, 8));
      kinematics.setVelocity(Vector2(6, 8));
      kinematics.setVelocity(Vector2(6 + 1e-10, 8 + 1e-10));
      expect(agent.velocity, closeToVector(6 + 1e-10, 8 + 1e-10));
      expect(
        () => kinematics.setVelocity(Vector2(12, 8)),
        throws<AssertionError>(
          'Trying to set velocity=[12.0,8.0] larger than maxSpeed=10.0',
        ),
      );
    });

    test('setVelocitySafe', () {
      final kinematics = LightKinematics(10);
      final agent = SimpleSteerable(
        velocity: Vector2(3, 4),
        kinematics: kinematics,
      );
      kinematics.setVelocitySafe(Vector2(-6, -8));
      expect(agent.velocity, closeToVector(-6, -8));
      kinematics.setVelocitySafe(Vector2(12, 16));
      expect(agent.velocity, closeToVector(6, 8));
      kinematics.setVelocitySafe(Vector2(12, -16));
      expect(agent.velocity, closeToVector(6, -8));
    });

    test('seek', () {
      final agent = SimpleSteerable(kinematics: LightKinematics(10));
      final seek = agent.kinematics.seek(Vector2.zero());
      expect(seek, isA<SeekLight>());
    });

    test('flee', () {
      final agent = SimpleSteerable(kinematics: LightKinematics(10));
      final flee = agent.kinematics.flee([Vector2.zero()]);
      expect(flee, isA<FleeLight>());
    });
  });
}
