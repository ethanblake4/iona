import 'package:pubspec/pubspec.dart';

class DartProject {
  DartProject(this.pubSpec);
  PubSpec pubSpec;

  bool get isFlutterProject => pubSpec.dependencies.containsKey('flutter');
}
