import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:pedantic/pedantic.dart';
import 'package:time/time.dart';

class Shell {
  /// Create a Shell interface
  Shell(this.sink, this.err, this.stream, this._kill);

  final IOSink sink;
  final Stream<String> stream;
  final Stream<String> err;
  final Function _kill;

  /// Create a default shell
  static Future<Shell> create({String path = '/bin/bash', String workingDirectory}) async {
    final processCompleter = Completer<int>();
    final process = await Process.start(path, [], workingDirectory: workingDirectory, mode: ProcessStartMode.normal);

    print('Shell started');
    unawaited(process.exitCode.then(processCompleter.complete));
    final inStream = process.stdout.transform(utf8.decoder).transform(const LineSplitter());

    return Shell(
        process.stdin, process.stderr.transform(utf8.decoder).transform(const LineSplitter()), inStream, process.kill);
  }

  static Future<Shell> createTmux({String path = 'tmux', String workingDirectory}) async {
    final bash = await create();

    bash.stream.listen(print);

    bash.sink.write('ls\n');

    await Future.delayed(50.milliseconds);
    print('Did LS');

    var sess = 'Creator452';

    final init = await Process.start(path, ['new-session', '-d', '-s', sess, '/bin/bash'],
        workingDirectory: workingDirectory, runInShell: true);
    print(await init.exitCode);

    await Future.delayed(50.milliseconds);
    print('Did NewSession');

    final init2 =
        await Process.start('rm', ['-f', '/tmp/mypipe'], workingDirectory: workingDirectory, runInShell: true);
    print(await init2.exitCode);

    final init3 = await Process.start('mkfifo', ['/tmp/mypipe'], workingDirectory: workingDirectory, runInShell: true);
    print(await init3.exitCode);

    final init4 = await Process.start('tmux', ['pipe-pane', '-t', sess, '-o', "'cat > /tmp/mypipe'"],
        workingDirectory: workingDirectory, runInShell: true);
    print(await init4.exitCode);

    await Future.delayed(50.milliseconds);
    print('Did Pipe');
    print('Tmux shell started');
    //await init.exitCode;

    print('Tmux shell initialized');
    final process = await Process.start('cat', ['/tmp/mypipe']);

    final inStream = process.stdout.transform(utf8.decoder);

    return Shell(process.stdin, process.stderr.transform(utf8.decoder), inStream, process.kill);
  }

  void close() {
    sink.close();
    _kill();
  }
}
