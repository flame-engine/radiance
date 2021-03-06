import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../main.dart';

/// This widget is responsible for drawing the main canvas and implementing
/// a simple "game loop" to continuously update it.
class SceneWidget extends StatefulWidget {
  const SceneWidget(this.app);

  final SandboxState app;

  @override
  State createState() => _SceneWidgetState();
}

class _SceneWidgetState extends State<SceneWidget> {
  Ticker? ticker;
  Duration currentTime = Duration.zero;
  EngineState currentState = EngineState.running;
  double dt = 0.0;

  void _handleTick(Duration time) {
    setState(() {
      dt = (time - currentTime).inMicroseconds / 1000000;
      currentTime = time;
      widget.app.currentScene.update(dt);
    });
  }

  void _handleStateChange() {
    if (widget.app.engineState == EngineState.running) {
      ticker?.start();
    } else {
      ticker?.stop();
      currentTime = Duration.zero;
    }
    currentState = widget.app.engineState;
  }

  @override
  void initState() {
    super.initState();
    ticker = Ticker(_handleTick)..start();
  }

  @override
  void dispose() {
    super.dispose();
    ticker?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentState != widget.app.engineState) {
      _handleStateChange();
    }
    return Align(
      child: AspectRatio(
        aspectRatio: 100 / 80,
        child: CustomPaint(
          painter: _ScenePainter(widget.app),
        ),
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter(this.app);

  SandboxState app;

  static final gridPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0x18FFFFFF);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(size.width / 200 - 0.01);
    canvas.scale(1, -1);
    for (var i = -80.0; i <= 80.0; i += 20.0) {
      canvas.drawLine(Offset(-100, i), Offset(100, i), gridPaint);
    }
    for (var i = -100.0; i <= 100.0; i += 20.0) {
      canvas.drawLine(Offset(i, -80), Offset(i, 80), gridPaint);
    }
    app.currentScene.render(canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter old) => true;
}
