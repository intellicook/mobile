import 'package:envied/envied.dart';

part 'config.g.dart';

@Envied(path: '.env')
abstract class Config {
  @EnviedField()
  static const String APP_CONTROLLER_URL = _Config.APP_CONTROLLER_URL;
}
