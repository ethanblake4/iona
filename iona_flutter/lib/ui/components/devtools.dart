import 'dart:async';

import 'package:devtools_app/devtools.dart' as dt;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iona_flutter/ui/design/inline_window.dart';

class Devtools extends StatefulWidget {
  const Devtools(
      {this.height = 230, this.constraintsCallback, this.onCollapse});

  final double height;
  final ModifyConstraintsCallback constraintsCallback;
  final VoidCallback onCollapse;

  @override
  _DevtoolsState createState() => _DevtoolsState();
}

class _DevtoolsState extends State<Devtools> with TickerProviderStateMixin {
  static dt.PreferencesController prefs;
  static int screenIndex = 0;

  List<dt.DevToolsScreen> screens;
  TabController tc;
  StreamSubscription connectedSubscription;

  @override
  void initState() {
    super.initState();

    screens = dt.defaultScreens;
    tc = TabController(
        vsync: this, length: screens.length, initialIndex: screenIndex);
    tc.addListener(_changeTab);

    connectedSubscription = dt.frameworkController.onConnected.listen((event) {
      _setState();
    });
  }

  void _setState() async {
    print('connected state change');
    await Future.delayed(const Duration(milliseconds: 400));
    print('cs state examine');
    setState(() {
      this.screens = dt.defaultScreens
          .where((sc) => dt.shouldShowScreen(sc.screen))
          .toList();
      tc.removeListener(_changeTab);
      tc.dispose();
      tc = TabController(
          vsync: this, length: this.screens.length, initialIndex: screenIndex);
    });
  }

  void _changeTab() {
    print(screens[tc.index].screen.screenId);
    screenIndex = tc.index;
    if (dt.serviceManager.connectedState.value.connected) {
      print('dtt');
      dt.frameworkController
          .notifyShowPageId(screens[tc.index].screen.screenId);
    } else {
      screenIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (prefs == null) {
      final dtIdeTheme = dt.IdeTheme(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          embed: true);

      dt.initDevTools(dtIdeTheme).then((_p) {
        setState(() {
          prefs = _p;
        });
      });
    }

    return InlineWindow(
        requestFocus: false,
        constraints: BoxConstraints.tightFor(height: widget.height),
        constraintsCallback: widget.constraintsCallback,
        onCollapse: widget.onCollapse,
        resizeTop: true,
        headerVerticalPadding: 0,
        header: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('Dart DevTools'),
            ),
            Padding(padding: const EdgeInsets.only(left: 8)),
            if (dt.serviceManager.connectedState.value.connected)
              Expanded(
                child: TabBar(
                  labelPadding: EdgeInsets.symmetric(horizontal: 8),
                  padding: EdgeInsets.zero,
                  tabs: [
                    for (final screen in screens)
                      Tab(
                        height: 28,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Icon(
                                screen.screen.icon,
                                size: 14,
                              ),
                            ),
                            Text(
                              screen.screen.title,
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ],
                        ),
                      ),
                  ],
                  controller: tc,
                  isScrollable: true,
                ),
              )
          ],
          mainAxisSize: MainAxisSize.max,
        ),
        child:
            prefs == null ? Container() : dt.DevToolsApp(screens, dt.provider));
  }

  @override
  void dispose() {
    tc.removeListener(_changeTab);
    tc.dispose();
    connectedSubscription.cancel();
    super.dispose();
  }
}
