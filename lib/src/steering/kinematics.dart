import 'steerable.dart';

/// [Kinematics] class describes laws of motion and constraints on the movements
/// of a [Steerable].
///
/// Usually, this class will contain one or more _control variables_ describing
/// the desired steering at the current moment in time, and the logic to apply
/// those steering controls to affect the motion of the own [Steerable].
///
/// The base [Kinematics] class describes motion at a constant linear and
/// angular velocities. Those velocities can be set by the user to arbitrary
/// values.
class Kinematics {
  late final Steerable own;

  void update(double dt) {
    own.position.x += own.velocity.x * dt;
    own.position.y += own.velocity.y * dt;
    own.angle += own.angularVelocity * dt;
  }
}
