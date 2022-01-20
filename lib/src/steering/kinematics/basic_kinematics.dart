import '../kinematics.dart';

/// [BasicKinematics] class describes motion at a constant linear and
/// angular velocities. Those velocities can be set by the user to arbitrary
/// values.
class BasicKinematics extends Kinematics {
  @override
  void update(double dt) {
    owner.position.x += owner.velocity.x * dt;
    owner.position.y += owner.velocity.y * dt;
    owner.angle += owner.angularVelocity * dt;
  }
}
