import 'package:flutter/material.dart';
import 'package:iona_flutter/ui/components/terminal.dart';

/// The bottom of the screen area
class OutputArea extends StatefulWidget {
  @override
  _OutputAreaState createState() => _OutputAreaState();
}

class _OutputAreaState extends State<OutputArea> {
  @override
  Widget build(BuildContext context) {
    return Terminal(
      active: false,
    );
    //return Container(color: Color(0xFF47586B));
  }
}
