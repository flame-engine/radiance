import 'package:radiance/steering.dart';
import 'package:vector_math/vector_math_64.dart';

import 'entities/heavy_entity.dart';
import 'entities/light_entity.dart';
import 'entities/static_entity.dart';
import 'scene.dart';

class Presets {
  static final _presets = [
    _PresetGroup('Seek', [
      _seek1(),
      _seek2(),
    ]),
  ];

  static int get numGroups => _presets.length;
  static _PresetGroup group(int i) => _presets[i];
  static int numItemsInGroup(int i) => _presets[i].items.length;

  static Scene makeScene(int groupIndex, int sceneIndex) {
    return _presets[groupIndex].items[sceneIndex];
  }

  static String sceneName(int groupIndex, int sceneIndex) {
    return _presets[groupIndex].items[sceneIndex].name;
  }

  //# region Individual presets

  static Scene _seek1() {
    final p = Scene('Light');
    final target = StaticEntity(position: Vector2(60, 30));
    final predator = LightEntity(
      position: Vector2(-40, -40),
      velocity: Vector2(-10, 10),
      maxSpeed: 25,
    );
    predator.behavior = Seek(owner: predator, point: target.position);
    p.add(target);
    p.add(predator);
    return p;
  }

  static Scene _seek2() {
    final p = Scene('Heavy');
    final target = StaticEntity(position: Vector2(60, 30));
    final predator = HeavyEntity(
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

  //# endregion
}

class _PresetGroup {
  const _PresetGroup(this.name, this.items);

  final String name;
  final List<Scene> items;
}

class _PresetItem {
  const _PresetItem(this.name, this.maker);

  final String name;
  final Scene Function() maker;

  Scene make() => maker();
}
