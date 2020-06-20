import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:iona_flutter/util/ot/atext_changeset.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sembast/sembast.dart';

/// A [Model] representing the current workspace
class Project extends Model {
  /// Returns the nearest [Project] in the widget hierarchy
  static Project of(BuildContext context) => ScopedModel.of<Project>(context);

  String _rootFolder = '';

  /// The root folder of the workspace
  String get rootFolder => _rootFolder;

  /// Open files in the project
  Map<String, ProjectFile> openFiles = {};

  /// The configuration data for the project
  FutureOr<Database> projectDb;

  set rootFolder(String newRootFolder) {
    _rootFolder = newRootFolder;
    notifyListeners();
  }

  /// Opens a file in the editor
  void openFile(String filepath) async {
    var file = File(filepath);
    var fstr = await file.readAsString();
    print(fstr);
    var doc = ADocument.fromText(fstr + '\n');
    openFiles[filepath] = ProjectFile(filepath, filepath.substring(filepath.lastIndexOf('/') + 1), file, doc, []);
    openFiles[filepath].lineLengths = doc.map((line) => (line['s'] as String).length).toList();
    notifyListeners();
    print(openFiles[filepath]);
  }

  /// Updates the file specified by [filepath] with the associated [changes],
  /// and notifies all listeners
  void updateFile(String filepath, Changeset changes) {
    openFiles[filepath].document = changes.applyTo(openFiles[filepath].document);
    openFiles[filepath].hasModified = true;
    notifyListeners();
  }

  /// Saves the file specified by [filepath]
  void saveFile(String filepath) {
    if (!openFiles[filepath].hasModified) return;
    openFiles[filepath].file.writeAsStringSync(
        openFiles[filepath].document.map((line) => (line['s'] as String)).reduce((s1, s2) => s1 + s2));
    openFiles[filepath].hasModified = false;
    notifyListeners();
  }

  /// Closes the file specified by [filepath]
  void closeFile(String filepath) {
    openFiles.remove(filepath);
    notifyListeners();
  }
}

class ProjectFile {
  /// Location of file on disk
  String fileLocation;

  /// Displayed name of file, usually [fileLocation] substring after last slash
  String fileName;

  /// File reference
  File file;

  ADocument document;
  bool hasModified = false;
  List<int> lineLengths;

  ProjectFile(this.fileLocation, this.fileName, this.file, this.document, this.lineLengths);

  @override
  String toString() {
    return 'ProjectFile{fileLocation: $fileLocation, fileName: $fileName, document: $document, ll: $lineLengths}';
  }
}
