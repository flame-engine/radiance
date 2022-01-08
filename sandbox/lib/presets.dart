import 'package:radiance/steering.dart';
import 'package:vector_math/vector_math_64.dart';

import 'entities/max_acceleration_entity.dart';
import 'entities/static_target_entity.dart';
import 'scene.dart';

final kPresets = <Scene>[
  _seek(),
];

Scene _seek() {
  final p = Scene('Seek');
  final target = StaticTargetEntity(position: Vector2(60, 30));
  final predator = MaxAccelerationEntity(
    position: Vector2(-40, -40),
    velocity: Vector2(-10, 10),
    maxSpeed: 25,
    maxAcceleration: 15,
  );
  predator.behavior = Seek(owner: predator, point: target.position);
  p.add(target);
  p.add(predator);
  return p;
}
