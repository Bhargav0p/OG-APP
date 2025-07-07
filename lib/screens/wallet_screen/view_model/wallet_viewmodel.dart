import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '/provider/user_details_viewmodel.dart';
import '/screens/wallet_screen/Repo/model/add_swd_model.dart';
import '/screens/wallet_screen/Repo/model/balance_model.dart';
import '/screens/wallet_screen/Repo/model/qr_to_id.dart';
import '/screens/wallet_screen/Repo/model/refresh_qr.dart';
import '/screens/wallet_screen/Repo/model/send_money_model.dart';
import '/screens/wallet_screen/Repo/retrofit/balance_retrofit.dart';
import '/screens/wallet_screen/Repo/retrofit/qr_to_id_retrofit.dart';
import '/screens/wallet_screen/Repo/retrofit/refresh_qr_retrofit.dart';
import '/screens/wallet_screen/Repo/retrofit/send_money_retrofit.dart';
import '/screens/wallet_screen/Repo/retrofit/swd_retrofit.dart';
import '/utils/error_messages.dart';
import '../Repo/model/Transactions_model.dart';
import '../Repo/retrofit/transactions_retrofit.dart';

class WalletViewModel {
  static int balance = 0;
  static bool isKindActive = false;
  static int? kindpoints = 0;
  String? Bearer = UserDetailsViewModel.userDetails.Bearer;
  static String? error;

  Future<String> refreshQrCode(int id) async {
    final dio = Dio();
    dio.interceptors.add(ChuckerDioInterceptor());
    String auth = "Bearer $Bearer";
    String qrCode;
    final refreshQrRestClient = RefreshQrRestClient(dio);
    try {
      RefreshQrResponseModel refreshQrResponseModel =
          await refreshQrRestClient.refreshQr(auth, RefreshQrPostModel(id: id));
      qrCode = refreshQrResponseModel.qr_code;
      return qrCode;
    } catch (e) {
      if (e.runtimeType == DioError) {
        if ((e as DioError).response == null) {
          throw Exception(ErrorMessages.noInternet);
        }
        throw Exception(
            e.response!.data["display_message"] ?? ErrorMessages.unknownError);
      } else {
        throw Exception(e);
      }
    }
  }

  Future<int> getId(String qrCode) async {
    final dio = Dio();
    dio.interceptors.add(ChuckerDioInterceptor());
    String auth = "Bearer ${UserDetailsViewModel.userDetails.Bearer}";
    int id = -1;
    final qrToIdModelRestClient = QrToIdModelRestClient(dio);
    try {
      QrToIdModel qrToIdModel = await qrToIdModelRestClient.getId(auth, qrCode);
      id = qrToIdModel.id!;
    } on DioError catch (e) {
      throw Exception(e.response?.statusCode);
    }
    return id;
  }

  Future<TransactionsModel> getTransactions() async {
    final dio = Dio();
    final client = TransactionsRestClient(dio);
    dio.interceptors.add(ChuckerDioInterceptor());

    String? Bearer = UserDetailsViewModel.userDetails.Bearer;
    String auth = "Bearer $Bearer";
    try {
      TransactionsModel transactions = await client.getTransactions(auth);

      for (TransactionsData transactionData in transactions.txns) {
        if (transactionData.txn_type == "Add from SWD") {
          transactionData.txn_type = "Added money from";
          transactionData.name = "SWD";
          transactionData.isPositive = true;
        } else if (transactionData.txn_type == "Add by cash") {
          transactionData.txn_type = "Added money from";
          transactionData.name = "Cash";
          transactionData.isPositive = true;
        } else if (transactionData.txn_type == "Add from payment gateway") {
          transactionData.txn_type = "Added money from ";
          transactionData.name = "PAYTM";
          transactionData.isPositive = true;
        } else if (transactionData.txn_type == "Transfer") {
          if (transactionData.name == "Money Sent" ||
              transactionData.name == "Money sent") {
            transactionData.isPositive = false;
          } else {
            transactionData.isPositive = true;
          }
        } else if (transactionData.txn_type == "prof_show") {
          transactionData.isPositive = false;
          transactionData.txn_type = "Bought ticket for ";
        } else if (transactionData.txn_type == "merch") {
          transactionData.isPositive = false;
          transactionData.txn_type = "Bought merch ";
        } else {
          transactionData.isPositive = false;
        }
      }
      return transactions;
    } catch (e) {
      WalletViewModel.error ??= ErrorMessages.unknownError;
      return TransactionsModel(txns: []);
    }
  }

  Future<void> getBalance() async {
    error = null;
    final dio = Dio();
    dio.interceptors.add(ChuckerDioInterceptor());
    String auth = "Bearer $Bearer";
    final balanceRestClient = BalanceRestClient(dio);
    BalanceModel response = BalanceModel(
        data: BalanceData(
            cash: 0,
            pg: 0,
            swd: 0,
            transfers: 0,
            kind_active: false,
            kind_points: 0));
    response = await balanceRestClient.getBalance(auth).then((it) {
      return it;
    }).catchError((Object obj) {
      try {
        final res = (obj as DioError).response;
        error = res?.statusCode.toString();
        if (res?.statusCode == null || res == null) {
          error = ErrorMessages.noInternet;
        } else {
          error = ErrorMessages.unknownError;
          if (res.statusCode.toString() == "401") {
            Hive.box("firstRun").clear();
            error = ErrorMessages.unauthError;
          }
          //TODO: make a handler
        }
      } catch (e) {
        error = ErrorMessages.unknownError;
      }
      return response;
    });
    balance = (response.data?.swd ?? 0) +
        (response.data?.cash ?? 0) +
        (response.data?.transfers ?? 0) +
        (response.data?.pg ?? 0);
    isKindActive = response.data?.kind_active ?? false;
    kindpoints = response.data?.kind_points ?? 0;
// catch (e) {
//   if (e.runtimeType == DioError) {
//     DioError errore = e as DioError;
//     var response = errore.response;
//     if (response == null) {
//       error=ErrorMessages.noInternet;
//       throw Exception("No Connection");
//
//     } else {
//       error=ErrorMessages.unknownError;
//       throw Exception(response.statusCode);
//     }
//   }
// }
  }

  Future<void> addMoney(int amount) async {
    AddSwdPostRequestModel addSwdPostRequestModel =
        AddSwdPostRequestModel(amount: amount);
    final dio = Dio();
    dio.interceptors.add(ChuckerDioInterceptor());
    String auth = "Bearer $Bearer";
    final addMoneyRestClient = AddMoneyRestClient(dio);
    try {
      await addMoneyRestClient.addFromSwd(auth, addSwdPostRequestModel);
    } catch (e) {
      if (e.runtimeType == DioError) {
        DioError error = e as DioError;
        var response = error.response;
        if (response == null) {
          throw Exception("No Connection");
        } else {
          throw Exception(response.statusCode);
        }
      }

      throw Exception("Server error");
    }
  }

  Future<void> sendMoney(int id, int amount) async {
    SendMoneyThroughIdModel sendMoneyThroughIdModel =
        SendMoneyThroughIdModel(id: id, amount: amount);
    final dio = Dio();
    String auth = "Bearer $Bearer";
    final sendMoneyRestClient = SendMoneyRestClient(dio);
    try {
      await sendMoneyRestClient.postMoneyTransfer(
          sendMoneyThroughIdModel, auth);
    } catch (e) {
      if (e.runtimeType == DioError) {
        DioError error = e as DioError;
        var response = error.response;
        if (response == null) {
          throw Exception("No Connection");
        } else {
          throw Exception(response.statusCode);
        }
      }
    }
    return;
  }
}
