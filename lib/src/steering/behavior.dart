import 'steerable.dart';

abstract class Behavior {
  late final Steerable owner;

  void calculateSteering(double dt);
}
