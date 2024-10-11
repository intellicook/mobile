import 'package:app_controller_client/app_controller_client.dart';
import 'package:intellicook_mobile/configs/config.dart';

final appControllerClient = AppControllerClient(
  basePathOverride: Config.APP_CONTROLLER_URL,
);
