// Copyright (c) 2014, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:analyzer/src/generated/resolver.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/completion_dart.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/local_library_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/suggestion_builder.dart';

/// A contributor for calculating suggestions for imported top level members.
class ImportedReferenceContributor extends DartCompletionContributor {
  @override
  Future<void> computeSuggestions(DartCompletionRequest request, SuggestionBuilder builder) async {
    if (!request.includeIdentifiers) {
      return;
    }

    var imports = request.libraryElement.imports;
    if (imports == null) {
      return;
    }

    // Traverse imports including dart:core
    for (var importElement in imports) {
      var libraryElement = importElement.importedLibrary;
      if (libraryElement != null) {
        _buildSuggestions(request, builder, importElement.namespace, prefix: importElement.prefix?.name);
      }
    }
  }

  void _buildSuggestions(DartCompletionRequest request, SuggestionBuilder builder, Namespace namespace,
      {String prefix}) {
    var visitor = LibraryElementSuggestionBuilder(request, builder, prefix);
    for (var elem in namespace.definedNames.values) {
      elem.accept(visitor);
    }
  }
}
