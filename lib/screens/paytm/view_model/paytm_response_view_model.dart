import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import '../repository/model/paytmResponse.dart';
import '../repository/model/paytmResponseMessage.dart';
import '../repository/retrofit/postPaytm.dart';

final logger = Logger();

FlutterSecureStorage storage = FlutterSecureStorage();

class PaytmResponseViewModel {
  Future<PaytmResponseMessage> postPaytmResponse(
      PaytmResponse paytmResponse) async {
    print('shkj');
    final dio = Dio(); // Provide a dio instance
    final client = PostPaytmRestClient(dio);
    dio.interceptors.add(ChuckerDioInterceptor());
    String? Bearer = await storage.read(key: 'Bearer');
    PaytmResponseMessage result =
        await client.postPaytm("Bearer ${Bearer}", paytmResponse).then((it) {
      return it;
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          logger.e("Got error : ${res?.statusCode} -> ${res?.statusMessage}");

          break;
        default:
          break;
      }
    });

    return result;
  }
}
