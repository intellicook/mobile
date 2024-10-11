import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intellicook_mobile/globals/app_controller_client.dart';

const accessTokenKey = 'access_token';

late String? accessToken;

Future<void> initAuth() async {
  const storage = FlutterSecureStorage();

  accessToken = await storage.read(key: accessTokenKey);

  if (accessToken != null) {
    appControllerClient.setBearerAuth('Bearer', accessToken!);
  }
}
