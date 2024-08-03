import 'package:app_controller_client/app_controller_client.dart';
import 'package:intellicook_mobile/configs/config.dart';

AppControllerClient get appControllerClient => AppControllerClient(
      basePathOverride: Config.APP_CONTROLLER_URL,
    );
