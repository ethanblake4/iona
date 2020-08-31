import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PassthroughStack extends Stack {
  PassthroughStack({List<Widget> children, StackFit fit}) : super(children: children, fit: fit);

  @override
  PassthroughRenderStack createRenderObject(BuildContext context) {
    return PassthroughRenderStack(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.of(context),
      fit: fit,
    );
  }
}

class PassthroughRenderStack extends RenderStack {
  PassthroughRenderStack({alignment, textDirection, fit})
      : super(alignment: alignment, textDirection: textDirection, fit: fit);

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    var stackHit = false;

    final children = getChildrenAsList();

    for (var child in children) {
      final StackParentData childParentData = child.parentData;

      final childHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );

      if (childHit) stackHit = true;
    }

    return stackHit;
  }
}
