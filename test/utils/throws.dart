import 'package:test/test.dart' hide throws;

/// Matcher that can be used in a test that expects an error to be thrown.
///
/// This is similar to standard `throwsA` matcher, but also allows an optional
/// message string to verify that the error has the expected message.
///
/// For example:
/// ```dart
/// expect(
///   () => PositionComponent(size: Vector2.all(-1)),
///   throws<AssertionError>('size of a PositionComponent cannot be negative'),
/// )
/// ```
///
/// When using this function make sure to hide `throws` from the official
/// "package:test" (where the function is deprecated).
Matcher throws<E extends Error>([String? message]) {
  var typeMatcher = isA<E>();
  if (message != null) {
    typeMatcher = typeMatcher.having(
      (dynamic e) => e.message, // ignore: avoid_dynamic_calls
      'message',
      message,
    );
  }
  return throwsA(typeMatcher);
}
