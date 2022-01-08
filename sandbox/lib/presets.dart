import 'package:vector_math/vector_math_64.dart';
import 'agents/static_target.dart';
import 'scene.dart';

final kPresets = <Scene>[
  _seek(),
];

Scene _seek() {
  final p = Scene('Seek');
  final target = StaticTarget(Vector2(60, 30));
  p.add(target);
  return p;
}
