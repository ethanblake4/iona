import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}


class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Demo Home Page"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 75),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("It's cool that we've died!"),
              Text("2.4597899"),
              Text("How to sond as loudly?")
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff651972),
        child: Icon(Icons.add)
      ),
    );
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
      Text(" HEY2 FN"),
      Column(children: [Text("", maxLines: 1), Text("Kewl "), Text("Ya")])
    ]);
  }
}
