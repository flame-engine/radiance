import 'package:flutter/material.dart';
import '../main.dart';
import '../presets.dart';

class LeftMenu extends StatelessWidget {
  const LeftMenu(this.app);

  final SandboxState app;

  @override
  Widget build(BuildContext context) {
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
                children: List.generate(
                    Presets.numGroups, (i) => _ListHeader(app, i),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListHeader extends StatelessWidget {
  const _ListHeader(this.app, this.groupIndex);

  final SandboxState app;
  final int groupIndex;

  @override
  Widget build(BuildContext context) {
    final title = Presets.group(groupIndex).name;
    final isOpen = app.groupOpen[groupIndex];
    Widget result = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        children: [
          Icon(isOpen ? Icons.arrow_right : Icons.arrow_drop_down),
          Text(title),
        ],
      ),
    );
    if (isOpen) {
      final n = Presets.numItemsInGroup(groupIndex);
      final groupIsCurrent = app.currentGroup == groupIndex;
      result = Column(
        children: [
          result,
          for (var i = 0; i < n; i++)
            _ListItem(groupIndex, i, groupIsCurrent && i == app.currentPreset)
        ],
      );
    }
    return result;
  }
}

class _ListItem extends StatefulWidget {
  const _ListItem(this.groupIndex, this.itemIndex, this.isCurrent);

  final int groupIndex;
  final int itemIndex;
  final bool isCurrent;

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
              Presets.sceneName(widget.groupIndex, widget.itemIndex),
              style: widget.isCurrent ? styleWhenCurrent : null,
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
