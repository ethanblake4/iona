/*import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iona_flutter/plugin/dart/flutter/ui_editor/editor_reporting_widget.dart';
import 'package:iona_flutter/plugin/dart/flutter/ui_editor/passthrough_stack.dart';
import 'package:iona_flutter/plugin/dart/model/analysis_message.dart';
import 'package:iona_flutter/plugin/dart/ui/ast_widget.dart';

class EditorWidgetCanvas extends StatelessWidget {
  const EditorWidgetCanvas(
      {Key key, @required this.fileInfo, @required this.selectedWidget, this.hoverWidget, this.innerSelection})
      : super(key: key);

  final FlutterFileInfo fileInfo;
  final String selectedWidget;
  final EditorReportingWidget hoverWidget;
  final EditorReportingWidget innerSelection;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
          child: FittedBox(
        fit: BoxFit.contain,
        child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 360, height: 640),
            child: Builder(builder: (context2) {
              List<Widget> hover = [];
              RenderBox ro;

              if (hoverWidget?.currentRenderObject != null && hoverWidget.currentRenderObject is RenderBox) {
                try {
                  final RenderBox hoverBox = hoverWidget.currentRenderObject;
                  ro = context2.findRenderObject();

                  final offset = hoverBox.localToGlobal(Offset(0, 0), ancestor: ro);
                  final hoverSize = hoverBox.size;
                  bool isContainer(String type) {
                    return type == 'Container' || type == 'Padding' || type == 'Center';
                  }

                  //inal tx = offset.dx -
                  hover
                    ..add(
                      Positioned(
                        left: offset.dx,
                        top: offset.dy,
                        child: Container(
                          constraints: BoxConstraints.tight(hoverSize),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.tealAccent[700], width: 1),
                              color: Colors.grey.withAlpha(16)),
                        ),
                      ),
                    )
                    ..add(
                      Positioned(
                        left: offset.dx,
                        top: max(5, offset.dy - (isContainer(hoverWidget.path.type) ? 0 : 15)),
                        child: Container(
                          child: Text(
                            hoverWidget.path.type,
                            maxLines: 1,
                            style: TextStyle(color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      hoverWidget?.node == innerSelection?.node ? Colors.red : Colors.tealAccent[700],
                                  width: 1),
                              color: hoverWidget?.node == innerSelection?.node ? Colors.red : Colors.tealAccent[700]),
                        ),
                      ),
                    );
                } catch (e) {
                  WidgetsBinding.instance.scheduleFrame();
                }
              }

              if (innerSelection?.currentRenderObject != null && innerSelection.currentRenderObject is RenderBox) {
                try {
                  final RenderBox selectedBox = innerSelection.currentRenderObject;
                  ro ??= context2.findRenderObject();

                  final offset = selectedBox.localToGlobal(Offset(0, 0), ancestor: ro);
                  final selectedSize = selectedBox.size;
                  hover.add(
                    Positioned(
                      left: offset.dx,
                      top: offset.dy,
                      child: Container(
                        constraints: BoxConstraints.tight(selectedSize),
                        decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 1)),
                      ),
                    ),
                  );
                } catch (e) {
                  WidgetsBinding.instance.scheduleFrame();
                }
              }

              return PassthroughStack(
                fit: StackFit.passthrough,
                children: [
                  Card(
                    child: AstWidget(fileInfo, selectedWidget),
                    elevation: 2.0,
                    shape: Border.all(color: Colors.blueGrey[600]),
                  ),
                  if (hover != null) ...hover,
                ],
              );
            })),
      )),
    );
  }
}
*/
