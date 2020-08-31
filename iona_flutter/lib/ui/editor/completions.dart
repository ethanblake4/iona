import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iona_flutter/plugin/dart/completion/protocol/protocol_generated.dart';
import 'package:iona_flutter/ui/editor/editor.dart';
import 'package:iona_flutter/ui/editor/theme/editor_theme.dart';

typedef CompletionItemSelected = void Function(CompletionItem item);

class Completions extends StatelessWidget {
  const Completions({Key key, @required this.completions, this.suggestionStartDx, this.callback}) : super(key: key);

  final List<CompletionItem> completions;
  final double suggestionStartDx;
  final CompletionItemSelected callback;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: EdgeInsets.only(left: max(0, suggestionStartDx - 8), top: max(0, Editor.cursorScreenPosition.dy)),
        child: Container(
            constraints: BoxConstraints.loose(Size(300, 150)),
            child: Listener(
              onPointerDown: (evt) {
                print('sugest tap');
              },
              behavior: HitTestBehavior.opaque,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (event) {
                  Editor.cursorCapturedBySuggestions = true;
                },
                onExit: (event) {
                  Editor.cursorCapturedBySuggestions = false;
                },
                opaque: true,
                child: Material(
                  elevation: 4,
                  color: Colors.blueGrey[800],
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) {
                      return InkWell(
                        onTap: () {
                          callback(completions[i]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          child: Text(
                            completions[i].label,
                            style: testTheme.baseStyle.copyWith(color: Colors.white70, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 1,
                          ),
                        ),
                      );
                    },
                    itemCount: completions?.length ?? 0,
                  ),
                ),
              ),
            )),
      ),
    ]);
  }
}
