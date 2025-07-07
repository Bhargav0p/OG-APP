import 'package:apogee_2022/provider/firebase_init_bool.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../provider/user_details_viewmodel.dart';
import '../../utils/error_messages.dart';
import 'repo/model/get_orders_model.dart';
import 'repo/model/make_otp_seen_model.dart';
import 'repo/model/order_card_model.dart';
import 'repo/retrofit/get_orders_retrofit.dart';
import 'repo/retrofit/make_otp_seen_retrofit.dart';

class OrderScreenViewModel {
  static String? error;
  static List<OrderCardModel> pastOrders = [];
  static List<OrderCardModel> ongoingOrders = [];
  static bool subscibedToUser = false;

  Future<void> makeOtpSeen(int orderid) async {
    MakeOtpSeenData makeOtpSeenData = MakeOtpSeenData(order_id: orderid);
    final dio = Dio();
    dio.interceptors.add(ChuckerDioInterceptor());
    final client = OtpRestClient(dio);
    String Bearer = "Bearer ${UserDetailsViewModel.userDetails.Bearer}";
    try {
      await client.makeOtpSeen(Bearer, makeOtpSeenData);
    } catch (e) {
      if (e.runtimeType == DioError) {
        DioError error = e as DioError;
        var response = error.response;
        if (response == null) {
          throw Exception("No Connection");
        } else {
          throw Exception(response.data["display_message"]);
        }
      }

      throw Exception("Server error");
    }

    return;
  }

  Future<List<GetOrderResult>> getOrders() async {
    final dio = Dio();
    String auth = "Bearer ${UserDetailsViewModel.userDetails.Bearer}";
    final client = OrdersRestClient(dio);
    dio.interceptors.add(ChuckerDioInterceptor());
    List<GetOrderResult> listOfOrderResult = [];
    try {
      listOfOrderResult = await client.getOrders(auth);
    } catch (e) {
      if (e.runtimeType == DioError) {
        DioError error = e as DioError;
        var response = error.response;
        if (response == null) {
          throw Exception("No Connection");
        } else {
          throw Exception(
              response.data["display_message"] ?? ErrorMessages.unknownError);
        }
      }
      throw Exception("Server error");
    }

    return listOfOrderResult;
  }

  static Future<void> updateOrderFirebase() async {
    if (!subscibedToUser) {
      if (isFirebaseInitialised.value) {
        try {
          await FirebaseMessaging.instance
              .subscribeToTopic(UserDetailsViewModel.userDetails.userID!);
        } catch (e) {
          throw Exception("Server error");
        }
      }
      subscibedToUser = true;
    }
    List<GetOrderResult> orderResultList =
        await OrderScreenViewModel().getOrders();
    List<List<OrderCardModel>> orderCardListList = OrderScreenViewModel()
        .filterPastAndOngoing(
            OrderScreenViewModel().changeDataModel(orderResultList));
    pastOrders = orderCardListList[0];
    ongoingOrders = orderCardListList[1];
  }

  List<OrderCardModel> changeDataModel(List<GetOrderResult> listOfOrderResult) {
    List<OrderCardModel> orderCardModelList = [];

    for (GetOrderResult i in listOfOrderResult) {
      int id = i.id!;
      String timeStamp = i.timestamp!;
      List<Order> list = i.orders!;
      for (Order j in list) {
        int otp = j.otp!;
        String foodStallName = j.vendor!.name!;
        double subTotal = j.price!;
        int status = j.status!;
        int? orderId = j.order_id;
        String? order_image_url = j.order_image_url;
        print('order id: $orderId');

        List<MenuItemInOrdersScreen> tempItemList = [];
        List<Items> itemList = j.items!;
        for (Items k in itemList) {
          String name = k.name!;
          int price = k.unit_price!;
          int quantity = k.quantity!;
          tempItemList.add(MenuItemInOrdersScreen(
              quantity: quantity, price: price, name: name));
        }
        orderCardModelList.add(OrderCardModel(
            foodStallName: foodStallName,
            id: id,
            itemCount: itemList.length,
            menuItemInOrdersScreenList: tempItemList,
            orderId: orderId,
            otp: otp,
            status2: ValueNotifier(status),
            status: status,
            subtotal: subTotal,
            timeStamp: timeStamp,
            order_image_url: order_image_url));
      }
    }
    return orderCardModelList;
  }

  List<List<OrderCardModel>> filterPastAndOngoing(
      List<OrderCardModel> orderCardModelList) {
    List<OrderCardModel> pastOrderList = [];
    List<OrderCardModel> ongoingOrderList = [];
    for (OrderCardModel i in orderCardModelList) {
      if (i.status2.value <= 2) {
        ongoingOrderList.add(i);
      } else {
        pastOrderList.add(i);
      }
    }
    return [pastOrderList, ongoingOrderList];
  }
}
