import 'package:untitled/environment.dart';

import 'application.dart';

Future<void> main() async {
  Environment.flavor = Flavor.dev;
  await Application.run();
}
