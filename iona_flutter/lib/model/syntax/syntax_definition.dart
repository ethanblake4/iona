import 'package:iona_flutter/util/patterns.dart';
import 'package:yaml/yaml.dart';

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
          variableCapture, (match) => outMap.containsKey(match[1]) ? outMap[match[1]] : yaml['variables'][match[1]]);
    });
    return SyntaxDefinition(
        yaml['name'],
        yaml['scope'],
        (yaml['contexts']).map((s, d) => MapEntry(s, DefinitionContext.parseYaml(d))),
        (yaml['file_extensions']).cast<String>(),
        outMap);
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
  MatchPattern match;
  String include;

  _MatchOrInclude(this.match, this.include);

  @override
  String toString() {
    return '=${match ?? include}';
  }
}

class DefinitionContext {
  String metaScope;
  String metaContentScope;
  bool metaIncludePrototype;
  dynamic clearScopes;
  List<_MatchOrInclude> match;

  DefinitionContext(this.metaScope, this.metaContentScope, this.metaIncludePrototype, this.clearScopes, this.match);

  @override
  String toString() {
    return 'DCtx{match: $match, mScope: $metaScope, mCScope: $metaContentScope, mICP: $metaIncludePrototype, clearSc: $clearScopes}';
  }

  factory DefinitionContext.parseYaml(List yaml) {
    final ctx = DefinitionContext('', '', false, false, []);
    for (final itm in yaml) {
      if (itm is Map) {
        switch (itm.keys.first) {
          case 'match':
            ctx.match.add(_MatchOrInclude(MatchPattern.parseYaml(itm), null));
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

  factory DefinitionContext.composite(Iterable<DefinitionContext> contexts) {
    final ctx = DefinitionContext('', '', false, false, []);
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
  DefinitionContext context;
  String ref;
  List refList;

  _DefinitionContextOrRef(this.context, this.ref, this.refList);

  List<DefinitionContext> lookupOrGet(Map namedContexts) {
    if (ref != null) {
      return [namedContexts[ref]];
    } else if (refList != null) {
      return refList.map((ref) => namedContexts[ref]).toList().cast<DefinitionContext>();
    } else {
      return [context];
    }
  }
}

class MatchPattern {
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

  MatchPattern(this.pattern, {this.scope = '', this.captures, this.push, this.pop = false, this.set});

  factory MatchPattern.parseYaml(Map yaml) {
    final pat = MatchPattern('');
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
              pat.push = _DefinitionContextOrRef(DefinitionContext.parseYaml(vi), null, null);
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
              pat.set = _DefinitionContextOrRef(DefinitionContext.parseYaml(vi), null, null);
          }
          break;
      }
    });
    return pat;
  }
}
