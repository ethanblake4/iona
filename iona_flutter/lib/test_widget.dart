import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Text("hi guys Yeah!");
  }
}

class Test2Widget extends StatefulWidget {
  @override
  _Test2WidgetState createState() => _Test2WidgetState();
}

class _Test2WidgetState extends State<Test2Widget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text("HEY3 FNNN  "), 
      Row(children: [Text("Cool2 "), Text("Ya")])]);
  }
}

class Test3Widget extends StatefulWidget {
  @override
  _Test3WidgetState createState() => _Test3WidgetState();
}

class _Test3WidgetState extends State<Test3Widget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text("HEY4 FNNN  "), 
      Row(children: [Text("Cool2 "), Text("Ya")])]);
  }
}
