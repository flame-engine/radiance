import 'package:flutter/material.dart';

import 'presets.dart';
import 'scene.dart';
import 'widgets/left_menu.dart';
import 'widgets/scene_widget.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Radiance sandbox',
      theme: ThemeData.dark(),
      home: const _MyApp(),
    ),
  );
}

class _MyApp extends StatefulWidget {
  const _MyApp({Key? key}) : super(key: key);

  @override
  State createState() => SandboxState();
}

class SandboxState extends State<_MyApp> {
  int currentPreset = 0;
  Scene get currentScene => kPresets[currentPreset];

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
