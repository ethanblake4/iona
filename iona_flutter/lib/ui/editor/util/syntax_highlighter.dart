import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:iona_flutter/model/syntax/syntax_definition.dart';
import 'package:iona_flutter/util/patterns.dart';

import '../editor_ui.dart';

final _freeSpacing = RegExp(r'\n|\t|\s*#.*');
final _modeCapture = RegExp(r'(?:^\s?)\(\?(x)?(i)?([\)\:])');
//final _findGroups = RegExp('\\((?:[^\\?\\)]|\\?<[\\w]>)[^\\)]*\\)');

abstract class SyntaxHighlighter {
  List<EditorUiLine> highlight(List<String> lines);
}

class ParserState {
  ListQueue<String> activeScopes;
  ListQueue<DefinitionContext> contexts;
}

class StandardSyntaxHighlighter implements SyntaxHighlighter {
  // ignore: public_member_api_docs
  StandardSyntaxHighlighter(this.language, this.def) {
    prototype = def.contexts['prototype'];
    contexts = ListQueue.of([def.contexts['main']]);
  }

  String language;
  SyntaxDefinition def;
  DefinitionContext prototype;

  //Set<String> activeContexts;
  ListQueue<DefinitionContext> contexts;
  ListQueue<String> activeScopes = ListQueue();

  @override
  List<EditorUiLine> highlight(List<String> lines) {
    var dt = DateTime.now().millisecondsSinceEpoch;
    var ct = 0;
    final outLines = <EditorUiLine>[];
    activeScopes.add(def.scope);
    // loop over each line

    var protoMatches = prototype == null
        ? []
        : prototype.match
            .expand((el) => el.match != null
                ? [el.match]
                : _flattenContexts([el.include]).expand((ctx) => (def.contexts[ctx] as DefinitionContext)
                    .match
                    .map((m) => m.match)
                    .where((e) => e != null)
                    .toList()))
            .toList();

    for (final line in lines) {
      final frags = <EditorTextFragment>[];
      var readPos = 0;
      // for all active contexts
      var iter = 0;

      do {
        final _matchForContext = <RegExpMatch, MatchPattern>{};
        RegExpMatch _zeroMatch;
        final ctx = contexts.first;
        var m = ctx.match
            .expand((el) => el.match != null
                ? [el.match]
                : _flattenContexts([el.include]).expand((ctx) => (def.contexts[ctx] as DefinitionContext)
                    .match
                    .map((m) => m.match)
                    .where((e) => e != null)
                    .toList()))
            .toList();
        if (ctx.metaIncludePrototype != false) {
          m = [...protoMatches, ...m];
        }

        final textFrag = line.substring(readPos);
        for (final _match in m) {
          RegExp pt;
          if (_match.builtPattern == null) {
            var freeSpacing = false;
            var ignoreCase = false;
            var mp = _match.pattern
                .replaceAll('/', '\\/')
                .replaceAllMapped(variableCapture, (match) => def.variables[match[1]])
                .replaceFirstMapped(_modeCapture, (match) {
              if (match[1] == 'x') freeSpacing = true;
              if (match[2] == 'i') ignoreCase = true;
              return match[3] == ':' ? '(?:' : '';
            });
            if (freeSpacing) {
              mp = mp.replaceAll(_freeSpacing, '');
            }
            pt = _match.builtPattern = RegExp(mp, caseSensitive: !ignoreCase);
          } else {
            pt = _match.builtPattern;
          }

          var dti = DateTime.now().microsecondsSinceEpoch;
          final rgx = pt.firstMatch(textFrag);
          ct += DateTime.now().microsecondsSinceEpoch - dti;
          if (rgx != null) {
            _matchForContext[rgx] = _match;
            if (rgx.start == 0) {
              _zeroMatch = rgx;
              break;
            }
          }
        }

        if (_matchForContext.isEmpty) {
          frags.add(EditorTextFragment(language, activeScopes.last, textFrag));
          break;
        }
        RegExpMatch first;
        if (_zeroMatch == null) {
          final l = _matchForContext.keys.toList();
          mergeSort(l, compare: (m1, m2) => m1.start.compareTo(m2.start));
          first = l.first;
        } else {
          first = _zeroMatch;
        }
        final _pat = _matchForContext[first];
        if (first.start != 0) {
          frags.add(EditorTextFragment(language, activeScopes.last, textFrag.substring(0, first.start)));
        }
        if (_pat.pop != null && _pat.pop) {
          contexts.remove(ctx);
          if (ctx.metaScope != null && ctx.metaScope.isNotEmpty) {
            activeScopes.removeLast();
          }
        }
        if (_pat.captures != null && _pat.captures.isNotEmpty) {
          var id = 0;
          _pat.captures.forEach((key, value) {
            final gr = first.group(key);
            if (gr == null) {
              return;
            }
            final m1 = first.group(0).indexOf(gr);
            if (m1 == -1) {
              return;
            }
            if (id <= m1) {
              frags.add(EditorTextFragment(
                  language, _pat.scope ?? activeScopes.last, textFrag.substring(id + first.start, m1 + first.start)));
            }
            frags.add(EditorTextFragment(language, value ?? _pat.scope ?? activeScopes.last, gr));
            id = m1 + gr.length;
          });
        } else {
          frags.add(EditorTextFragment(
              language, _pat.scope ?? activeScopes.last, textFrag.substring(first.start, first.end)));
        }
        readPos += first.end;
        if ((_pat.pop == null || !_pat.pop) && _pat.push != null) {
          _pat.push.lookupOrGet(def.contexts).forEach(contexts.addFirst);
          if (contexts.first.metaScope != null && contexts.first.metaScope.isNotEmpty) {
            activeScopes.addLast(contexts.first.metaScope);
          }
        } else if ((_pat.pop == null || !_pat.pop) && _pat.set != null) {
          final cs = _pat.set.lookupOrGet(def.contexts)[0].clearScopes;
          if (cs != null) {
            if (cs is int) {
              for (var i = 0; i < cs; i++) {
                activeScopes.removeLast();
              }
            }
          }
          contexts.removeFirst();
          _pat.set.lookupOrGet(def.contexts).forEach(contexts.addFirst);
          if (contexts.first.metaScope != null) {
            activeScopes.addLast(contexts.first.metaScope);
          }
        }
        iter++;
      } while (readPos < line.length - 1 && iter < (50 + line.length * 20) /* no infinite loops please! */);
      //print(frags.last);
      outLines.add(EditorUiLine(frags));
    }
    print('timestamp ${DateTime.now().millisecondsSinceEpoch - dt}, $ct');
    return outLines;
  }

  Set<String> _flattenContexts(List<String> contexts) {
    final newContexts = <String>{};
    for (final ctx in contexts) {
      if (def.contexts.containsKey(ctx)) {
        if (!newContexts.contains(ctx))
          newContexts.addAll(_flattenContexts(
              (def.contexts[ctx]).match.where((m) => m.match == null).map((e) => e.include).toList().cast<String>()));
        newContexts.add(ctx);
      }
    }
    return newContexts;
  }
}
