import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.lightGreen[100],
        child: Padding(padding: EdgeInsets.all(14.0), child: Row(children: [Icon(Icons.add), 
       Icon(Icons.functions, color: Colors.blueGrey[500])])));
  }
}

class Test2Widget extends StatefulWidget {
  @override
  _Test2WidgetState createState() => _Test2WidgetState();
}

class _Test2WidgetState extends State<Test2Widget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(" HEY3 FN"),
      Column(children: [Text(""), Text("Cool2 "), Text("Ya")])
    ]);
  }
}
