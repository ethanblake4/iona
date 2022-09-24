import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:iona_flutter/model/event/global_events.dart';
import 'package:iona_flutter/plugin/dart/dart_analysis.dart';
import 'package:iona_flutter/util/ot/atext_changeset.dart';
import 'package:iona_flutter/util/strings/detect_indents.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sembast/sembast.dart';

/// A [Model] representing the current workspace
class Project extends Model {
  /// Returns the nearest [Project] in the widget hierarchy
  static Project of(BuildContext context) => ScopedModel.of<Project>(context);

  String _rootFolder = '';
  String _activeFile = '';

  /// Open files in the project
  Map<String, ProjectFile> openFiles = {};

  /// The configuration data for the project
  FutureOr<Database> projectDb;

  /// The root folder of the workspace
  String get rootFolder => _rootFolder;

  /// The currently active file, eg the one whose editor window was most recently focused
  String get activeFile => _activeFile;

  ProjectFile get activeProjectFile => openFiles[_activeFile];

  set rootFolder(String newRootFolder) {
    _rootFolder = newRootFolder;
    notifyListeners();
  }

  set activeFile(String newActiveFile) {
    _activeFile = newActiveFile;
    notifyListeners();
  }

  /// Opens a file in the editor
  void openFile(String filepath) async {
    var file = File(filepath);
    var fstr = await file.readAsString();
    final isCrlf = fstr.contains('\r\n');
    if (isCrlf) {
      fstr = fstr.replaceAll('\r\n', '\n');
    }
    var doc = ADocument.fromText(fstr + '\n');
    final indents = detectIndents(fstr);
    openFiles[filepath] = ProjectFile(filepath, filepath.substring(filepath.lastIndexOf('/') + 1), file, doc, [],
        lineTerminatorFormat: isCrlf ? LineTerminatorFormat.CRLF : LineTerminatorFormat.LF, indentData: indents);

    openFiles[filepath].lineLengths = doc.map((line) => (line['s'] as String).length).toList();
    notifyListeners();
    eventBus.fire(MakeEditorFileActive(filepath));
  }

  /// Updates the file specified by [filepath] with the associated [changes],
  /// and notifies all listeners
  void updateFile(String filepath, Changeset changes) {
    openFiles[filepath].document = changes.applyTo(openFiles[filepath].document);
    openFiles[filepath].hasModified = true;
    DartAnalyzer().editFile(filepath, adocToString(openFiles[filepath].document)).then((value) {});
    notifyListeners();
  }

  /// Saves the file specified by [filepath]
  void saveFile(String filepath) {
    print("save file");
    if (!openFiles[filepath].hasModified) return;
    var filestring = adocToString(openFiles[filepath].document);
    if (openFiles[filepath].lineTerminatorFormat == LineTerminatorFormat.CRLF) {
      filestring = filestring.replaceAll('\n', '\r\n');
    }
    openFiles[filepath].file.writeAsStringSync(filestring);
    openFiles[filepath].hasModified = false;
    notifyListeners();
    eventBus.fire(SaveFile(filepath, true));
  }

  /// Closes the file specified by [filepath]
  void closeFile(String filepath) {
    openFiles.remove(filepath);
    notifyListeners();
  }
}

String adocToString(ADocument doc) {
  final str = doc.map((line) => (line['s'] as String)).reduce((s1, s2) => s1 + s2);
  return str.substring(0, str.length - 1);
}

class ProjectFile {
  ProjectFile(this.fileLocation, this.fileName, this.file, this.document, this.lineLengths,
      {this.lineTerminatorFormat = LineTerminatorFormat.LF, this.indentData});

  /// Location of file on disk
  String fileLocation;

  /// Displayed name of file, usually [fileLocation] substring after last slash
  String fileName;

  /// File reference
  File file;

  ADocument document;
  bool hasModified = false;
  List<int> lineLengths;
  LineTerminatorFormat lineTerminatorFormat;
  IndentData indentData;

  @override
  String toString() {
    return 'ProjectFile{fileLocation: $fileLocation, fileName: $fileName, document: $document, ll: $lineLengths}';
  }
}

enum LineTerminatorFormat { LF, CRLF }
