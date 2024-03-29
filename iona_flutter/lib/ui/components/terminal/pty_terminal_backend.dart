import 'package:pty/pty.dart';
import 'package:xterm/xterm.dart';

class PtyTerminalBackend implements TerminalBackend {
  PtyTerminalBackend(this.pty);

  final PseudoTerminal pty;

  @override
  void init() {
    pty.init();
  }

  @override
  Future<int> get exitCode => pty.exitCode;

  @override
  Stream<String> get out => pty.out;

  @override
  void resize(int width, int height, int pixelWidth, int pixelHeight) {
    pty.resize(width, height);
  }

  @override
  void write(String input) {
    pty.write(input);
  }

  @override
  void terminate() {
    pty.kill();
  }

  @override
  void ackProcessed() {
    pty.ackProcessed();
  }
}
