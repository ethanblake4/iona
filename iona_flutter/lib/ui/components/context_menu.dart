import 'package:flutter/material.dart';
import 'package:iona_flutter/ui/design/desktop_dropdown.dart';

Future<T> showContextMenu<T>(BuildContext context, Rect source, List<DesktopDropdownMenuItem<T>> items,
    {int elevation = 4, double itemHeight = 22, TextStyle style, Color dropdownColor}) {
  final List<DMenuItem<T>> menuItems = List<DMenuItem<T>>(items.length);
  DropdownRoute<T> _dropdownRoute;
  for (int index = 0; index < items.length; index += 1) {
    menuItems[index] = DMenuItem<T>(
      item: items[index],
      onLayout: (Size size) {
        // If [_dropdownRoute] is null and onLayout is called, this means
        // that performLayout was called on a _DropdownRoute that has not
        // left the widget tree but is already on its way out.
        //
        // Since onLayout is used primarily to collect the desired heights
        // of each menu item before laying them out, not having the _DropdownRoute
        // collect each item's height to lay out is fine since the route is
        // already on its way out.
        if (_dropdownRoute == null) return;

        _dropdownRoute.itemHeights[index] = size.height;
      },
    );
  }
  _dropdownRoute = DropdownRoute(
    items: menuItems,
    buttonRect: source,
    padding: EdgeInsets.all(8),
    selectedIndex: 0,
    elevation: elevation,
    theme: Theme.of(context),
    style: style ?? Theme.of(context).textTheme.subtitle1,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    itemHeight: itemHeight,
    dropdownColor: dropdownColor,
  );
  return Navigator.push(context, _dropdownRoute).then<T>((DropdownRouteResult<T> newValue) {
    _dropdownRoute?.dismiss();
    return newValue?.result;
  });
}

DesktopDropdownMenuItem<T> makeSimpleContextItem<T>(T value, String name, {Widget icon, VoidCallback onTap}) {
  return DesktopDropdownMenuItem<T>(
      value: value,
      child: Row(
        children: [
          Padding(
              padding: icon == null ? const EdgeInsets.only(right: 22.0) : const EdgeInsets.only(right: 4.0),
              child: icon),
          Text(name),
        ],
      ),
      onTap: onTap);
}
