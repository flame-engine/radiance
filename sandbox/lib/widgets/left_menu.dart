import 'package:flutter/material.dart';
import '../main.dart';
import '../presets.dart';

class LeftMenu extends StatelessWidget {
  const LeftMenu(this.app);

  final SandboxState app;

  @override
  Widget build(BuildContext context) {
    final group = Presets.group(app.currentGroup!);
    final n = group.items.length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'Presets',
              textAlign: TextAlign.left,
              style: Theme.of(context).primaryTextTheme.headline6,
              // TextStyle(color: Theme.of(context).primaryColor,
              //   fontSize: Theme.of(context).primaryTextTheme.
              // ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Color(0xFFBBBBBB),
                fontSize: 14,
              ),
              child: Column(
                children: List.generate(n, (i) => _ListItem(i, app)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListItem extends StatefulWidget {
  const _ListItem(this.index, this.app);

  final int index;
  final SandboxState app;

  @override
  State createState() => _ListItemState();
}

class _ListItemState extends State<_ListItem> {
  static const styleWhenCurrent = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isCurrent = widget.app.currentPreset == widget.index;
    return MouseRegion(
      onEnter: _mouseEnter,
      onExit: _mouseLeave,
      cursor: SystemMouseCursors.click,
      child: SizedBox(
        width: double.infinity,
        child: Container(
          color: Color.fromRGBO(255, 255, 255, _hover ? 0.1 : 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: Text(
              widget.app.currentScene.name,
              style: isCurrent ? styleWhenCurrent : null,
            ),
          ),
        ),
      ),
    );
  }

  void _mouseEnter(PointerEvent details) {
    setState(() => _hover = true);
  }

  void _mouseLeave(PointerEvent details) {
    setState(() => _hover = false);
  }
}
