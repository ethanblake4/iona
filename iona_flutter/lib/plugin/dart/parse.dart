import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:iona_flutter/plugin/dart/model/lang_types.dart';

DartFunction parseBuild(MethodDeclaration build) {
  return DartFunction(build.offset,
      name: build.name.name,
      params: build.parameters.parameterElements.map(parseParameter).toList(),
      body: parseFnBody(build.body));
}

DartFunctionBody parseFnBody(FunctionBody body) {
  final realBody = body.childEntities.first;
  if (realBody is Block) return DartFunctionBody(body.offset, child: parseBlock(realBody));
  return DartFunctionBody(body.offset);
}

DartBlock parseBlock(Block block) {
  final outStatements = <DartExecutableNode>[];
  block.statements.forEach((element) {
    if (element is ExpressionStatement) {
      //print(element.expression.staticParameterElement);
      element.expression.childEntities.forEach((element) {
        //print(elemen.);
      });
      //print();
      print(element.toSource());
    } else if (element is ReturnStatement) {
      outStatements.add(parseReturn(element));
    }
  });
  return DartBlock(block.offset, statements: outStatements);
}

DartReturn parseReturn(ReturnStatement exprn) {
  //print(exprn.expression.runtimeType);
  return DartReturn(exprn.offset, expression: parseExpression(exprn.expression));
}

DartExpression parseExpression(Expression expression) {
  if (expression is InstanceCreationExpression) {
    final positionalParameters = <DartExpression>[];
    final namedParameters = <String, DartExpression>{};
    expression.argumentList.arguments.forEach((element) {
      if (element is NamedExpression) {
        namedParameters[element.name.label.name] = parseExpression(element.expression);
      } else if (element is Expression) {
        positionalParameters.add(parseExpression(element));
      }
    });
    return DartInstanceCreationExpression(expression.offset,
        constructorLocation: expression.constructorName.staticElement.location.encoding,
        positionalParameters: positionalParameters,
        namedParameters: namedParameters);
  } else if (expression is FunctionExpression) {
    return DartFunctionExpression(expression.offset);
  } else if (expression is IndexExpression) {
    return DartIndexExpression(expression.offset,
        target: parseExpression(expression.target), indexer: parseExpression(expression.index));
  } else if (expression is Identifier) {
    return parseIdentifier(expression);
  } else if (expression is Literal) {
    return parseLiteral(expression);
  } else {
    print("${expression.runtimeType} ${expression}");
  }
  ;
  return null;
}

DartLiteral parseLiteral(Literal literal) {
  if (literal is SimpleStringLiteral) {
    return DartSimpleStringLiteral(literal.offset, value: literal.value);
  } else if (literal is ListLiteral) {
    return DartListLiteral(literal.offset,
        value: literal.elements.where((element) => element is Expression).map((e) => parseExpression(e)).toList());
  } else if (literal is IntegerLiteral) {
    return DartIntegerLiteral(literal.offset, value: literal.value);
  } else if (literal is DoubleLiteral) {
    return DartDoubleLiteral(literal.offset, value: literal.value);
  }
}

DartIdentifier parseIdentifier(Identifier identifier) {
  if (identifier is SimpleIdentifier) {
    print(identifier.staticElement.location);
    return DartSimpleIdentifier(identifier.offset,
        name: identifier.name, location: identifier.staticElement.location.encoding);
  } else if (identifier is PrefixedIdentifier) {
    return DartPrefixedIdentifier(identifier.offset,
        prefix: parseIdentifier(identifier.prefix),
        location: identifier.staticElement.location.encoding,
        name: identifier.identifier.name);
  }
  return null;
}

DartParameter parseParameter(ParameterElement param) {
  return DartParameter(param.nameOffset,
      paramName: param.name,
      type: DartLnType(param.type.element.nameOffset,
          typeName: param.type.element.name, library: param.type.element.library.location.toString()));
}
