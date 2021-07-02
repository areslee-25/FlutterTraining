import 'application.dart';
import 'environment.dart';

Future<void> main() async {
  Environment.flavor = Flavor.stg;
  await Application.run();
}
