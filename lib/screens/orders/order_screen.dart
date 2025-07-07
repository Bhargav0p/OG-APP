import 'package:apogee_2022/provider/firebase_init_bool.dart';
import 'package:apogee_2022/resources/resources.dart';
import 'package:apogee_2022/screens/orders/orders_controller.dart';
import 'package:apogee_2022/widgets/apogee_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors.dart';
import '../../utils/scroll_remover.dart';
import '../../widgets/loader.dart';
import 'order_screen_viewmodel.dart';
import 'order_widget.dart';
import 'repo/model/order_card_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<OrderCardModel> orderCardList = [];
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  @override
  void initState() {
    isFirebaseInitialised.addListener(() async {
      await getOrderResult();
      setState(() {});
    });

    OrdersScreenControllers.isOngoing.addListener(() {
      updateorderCardList();
      setState(() {});
    });
    if (isFirebaseInitialised.value) {
      getOrderResult();
    }
    super.initState();
  }

  updateorderCardList() {
    print('update called');
    if (OrdersScreenControllers.isOngoing.value) {
      orderCardList = OrderScreenViewModel.ongoingOrders;
    } else {
      orderCardList = OrderScreenViewModel.pastOrders;
    }
  }

  Future<void> getOrderResult() async {
    isLoading.value = true;
    try {
      await OrderScreenViewModel.updateOrderFirebase();
      updateorderCardList();
    } catch (e) {
      var snackBar =
          CustomSnackBar().apogeeSnackBar(e.toString().substring(11));
      if (!mounted) {}
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(19, 21, 27, 1),
        body: ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (context, bool value, child) {
              if (isLoading.value) {
                return RefreshIndicator(
                    color: ApogeeColors.purpleButtonColor,
                    onRefresh: getOrderResult,
                    child: ScrollConfiguration(
                      behavior: CustomScrollBehavior(),
                      child: SingleChildScrollView(
                          child: Container(
                              height: 1.sh,
                              width: 1.sw,
                              child: const Loader())),
                    ));
              } else {
                return Column(
                  children: [
                    SizedBox(height: 96.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 32.w),
                        Text(
                          'Status',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: const Color.fromRGBO(218, 218, 218, 1),
                              fontFamily: 'sui-generis',
                              fontSize: 36.sp,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w400,
                              height: 1),
                        ),
                        SizedBox(width: 99.w),
                        GestureDetector(
                            onTap: () {
                              OrdersScreenControllers.isOngoing.value = true;
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: OrdersScreenControllers.isOngoing.value
                                      ? 3.h
                                      : 0.h),
                              child: Container(
                                padding: EdgeInsets.only(
                                  bottom:
                                      6.h, // Space between underline and text
                                ),
                                decoration: OrdersScreenControllers
                                        .isOngoing.value
                                    ? const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Color(0xFF7A56D1),
                                                width:
                                                    3.0 // Underline thickness
                                                )))
                                    : const BoxDecoration(),
                                child: Text(
                                  'Ongoing',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.inter(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      fontSize: 20.sp,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.w400,
                                      height: 1),
                                ),
                              ),
                            )),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: () {
                            OrdersScreenControllers.isOngoing.value = false;
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: OrdersScreenControllers.isOngoing.value
                                    ? 0.h
                                    : 3.h),
                            child: Container(
                              padding: EdgeInsets.only(
                                bottom: 6.h, // Space between underline and text
                              ),
                              decoration:
                                  OrdersScreenControllers.isOngoing.value
                                      ? const BoxDecoration()
                                      : const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                          color: Color(0xFF7A56D1),
                                          width: 3.0, // Underline thickness
                                        ))),
                              child: Text(
                                'Past',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.inter(
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: 20.sp,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.w400,
                                    height: 1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 29.h),
                    orderCardList.isEmpty
                        ? Center(
                            child: Column(
                            children: [
                              SizedBox(height: 150.h),
                              SvgPicture.asset(
                                ImageAssets.emptyCart,
                                height: 258.h,
                                width: 273.w,
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                'No orders',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.notoSans(
                                    color:
                                        const Color.fromRGBO(151, 151, 151, 1),
                                    fontSize: 18.sp,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5),
                              ),
                            ],
                          ))
                        : Container(
                            color: const Color.fromRGBO(19, 21, 27, 1),
                            height: 700.h,
                            width: 432.h,
                            child: OrderWidget(
                              key: UniqueKey(),
                              orderCardList: orderCardList,
                            ))
                  ],
                );
              }
            }));
  }
}
