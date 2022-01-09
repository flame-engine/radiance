import 'package:flutter/material.dart';
import '../main.dart';

class TopMenu extends StatelessWidget {
  const TopMenu(this.app);

  final SandboxState app;

  @override
  Widget build(BuildContext context) {
    final canPause = app.engineState == EngineState.running;
    final canStop = app.engineState != EngineState.stopped;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: Row(
        children: [
          TextButton(
            onPressed: canPause ? _handlePause : _handleStart,
            child:
                Icon(canPause ? Icons.pause_rounded : Icons.play_arrow_rounded),
          ),
          TextButton(
            onPressed: canStop ? _handleStop : null,
            child: const Icon(Icons.stop_rounded),
          ),
        ],
      ),
    );
  }

  void _handleStart() => app.startEngine();
  void _handlePause() => app.pauseEngine();
  void _handleStop() => app.stopEngine();
}
