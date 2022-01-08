import 'dart:math';

import 'package:meta/meta.dart';
import 'package:test/test.dart';

final _seedGenerator = Random();
// Maximum value allowed for `Random.nextInt()`
const _maxSeed = 1 << 32;

/// This function is equivalent to `test(name, body)`, except that it is
/// better suited for randomized testing: it will create a Random
/// generator and pass it to the test body, but also record the seed
/// that was used for creating the random generator. Thus, if a test
/// fails for a specific rare seed, it would be easy to reproduce this
/// failure.
///
/// In order for this to work properly, all random numbers used within
/// `testRandom()` must be obtained through the provided random generator.
///
/// Example of use:
/// ```dart
/// testRandom('description', (Random random) {
///   expect(random.nextDouble() == random.nextDouble(), false);
/// });
/// ```
/// Then if the test output shows that the test failed with seed `s`,
/// simply adding parameter `seed=s` into the function will force it
/// to use that specific seed.
///
/// Optional parameter [repeatCount] allows the test to be repeated multiple
/// times, each time with a different seed.
@isTest
void testRandom(
  String name,
  void Function(Random random) body, {
  int? seed,
  int repeatCount = 1,
}) {
  assert(repeatCount > 0);
  for (var i = 0; i < repeatCount; i++) {
    final seed0 = seed ?? _seedGenerator.nextInt(_maxSeed);
    test(
      '$name [seed=$seed0]',
      () => body(Random(seed0)),
    );
  }
}
