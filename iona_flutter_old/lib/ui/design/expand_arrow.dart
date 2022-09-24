import 'package:flutter/material.dart';

/// A widget representing a rotating expand/collapse button. The icon rotates
/// 180 deg when pressed, then reverts the animation on a second press.
/// The underlying icon is [Icons.expand_more].
///
/// See [IconButton] for a more general implementation of a pressable button
/// with an icon.
class ExpandArrow extends StatefulWidget {
  /// Creates an [ExpandIcon] with the given padding, and a callback that is
  /// triggered when the icon is pressed.
  const ExpandArrow({Key key, this.isExpanded = false, this.size = 24.0, this.color})
      : assert(isExpanded != null),
        assert(size != null),
        super(key: key);

  /// Whether the icon is in an expanded state.
  ///
  /// Rebuilding the widget with a different [isExpanded] value will trigger
  /// the animation, but will not trigger the [onPressed] callback.
  final bool isExpanded;

  /// The size of the icon.
  ///
  /// This property must not be null. It defaults to 24.0.
  final double size;

  final Color color;

  @override
  _ExpandArrowState createState() => new _ExpandArrowState();
}

class _ExpandArrowState extends State<ExpandArrow> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(duration: kThemeAnimationDuration, vsync: this);
    _iconTurns = new Tween<double>(begin: 0.0, end: 0.5)
        .animate(new CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ExpandArrow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return new RotationTransition(
        turns: _iconTurns,
        child: Icon(
          Icons.expand_more,
          color: widget.color,
          size: widget.size,
        ));
  }
}
