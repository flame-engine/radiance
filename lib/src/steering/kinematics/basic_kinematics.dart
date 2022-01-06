import '../kinematics.dart';

/// [BasicKinematics] class describes motion at a constant linear and
/// angular velocities. Those velocities can be set by the user to arbitrary
/// values.
class BasicKinematics extends Kinematics {
  @override
  void update(double dt) {
    own.position.x += own.velocity.x * dt;
    own.position.y += own.velocity.y * dt;
    own.angle += own.angularVelocity * dt;
  }
}
