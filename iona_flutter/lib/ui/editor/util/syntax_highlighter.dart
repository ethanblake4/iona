import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:yaml/yaml.dart';

import '../editor_ui.dart';

final _variableCapture = RegExp(r'(?<!\\){{(\w+)}}');
final _freeSpacing = RegExp(r'\n|\t|\s*#.*');
final _modeCapture = RegExp(r'(?:^\s?)\(\?(x)?(i)?([\)\:])');
//final _findGroups = RegExp('\\((?:[^\\?\\)]|\\?<[\\w]>)[^\\)]*\\)');

abstract class SyntaxHighlighter {
  List<EditorUiLine> highlight(List<String> lines);
}

// ignore: public_member_api_docs
/*extension GroupIndices on RegExp {

  /// Cool
  RegExpMatch exec(String str) {
    var result = [];
    var resultRegex = this.firstMatch(str);
    var lastIndex = resultRegex.end;

    if (resultRegex == null) {
      return resultRegex;
    }
    /*

    result[0] = resultRegex[0];
    result.index[0] = resultRegex.index;
    result.input = str;

    void execInternal (strPosition, regexGroupStructureChildren) {
      var currentStrPos = strPosition;
      for (var i = 0; i < regexGroupStructureChildren.length; i++) {
        var index = regexGroupStructureChildren[i][0];
        var originalIndex = regexGroupStructureChildren[i][1];
        if (originalIndex) {
          result[originalIndex] = resultRegex[index];
          if (typeof result[originalIndex] === "undefined") {
            result.index[originalIndex] = undefined;
          } else {
            result.index[originalIndex] = currentStrPos;
          }
        }
        if (regexGroupStructureChildren[i][3]) {
          execInternal(currentStrPos, regexGroupStructureChildren[i][3]);
        }
        if (typeof resultRegex[index] !== "undefined") {
          currentStrPos += resultRegex[index].length;
        }
      }
    };
    if (this.regexGroupStructure && this.regexGroupStructure[0][3]) {
      execInternal(resultRegex.index, this.regexGroupStructure[0][3]);
    }
    return result;
  }*/
}*/

class BasicSyntaxHighlighter implements SyntaxHighlighter {
  String whitespace = ' ';
  final accessmod = [];
  final keyword = [
    'final',
    'var',
    'for',
    'in',
    'this',
    'class',
    'abstract',
    'static',
    'const',
    'import',
    'void',
    'extends',
    'true',
    'false',
    'null',
    'wow=='
  ];
  final types = ['int', 'double', 'num', 'bool', 'String', 'Map', 'List', 'Set'];
  final paren = ['(', ')', '[', ']', '{', '}'];
  final operator = ['=', '<', '>', '<=', '>=', '--', '++', '+=', '-=', '/', '*'];
  final number = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

  @override
  List<EditorUiLine> highlight(List<String> lines) {
    final sb = StringBuffer();
    final outLines = <EditorUiLine>[];
    var inMultilineString = false;
    var mlStringState = 0;
    var inNumber = false;
    for (final line in lines) {
      String inStringChar;
      sb.clear();
      final frags = <EditorTextFragment>[];
      for (final rune in line.runes) {
        final ch = String.fromCharCode(rune);
        if (ch == '\n') continue;
        sb.write(ch);

        if (ch == inStringChar) {
          // Multiline? Or end?
          if (mlStringState != -1) {
            mlStringState++;
            if (mlStringState == 2) {
              inMultilineString = true;
            }
          }
          if (!inMultilineString || mlStringState == 5) {
            frags.add(EditorTextFragment(
                'dart',
                (inMultilineString ? 'string.multiline' : 'string.') + (inStringChar == '"' ? 'double' : 'single'),
                sb.toString()));
            inMultilineString = false;
            inStringChar = null;
            sb.clear();
            continue;
          }
        } else if (ch == '"' || ch == "'") {
          final cc = sb.toString();
          frags.add(EditorTextFragment('undef', 'undef', cc.substring(0, cc.length - 1)));
          sb.clear();
          sb.write(ch);
          // String start
          inStringChar = ch;
          mlStringState = 0;
          //print('string start');
        } else if (inStringChar != null && mlStringState < 2) {
          if (mlStringState < 2)
            mlStringState = -1;
          else if (mlStringState > 2) mlStringState = 2;
          continue;
        } else if (!inNumber && ch == whitespace && sb.isNotEmpty) {
          frags.add(EditorTextFragment('undef', 'undef', sb.toString()));
          sb.clear();
          continue;
        }

        final acc = sb.toString();
        if (inNumber && !number.contains(ch)) {
          if (ch == '.') continue;
          inNumber = false;
          if (acc.substring(0, acc.length - 1).endsWith('.')) {
            frags.add(EditorTextFragment('dart', 'number', acc.substring(0, acc.length - 2)));
            frags.add(EditorTextFragment('undef', 'undef', '.'));
            sb.clear();
            sb.write(ch);
          } else {
            frags.add(EditorTextFragment('dart', 'number', acc.substring(0, acc.length - 1)));
            sb.clear();
            sb.write(ch);
          }
        }

        if (accessmod.contains(acc)) {
          frags.add(EditorTextFragment('dart', 'accessmod', acc));
          sb.clear();
          continue;
        } else if (keyword.contains(acc)) {
          frags.add(EditorTextFragment('dart', 'keyword', acc));
          sb.clear();
          continue;
        } else if (paren.contains(acc)) {
          frags.add(EditorTextFragment('dart', 'paren', acc));
          sb.clear();
          continue;
        } else if (operator.contains(acc)) {
          frags.add(EditorTextFragment('dart', 'operator', acc));
          sb.clear();
          continue;
        } else if (number.contains(acc)) {
          inNumber = true;
          continue;
        } else if (types.contains(acc)) {
          frags.add(EditorTextFragment('dart', 'type', acc));
          sb.clear();
          continue;
        }

        if (paren.contains(ch)) {
          final cc = sb.toString();
          frags.add(EditorTextFragment('undef', 'undef', cc.substring(0, cc.length - 1)));
          frags.add(EditorTextFragment('dart', 'paren', ch));
          sb.clear();
          continue;
        } else if (operator.contains(ch)) {
          final cc = sb.toString();
          frags.add(EditorTextFragment('undef', 'undef', cc.substring(0, cc.length - 1)));
          frags.add(EditorTextFragment('dart', 'operator', ch));
          sb.clear();
          continue;
        }
      }

      frags.add(EditorTextFragment('undef', 'undef', sb.toString()));
      outLines.add(EditorUiLine(frags));
    }

    print(outLines);

    return outLines;
  }
}

class ParserState {
  ListQueue<String> activeScopes;
  ListQueue<_DefinitionContext> contexts;
}

class StandardSyntaxHighlighter implements SyntaxHighlighter {
  // ignore: public_member_api_docs
  StandardSyntaxHighlighter(this.language, this.def) {
    prototype = def.contexts['prototype'];
    contexts = ListQueue.of([def.contexts['main']]);
  }

  String language;
  SyntaxDefinition def;
  _DefinitionContext prototype;

  //Set<String> activeContexts;
  ListQueue<_DefinitionContext> contexts;
  ListQueue<String> activeScopes = ListQueue();

  @override
  List<EditorUiLine> highlight(List<String> lines) {
    var dt = DateTime.now().millisecondsSinceEpoch;
    var ct = 0;
    final outLines = <EditorUiLine>[];
    activeScopes.add(def.scope);
    // loop over each line
    for (final line in lines) {
      final frags = <EditorTextFragment>[];
      var readPos = 0;
      // for all active contexts
      var iter = 0;

      do {
        final _matchForContext = <RegExpMatch, _MatchPattern>{};
        RegExpMatch _zeroMatch;
        final ctx = contexts.first;
        final m = ctx.match.expand((el) => el.match != null
            ? [el.match]
            : _flattenContexts([el.include]).expand((ctx) =>
                (def.contexts[ctx] as _DefinitionContext).match.map((m) => m.match).where((e) => e != null).toList()));

        final textFrag = line.substring(readPos);
        for (final _match in m) {
          RegExp pt;
          if (_match.builtPattern == null) {
            var freeSpacing = false;
            var ignoreCase = false;
            var mp = _match.pattern
                .replaceAll('/', '\\/')
                .replaceAllMapped(_variableCapture, (match) => def.variables[match[1]])
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
          newContexts.addAll(_flattenContexts((def.contexts[ctx] as _DefinitionContext)
              .match
              .where((m) => m.match == null)
              .map((e) => e.include)
              .toList()));
        newContexts.add(ctx);
      }
    }
    return newContexts;
  }
}

class Two<A, B> {
  final A first;
  final B second;

  Two(this.first, this.second);
}

/// Defines a syntax to be used for highlighting and basic syntax error detection
class SyntaxDefinition {
  /// Create a [SyntaxDefinition]
  SyntaxDefinition(this.name, this.scope, this.contexts, this.fileExtensions, this.variables);

  /// Create a [SyntaxDefinition] from a YAML-format map
  ///
  /// Example:
  /// ```dart
  /// final yamlString = readFile(file);
  /// final def = SyntaxDefinition.parseYaml(loadYaml(yamlString));
  /// ```
  factory SyntaxDefinition.parseYaml(Map yaml) {
    final outMap = <String, String>{};
    (yaml['variables'] as Map)?.forEach((key, value) {
      outMap[key] = (value as String).replaceAllMapped(
          _variableCapture, (match) => outMap.containsKey(match[1]) ? outMap[match[1]] : yaml['variables'][match[1]]);
    });
    return SyntaxDefinition(
        yaml['name'],
        yaml['scope'],
        (yaml['contexts']).map((s, d) => MapEntry(s, _DefinitionContext.parseYaml(d))),
        (yaml['file_extensions']).cast<String>(),
        yaml['variables']);
  }

  /// Name of the language, e.g. JSON
  String name;

  /// A list of the file extensions that this syntax should be automatically applied to
  List<String> fileExtensions;

  /// Top-level scope
  String scope;

  /// A map of [_DefinitionContext]s with associated names
  Map contexts;

  /// A map of string variable substitutions
  Map variables;
}

class _MatchOrInclude {
  _MatchPattern match;
  String include;

  _MatchOrInclude(this.match, this.include);

  @override
  String toString() {
    return '=${match ?? include}';
  }
}

class _DefinitionContext {
  String metaScope;
  String metaContentScope;
  bool metaIncludePrototype;
  dynamic clearScopes;
  List<_MatchOrInclude> match;

  _DefinitionContext(this.metaScope, this.metaContentScope, this.metaIncludePrototype, this.clearScopes, this.match);

  @override
  String toString() {
    return 'DCtx{match: $match, mScope: $metaScope, mCScope: $metaContentScope, mICP: $metaIncludePrototype, clearSc: $clearScopes}';
  }

  factory _DefinitionContext.parseYaml(List yaml) {
    final ctx = _DefinitionContext('', '', false, false, []);
    for (final itm in yaml) {
      if (itm is Map) {
        switch (itm.keys.first) {
          case 'match':
            ctx.match.add(_MatchOrInclude(_MatchPattern.parseYaml(itm), null));
            break;
          case 'meta_scope':
            ctx.metaScope = itm.values.first;
            break;
          case 'meta_content_scope':
            ctx.metaContentScope = itm.values.first;
            break;
          case 'meta_include_prototype':
            ctx.metaIncludePrototype = itm.values.first;
            break;
          case 'clear_scopes':
            ctx.clearScopes = itm.values.first;
            break;
          case 'include':
            ctx.match.add(_MatchOrInclude(null, itm.values.first));
            break;
        }
      }
    }
    return ctx;
  }

  factory _DefinitionContext.composite(Iterable<_DefinitionContext> contexts) {
    final ctx = _DefinitionContext('', '', false, false, []);
    for (final c in contexts) {
      ctx
        ..metaScope = c.metaScope ?? ctx.metaScope
        ..metaContentScope = c.metaContentScope ?? ctx.metaContentScope
        ..metaIncludePrototype = c.metaIncludePrototype ?? ctx.metaIncludePrototype
        ..clearScopes = c.clearScopes ?? ctx.clearScopes
        ..match.addAll(c.match);
    }
    return ctx;
  }
}

class _DefinitionContextOrRef {
  _DefinitionContext context;
  String ref;
  List refList;

  _DefinitionContextOrRef(this.context, this.ref, this.refList);

  List<_DefinitionContext> lookupOrGet(Map namedContexts) {
    if (ref != null) {
      return [namedContexts[ref]];
    } else if (refList != null) {
      return refList.map((ref) => namedContexts[ref]).toList().cast<_DefinitionContext>();
    } else {
      return [context];
    }
  }
}

class _MatchPattern {
  String pattern;
  RegExp builtPattern;
  String scope;
  Map captures;
  _DefinitionContextOrRef push;
  bool pop;
  _DefinitionContextOrRef set;

  @override
  String toString() {
    return 'MP{ $pattern }';
  }

  _MatchPattern(this.pattern, {this.scope = '', this.captures, this.push, this.pop = false, this.set});

  factory _MatchPattern.parseYaml(Map yaml) {
    final pat = _MatchPattern('');
    yaml.forEach((k, v) {
      switch (k) {
        case 'match':
          pat.pattern = v;
          break;
        case 'scope':
          pat.scope = v;
          break;
        case 'captures':
          pat.captures = (v as Map);
          break;
        case 'push':
          var vi = v;
          if (v is YamlNode) vi = v.value;
          if (vi is String) {
            pat.push = _DefinitionContextOrRef(null, vi, null);
          } else if (vi is List) {
            if (vi.first is String) {
              pat.push = _DefinitionContextOrRef(null, null, vi);
            } else
              pat.push = _DefinitionContextOrRef(_DefinitionContext.parseYaml(vi), null, null);
          }
          break;
        case 'pop':
          final vi = v is YamlNode ? v.value : v;
          pat.pop = vi == true || vi == 'true';
          break;
        case 'set':
          var vi = v;
          if (v is YamlNode) vi = v.value;
          if (vi is String) {
            pat.set = _DefinitionContextOrRef(null, vi, null);
          } else if (vi is List) {
            if (vi.first is String) {
              pat.set = _DefinitionContextOrRef(null, null, vi);
            } else
              pat.set = _DefinitionContextOrRef(_DefinitionContext.parseYaml(vi), null, null);
          }
          break;
      }
    });
    return pat;
  }
}
