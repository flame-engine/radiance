
import 'steerable.dart';

abstract class Behavior {
  Behavior(this.own);

  final Steerable own;

  void update(double dt);
}
