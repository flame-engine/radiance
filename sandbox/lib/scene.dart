import 'dart:ui';

import 'entities/entity.dart';

class Scene {
  const Scene(this.name);

  final String name;
  final List<Entity> entities = [];
  final bool showVectors = true;

  void add(Entity e) => entities.add(e);

  void update(double dt) {
    entities.forEach((e) => e.update(dt));
  }

  void render(Canvas canvas) {
    entities.forEach((e) => e.render(canvas));
    if (showVectors) {
      entities.forEach((e) => e.renderVectors(canvas));
    }
  }
}
