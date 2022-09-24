import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:iona_flutter/ui/components/terminal/pty_terminal_backend.dart';
import 'package:iona_flutter/ui/design/inline_window.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:pty/pty.dart';
import 'package:xterm/flutter.dart' as xt;
import 'package:xterm/terminal/terminal_isolate.dart' as xt;
import 'package:xterm/xterm.dart' as xt;

/// A terminal using ffi_terminal
class Terminal extends StatefulWidget {
  const Terminal(
      {this.active = true,
      this.height = 230,
      this.constraintsCallback,
      this.onCollapse});

  final bool active;
  final double height;
  final ModifyConstraintsCallback constraintsCallback;
  final VoidCallback onCollapse;

  @override
  _TerminalState createState() => _TerminalState();
}

class _TerminalState extends State<Terminal> {
  PseudoTerminal pty;
  xt.TerminalUiInteraction xterm;
  double fmax = 0;
  bool hsf = false;
  int width = 110;
  int height = 15;
  Array2D chars;
  final scrollController = ScrollController();
  bool rd = false;

  static bool firstInit = true;

  @override
  void initState() {
    if (widget.active) init();

    super.initState();
  }

  void init() {
    pty = PseudoTerminal.start(getShell(), ['-l'],
        environment: {'TERM': 'xterm-256color'},
        blocking: false,
        ackProcessed: !foundation.kDebugMode);

    final backend = PtyTerminalBackend(pty);

    xterm = (!foundation.kDebugMode)
        ? xt.TerminalIsolate(
            //onTitleChange: tab.setTitle,
            backend: backend,
            platform: getPlatform(true),
            minRefreshDelay: Duration(milliseconds: 50),
            maxLines: 10000,
          )
        : xt.Terminal(
            //onTitleChange: tab.setTitle,
            backend: backend,
            platform: getPlatform(true),
            maxLines: 10000,
          );

    pty.resize(width, height);
  }

  String getShell() {
    if (Platform.isWindows) {
      return r'C:\windows\system32\cmd.exe';
      //return r'C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe';
    }

    return Platform.environment['SHELL'] ?? 'sh';
  }

  xt.PlatformBehavior getPlatform([bool forLocalShell = false]) {
    if (Platform.isWindows) {
      return xt.PlatformBehaviors.windows;
    }

    if (forLocalShell && Platform.isMacOS) {
      return xt.PlatformBehaviors.mac;
    }

    return xt.PlatformBehaviors.unix;
  }

  @override
  void dispose() {
    super.dispose();
    pty.kill();
  }

  @override
  Widget build(BuildContext context) {
    return InlineWindow(
        requestFocus: !firstInit,
        constraints: BoxConstraints.tightFor(height: widget.height),
        constraintsCallback: widget.constraintsCallback,
        onCollapse: widget.onCollapse,
        resizeTop: true,
        header: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Text('Terminal'),
        ),
        child: Material(
          color: Colors.blueGrey[900],
          child: xt.TerminalView(
            terminal: xterm,
            scrollController: this.scrollController,
            opacity: 0.2,
            style: xt.TerminalStyle(fontFamily: [
              'Cascadia',
              'Hack',
              'OfficeCodePro',
              ...xt.TerminalStyle.defaultFontFamily
            ]),
          ),
        ));
  }
}
