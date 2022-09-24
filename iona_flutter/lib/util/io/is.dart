import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:platform/platform.dart';

///
/// Returns true if the given [path] points to a file.
///
/// ```dart
/// isFile("~/fred.jpg");
/// ```
bool isFile(String path) => _Is().isFile(path);

/// Returns true if the given [path] is a directory.
/// ```dart
/// isDirectory("/tmp");
///
/// ```
bool isDirectory(String path) => _Is().isDirectory(path);

/// Returns true if the given [path] is a symlink
///
/// // ```dart
/// isLink("~/fred.jpg");
/// ```
bool isLink(String path) => _Is().isLink(path);

/// Returns true if the given path exists.
/// It may be a file, directory or link.
///
/// If [followLinks] is true (the default) then [exists]
/// will return true if the resolved path exists.
///
/// If [followLinks] is false then [exists] will return
/// true if path exist, whether its a link or not.
///
/// ```dart
/// if (exists("/fred.txt"))
/// ```
///
/// Throws [ArgumentError] if [path] is null or an empty string.
///
/// See [isLink]
///     [isDirectory]
///     [isFile]
bool exists(String path, {bool followLinks = true}) => _Is().exists(path, followLinks: followLinks);

class _Is {
  bool isFile(String path) {
    final fromType = FileSystemEntity.typeSync(path);
    return fromType == FileSystemEntityType.file;
  }

  /// true if the given path is a directory.
  bool isDirectory(String path) {
    final fromType = FileSystemEntity.typeSync(path);
    return fromType == FileSystemEntityType.directory;
  }

  bool isLink(String path) {
    final fromType = FileSystemEntity.typeSync(path);
    return fromType == FileSystemEntityType.link;
  }

  /// checks if the given [path] exists.
  ///
  /// Throws [ArgumentError] if [path] is an empty string.
  bool exists(String path, {@required bool followLinks}) {
    if (path.isEmpty) {
      throw ArgumentError('path must not be empty.');
    }

    final _exists = FileSystemEntity.typeSync(path, followLinks: followLinks) != FileSystemEntityType.notFound;

    return _exists;
  }

  DateTime lastModified(String path) => File(path).lastModifiedSync();

  void setLastModifed(String path, DateTime lastModified) {
    File(path).setLastModifiedSync(lastModified);
  }

  /// Returns true if the passed [pathToDirectory] is an
  /// empty directory.
  /// For large directories this operation can be expensive.
  bool isEmpty(String pathToDirectory) {
    return Directory(pathToDirectory).listSync(followLinks: false).isEmpty;
  }

  /// checks if the passed [path] (a file or directory) is
  /// writable by the user that owns this process
  bool isWritable(String path) {
    return _checkPermission(path, writeBitMask);
  }

  /// checks if the passed [path] (a file or directory) is
  /// readable by the user that owns this process
  bool isReadable(String path) {
    return _checkPermission(path, readBitMask);
  }

  /// checks if the passed [path] (a file or directory) is
  /// executable by the user that owns this process
  bool isExecutable(String path) {
    return LocalPlatform().isWindows || _checkPermission(path, executeBitMask);
  }

  static const readBitMask = 0x4;
  static const writeBitMask = 0x2;
  static const executeBitMask = 0x1;

  /// Checks if the user permission to act on the [path] (a file or directory)
  /// for the given permission bit mask. (read, write or execute)
  bool _checkPermission(String path, int permissionBitMask) {
    throw UnimplementedError();
    /*if (LocalPlatform().isWindows) {
      throw UnsupportedError(
          'isMemberOfGroup is not Not currently supported on windows');
    }

    final user = Shell.current.loggedInUser;

    int permissions;
    String group;
    String owner;
    bool otherWritable;
    bool groupWritable;
    bool ownerWritable;

    // try {
    //   final _stat = posix.stat(path);
    //   group = posix.getgrgid(_stat.gid).name;
    //   owner = posix.getUserNameByUID(_stat.uid);
    //   final mode = _stat.mode;
    //   otherWritable = mode.isOtherWritable;
    //   groupWritable = mode.isGroupWritable;
    //   ownerWritable = mode.isOwnerWritable;
    // } on posix.PosixException catch (_) {
    //e.g 755 tomcat bsutton
    final stat = 'stat -L -c "%a %G %U" "$path"'.firstLine!;
    final parts = stat.split(' ');
    permissions = int.parse(parts[0], radix: 8);
    group = parts[1];
    owner = parts[2];
    //  if (( ($PERM & 0002) != 0 )); then
    otherWritable = (permissions & permissionBitMask) != 0;
    groupWritable = (permissions & (permissionBitMask << 3)) != 0;
    ownerWritable = (permissions & (permissionBitMask << 6)) != 0;
    // }

    var access = false;
    if (otherWritable) {
      // Everyone has write access
      access = true;
    } else if (groupWritable) {
      // Some groups have write access
      if (isMemberOfGroup(group)) {
        access = true;
      }
    } else if (ownerWritable) {
      if (user == owner) {
        access = true;
      }
    }
    return access;*/
  }

  /// Returns true if the owner of this process
  /// is a member of [group].
  bool isMemberOfGroup(String group) {
    throw UnimplementedError();
    /*erbose(() => 'isMemberOfGroup: $group');

    if (Settings().isWindows) {
      throw UnsupportedError(
          'isMemberOfGroup is not Not currently supported on windows');
    }
    // get the list of groups this user belongs to.
    final groups = 'groups'.firstLine!.split(' ');

    // is the user a member of the file's group.
    return groups.contains(group);*/
  }
}
