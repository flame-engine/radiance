import 'package:radiance/src/steering/kinematics.dart';
import 'package:test/test.dart' hide throws;
import 'package:vector_math/vector_math_64.dart';

import '../utils/simple_steerable.dart';
import '../utils/throws.dart';

void main() {
  group('Kinematics', () {
    test('behavior factories', () {
      final agent = SimpleSteerable(kinematics: NonceKinematics());

      expect(
        () => agent.kinematics.seek(Vector2.zero()),
        throws<UnsupportedError>(
          'Seek behavior is not available for NonceKinematics',
        ),
      );

      expect(
        () => agent.kinematics.flee([Vector2.zero()]),
        throws<UnsupportedError>(
          'Flee behavior is not available for NonceKinematics',
        ),
      );
    });
  });
}

class NonceKinematics extends Kinematics {
  @override
  void update(double dt) {}
}
