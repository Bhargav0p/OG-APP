import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '/provider/user_details_viewmodel.dart';
import '../../../utils/error_messages.dart';
import '../repository/model/data.dart';
import '../repository/retrofit/getBearer.dart';

final logger = Logger();

class LoginViewModel {
  final storage = const FlutterSecureStorage();

  Future<AuthResult> authenticate(
      String? username, String? password, bool? isBitsian) async {
    final dio = Dio();
    final client = LoginRestClient(dio);
    LoginPostRequest postRequest =
        LoginPostRequest.fromJson({"username": username, "password": password});
    AuthResult authResult = await client.getAuth(postRequest).then((it) async {
      await storage.write(key: 'Bearer', value: it.JWT);
      await storage.write(key: 'username', value: it.name);
      await storage.write(key: 'userid', value: it.user_id.toString());
      await storage.write(key: 'referralcode', value: it.referral_code);
      await storage.write(key: 'isBitsian', value: isBitsian.toString());
      await storage.write(key: 'qrcode', value: it.qr_code);
      await storage.write(key: 'doesUserExist', value: 'true');
      Hive.box('firstRun').put(1, true);
      UserDetailsViewModel.userDetails.username = it.name;
      UserDetailsViewModel.userDetails.Bearer = it.JWT;
      UserDetailsViewModel.userDetails.userID = it.user_id.toString();
      UserDetailsViewModel.userDetails.referralCode = it.referral_code;
      UserDetailsViewModel.userDetails.isBitsian = isBitsian;
      UserDetailsViewModel.userDetails.doesUserExist = true;
      UserDetailsViewModel.userDetails.qrCode = it.qr_code;
      return it;
    }).catchError((Object obj) {
      print(obj.toString());
      // non-200 error goes here.
      final res = (obj as DioError).response;
      logger.i(res);
      return AuthResult(
          error: loginErrorResponse(res?.statusCode, res?.statusMessage));
    });
    return authResult;
  }

  String loginErrorResponse(int? responseCode, String? statusMessage) {
    if (responseCode == null || statusMessage == null) {
      print('goes to no internet');
      return ErrorMessages.noInternet;
    }
    switch (responseCode) {
      case 400:
        return ErrorMessages.emptyUsernamePassword;
      case 401:
        return ErrorMessages.invalidUser;
      case 403:
        return ErrorMessages.disabledUser;
      case 404:
        return ErrorMessages.emptyProfile;
      default:
        return ErrorMessages.unknownError +
            ((statusMessage == null) ? '' : statusMessage);
    }
  }
}
