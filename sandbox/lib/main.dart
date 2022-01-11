import 'package:flutter/material.dart';

import 'presets.dart';
import 'scene.dart';
import 'widgets/left_menu.dart';
import 'widgets/scene_widget.dart';
import 'widgets/top_menu.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Radiance sandbox',
      theme: ThemeData(
        brightness: Brightness.dark,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(30, 30)),
            padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) =>
                  states.contains(MaterialState.disabled)
                      ? const Color(0xFF5F5F5F)
                      : const Color(0xFFBBBBBB),
            ),
            overlayColor: MaterialStateProperty.all(const Color(0xFF555555)),
          ),
        ),
      ),
      home: const _MyApp(),
    ),
  );
}

class _MyApp extends StatefulWidget {
  const _MyApp({Key? key}) : super(key: key);

  @override
  State createState() => SandboxState();
}

/// Main state for the entire app.
class SandboxState extends State<_MyApp> {
  SandboxState()
      : assert(Presets.numGroups > 0, 'Presets must not be empty'),
        assert(Presets.numItemsInGroup(0) > 0, 'Preset group cannot be empty') {
    groupOpen[0] = true;
    currentGroup = 0;
    currentPreset = 0;
    currentScene = Presets.makeScene(0, 0);
  }

  /// Boolean indicators for which of the preset groups in the LHS menu are
  /// currently expanded, and which are folded.
  List<bool> groupOpen = List.filled(Presets.numGroups, false);

  /// Index of the group in the left-side menu where the current preset belongs
  /// to. If there is no preset selected, this will be `null`.
  int? currentGroup;

  /// Index of the selected preset within the [currentGroup]. If there is no
  /// preset selected, this will be `null`.
  int? currentPreset;

  late Scene currentScene;

  EngineState engineState = EngineState.running;

  void selectPreset(int? index) {
    currentPreset = index;
    if (index != null) {
      currentScene = Presets.group(currentGroup!).items[index]();
    }
  }

  void startEngine() {
    setState(() => engineState = EngineState.running);
  }

  void pauseEngine() {
    setState(() => engineState = EngineState.paused);
  }

  void stopEngine() {
    setState(() {
      engineState = EngineState.stopped;
      selectPreset(currentPreset);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    return Row(
      children: [
        // Left-side panel containing the list of presets
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          constraints: const BoxConstraints.expand(width: 260),
          child: LeftMenu(this),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              Container(color: bgColor),
              Column(
                children: [
                  // Top menu
                  Container(
                    constraints: const BoxConstraints.expand(height: 40),
                    color: Theme.of(context).cardColor,
                    child: TopMenu(this),
                  ),
                  // Main canvas area
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SceneWidget(this),
                    ),
                  ),
                ],
              ),
              // Shadow effect for the left-side panel
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0x80000000),
                      Color(0x40000000),
                      Color(0x1A000000),
                      Color(0x00000000),
                    ],
                    stops: [0, 0.4, 0.6, 1.0],
                  ),
                ),
                constraints: const BoxConstraints.expand(width: 8),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum EngineState {
  running,
  paused,
  stopped,
}
