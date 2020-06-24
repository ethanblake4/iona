import 'package:flutter/material.dart';
import 'package:iona_flutter/ui/components/terminal.dart';

/// The bottom of the screen area
class OutputArea extends StatefulWidget {
  @override
  _OutputAreaState createState() => _OutputAreaState();
}

class _OutputAreaState extends State<OutputArea> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Terminal(
          active: false,
        ),
        Row(children: [
          Expanded(
            child: Material(
              color: Colors.blueGrey[900],
              child: Row(
                children: [
                  Material(
                    color: Colors.blueGrey[300],
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.code,
                              size: 18,
                              color: Colors.blueGrey[900],
                            ),
                            Text('  Terminal', style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.outlined_flag,
                            size: 18,
                          ),
                          Text('  Dart Analysis'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ])
      ],
    );
    //return Container(color: Color(0xFF47586B));
  }
}
