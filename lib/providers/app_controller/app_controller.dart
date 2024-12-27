import 'package:app_controller_client/app_controller_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intellicook_mobile/configs/config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_controller.g.dart';

const accessTokenKey = 'access_token';
late final String? _storageAccessToken;

Future<void> initAppController() async {
  const storage = FlutterSecureStorage();
  _storageAccessToken = await storage.read(key: accessTokenKey);
}

@riverpod
class AppController extends _$AppController {
  @override
  AppControllerState build() {
    return AppControllerState(
      accessToken: _storageAccessToken,
    );
  }

  Future<void> setAccessToken(String? token) async {
    const storage = FlutterSecureStorage();

    state = AppControllerState(accessToken: token);

    if (token == null) {
      await storage.delete(key: accessTokenKey);
      return;
    }

    await storage.write(key: accessTokenKey, value: token);
  }
}

class AppControllerState {
  AppControllerState({this.accessToken})
      : client = AppControllerClient(
            dio: Dio(BaseOptions(
          baseUrl: Config.APP_CONTROLLER_URL,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ))) {
    if (accessToken != null) {
      client.setBearerAuth('Bearer', accessToken!);
    }
  }

  late final AppControllerClient client;
  final String? accessToken;

  bool get isAuthenticated => accessToken != null;
}
