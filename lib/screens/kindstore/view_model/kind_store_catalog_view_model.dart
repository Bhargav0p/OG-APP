import 'package:apogee_2022/screens/kindstore/repository/model/kind_store_catalog_model.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';

import '../../../utils/error_messages.dart';
import '../repository/retrofit/kind_store_catalog_retrofit.dart';

class KindStoreViewModel {
  static String? error;
  static KindStoreResult kindItemsResult = KindStoreResult(items_details: [
    KindStoreItem(
        name: "Bose Headphones",
        price: 0,
        is_available: true,
        image:
            "https://s3-alpha-sig.figma.com/img/24b6/74ce/6d298dd015ff647116f7022f6f6b9d1c?Expires=1680480000&Signature=JH-DiDztBpp0Z1Ub~E0ejcenyjCAzeEZv~mDlpvZE-aPA03oL35Tnj9JXucNr29wotSsnMvH3s56l-to0N4qmdgYMhDLfnk8CP8i5VFnt~hpPNpnI1UKP52h0dz-mkbFiYrv200FuE2yxFcEC5eHJZZsXJZCvwdRY031i6J3V1Ez-J7HkQ5WnYWTAI0T4X9gfxCIFnrjQLcEzr3d7j6uFUeBZ2aqIu1t1m8c3WIiQLfvu3QNytRj5UEoToP7i0jWpyGbyrXNrwaNjpkRtc3xV~Sk8UXQEwba-qrTj2D3lp5Wv-c0sqP0dpUAuhH8PZvMb~jZmGnrS6QQ2IXsXRNDDQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4"),
    KindStoreItem(
        name: "Bose Headphones",
        price: 0,
        is_available: true,
        image:
            "https://s3-alpha-sig.figma.com/img/24b6/74ce/6d298dd015ff647116f7022f6f6b9d1c?Expires=1680480000&Signature=JH-DiDztBpp0Z1Ub~E0ejcenyjCAzeEZv~mDlpvZE-aPA03oL35Tnj9JXucNr29wotSsnMvH3s56l-to0N4qmdgYMhDLfnk8CP8i5VFnt~hpPNpnI1UKP52h0dz-mkbFiYrv200FuE2yxFcEC5eHJZZsXJZCvwdRY031i6J3V1Ez-J7HkQ5WnYWTAI0T4X9gfxCIFnrjQLcEzr3d7j6uFUeBZ2aqIu1t1m8c3WIiQLfvu3QNytRj5UEoToP7i0jWpyGbyrXNrwaNjpkRtc3xV~Sk8UXQEwba-qrTj2D3lp5Wv-c0sqP0dpUAuhH8PZvMb~jZmGnrS6QQ2IXsXRNDDQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4")
  ]);

  Future<void> getKindStoreCatalogItems() async {
    error = null;
    final dio = Dio();
    dio.interceptors.add(ChuckerDioInterceptor());
    final client = KindStoreCatalogRestClient(dio);
    // KindStoreResult? kindstorecatalog;

    kindItemsResult = await client.getKindStoreItems().catchError(
      (Object obj) {
        try {
          final res = (obj as DioError).response;
          error = res?.statusCode.toString();
          if (res?.statusCode == null || res == null) {
            error = ErrorMessages.noInternet;
          } else {
            // error = MiscEventsViewModel.matchesErrorResponse(
            //     res.statusCode, res.statusMessage);
            error = ErrorMessages.unknownError;
          }
        } catch (e) {
          error = ErrorMessages.unknownError;
        }
        return kindItemsResult;
      },
    );
    // return kindstorecatalog;
  }
}
