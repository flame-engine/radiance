import 'dart:ui';

import 'entities/entity.dart';
import 'entities/vector_visual.dart';

class Scene {
  Scene(this.name);

  /// The name of the [Scene], shown in the left menu.
  final String name;

  final List<Entity> _originalEntities = [];
  List<Entity>? _runtimeEntities;
  List<VectorVisual>? _runtimeVectors;

  void add(Entity e) {
    _originalEntities.add(e);
    _runtimeEntities = null;
  }

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
