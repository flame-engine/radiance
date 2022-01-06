import 'package:meta/meta.dart';
import 'package:vector_math/vector_math_64.dart';

import 'behaviors/seek.dart';
import 'steerable.dart';

/// [Kinematics] class describes laws of motion and constraints on the movements
/// of a [Steerable].
///
/// Usually, this class will contain one or more *control variables* describing
/// the desired steering at any given moment in time, and the logic to apply
/// those steering controls to affect the motion of the owner.
///
/// The main method of this class -- `update()` -- must be invoked by the user
/// periodically, as time progresses, in order to confer motion to the [own]
/// steerable. For better results, this method should be invoked as frequently
/// as possible.
///
/// The method `handleAttach()` must be called by the user when the kinematics
/// object is attached to a concrete [Steerable].
abstract class Kinematics {
  /// Reference to the object being steered.
  ///
  /// This variable will be set within the `handleAttach()` method, and will
  /// always satisfy the constraint that `own.kinematics == this`.
  late Steerable own;

  /// This method must be invoked by the [parent] once, when this object is
  /// attached to the parent.
  @mustCallSuper
  void handleAttach(Steerable parent) => own = parent;

  /// Invoked by the user to signal that time [dt] (in seconds) has passed
  /// within the system.
  ///
  /// Here [dt] may either represent the real or simulated time, but either way
  /// the time intervals [dt] should be sufficiently small to ensure accurate
  /// simulation.
  ///
  /// Within this method the implementation must advance the state of the object
  /// and of the [own] steerable forward by [dt] seconds. The implementation
  /// may ignore any numeric effects that are `o(dt)`.
  void update(double dt);

  //#region Behavior factories

  Seek seek(Vector2 target) {
    throw UnsupportedError('Seek behavior is not available for $runtimeType');
  }

  //#endregion
}
