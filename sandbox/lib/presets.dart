import 'package:vector_math/vector_math_64.dart';

import 'agents.dart';

final kPresets = <Preset>[
  _seek(),
];

class Preset {
  Preset(this.name);

  final String name;
  final List<Agent> entities = [];

  void add(Agent agent) => entities.add(agent);
}

Preset _seek() {
  final p = Preset('Seek');
  final target = StaticTarget(Vector2(60, 30));
  p.add(target);
  return p;
}
