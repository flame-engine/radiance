import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Radiance sandbox',
      theme: ThemeData.dark(),
      home: const _MyScaffold(),
    ),
  );
}

class _MyScaffold extends StatefulWidget {
  const _MyScaffold({Key? key}) : super(key: key);

  @override
  State createState() => SandboxState();
}

class SandboxState extends State<_MyScaffold> {
  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          constraints: const BoxConstraints.expand(width: 260),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              Container(color: bgColor),
              Column(
                children: [
                  Container(
                    constraints: const BoxConstraints.expand(height: 30),
                    color: Theme.of(context).cardColor,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
              Row(
                children: [
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
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
