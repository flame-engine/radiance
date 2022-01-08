import 'dart:ui';

import 'agents/agent.dart';

class Scene {
  Scene(this.name);

  final String name;
  final List<Agent> entities = [];

  void add(Agent agent) => entities.add(agent);

  void update(double dt) {
    entities.forEach((agent) => agent.update(dt));
  }

  void render(Canvas canvas) {
    entities.forEach((agent) => agent.render(canvas));
  }
}
