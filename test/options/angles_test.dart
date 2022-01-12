import 'dart:math';

import 'package:radiance/steering.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

import '../utils/close_to_vector.dart';

void main() {
  group('Utils', () {
    const tau = pi * 2;

    test('angleToVector', () {
      expect(angleToVector(0), closeToVector(1, 0));
      expect(angleToVector(tau / 4), closeToVector(0, -1));
      expect(angleToVector(tau / 2), closeToVector(-1, 0));
      expect(angleToVector(3 / 4 * tau), closeToVector(0, 1));
      expect(angleToVector(2), closeToVector(cos(2), -sin(2)));
    });

    test('vectorToAngle', () {
      expect(vectorToAngle(Vector2(1, 0)), closeTo(0, 1e-15));
      expect(vectorToAngle(Vector2(-1, 0)), closeTo(-tau / 2, 1e-15));
      expect(vectorToAngle(Vector2(0, -1)), closeTo(tau / 4, 1e-15));
      expect(vectorToAngle(Vector2(0, 1)), closeTo(-tau / 4, 1e-15));
      expect(vectorToAngle(Vector2(1, 1)), closeTo(-tau / 8, 1e-15));
      expect(vectorToAngle(Vector2(3, -4)), closeTo(acos(0.6), 1e-15));
    });

    test('change angleToVector', () {
      final f = angleToVector;
      angleToVector = (double a) => Vector2(0, -1);
      expect(angleToVector(0), closeToVector(0, -1));
      expect(angleToVector(tau / 2), closeToVector(0, -1));
      angleToVector = f;
    });
  });
}
