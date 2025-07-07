import 'package:apogee_2022/provider/firebase_init_bool.dart';
import 'package:apogee_2022/screens/wallet_screen/view/wallet_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_auth/local_auth.dart';

import '/screens/cart/repo/model/cart_screen_model.dart';
import '/screens/cart/repo/model/post_order_response_model.dart';
import '/screens/cart/viewmodel/cart_viewmodel.dart';
import '/screens/cart/widgets/cartWidget.dart';
import '/utils/error_messages.dart';
import '/widgets/error_dialogue.dart';
import '../wallet_screen/view_model/wallet_viewmodel.dart';

class CartScreen extends StatefulWidget {
  CartScreen({super.key});

  @override
  State<CartScreen> createState() => CartScreenState();
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

class CartScreenState extends State<CartScreen> {
  List<FoodStallInCartScreen> foodStallist = [];
  Map<int, FoodStallInCartScreen> foodStallWithDetailsMap = {};
  List<int> foodStallIdList = [];
  int total = 0;
  List<int> subTotallist = [];
  bool isPostingOrder = false;

  // ignore: non_constant_identifier_names
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool authenticated = true;

  Future<void> _authenticate() async {
    authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to view QR',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  @override
  void initState() {
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
    foodStallWithDetailsMap = CartScreenViewModel().getValuesForScreen();
    foodStallIdList = CartScreenViewModel().getIdList(foodStallWithDetailsMap);
    total = CartScreenViewModel().getTotalValue(foodStallWithDetailsMap);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 19, 25, 1),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 70.h, left: 23.w, right: 30.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 20.w,
                    height: 20.h,
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 20.r,
                      color: const Color.fromRGBO(244, 244, 244, 1),
                    ),
                  ),
                ),
                Text(
                  ' Cart',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 28.sp,
                      color: Colors.white,
                      fontFamily: 'sui-generis'),
                ),
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: Hive.box('cartBox').listenable(),
            builder: (context, Box box, child) {
              foodStallWithDetailsMap =
                  CartScreenViewModel().getValuesForScreen();
              foodStallIdList =
                  CartScreenViewModel().getIdList(foodStallWithDetailsMap);
              total =
                  CartScreenViewModel().getTotalValue(foodStallWithDetailsMap);
              if (foodStallWithDetailsMap.isEmpty ||
                  box.values.isEmpty ||
                  box.keys.isEmpty ||
                  box.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 180.h),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/images/empty_cart.svg',
                          height: 306.h,
                          width: 273.w,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        // Figma Flutter Generator CartisemptyWidget - TEXT
                        Text(
                          'Cart is Empty',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.notoSans(
                              color: Color.fromRGBO(151, 151, 151, 1),
                              fontSize: 28.sp,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                              height: 1.5),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox(
                  height: 1.sh - 170.h,
                  child: Stack(
                    children: [
                      CustomScrollView(
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverPadding(
                            padding: const EdgeInsets.all(20.0),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return cartWidget(
                                  foodStallId: foodStallIdList[index],
                                  menuList: foodStallWithDetailsMap[
                                          foodStallIdList[index]]!
                                      .menuList,
                                  foodStallName: foodStallWithDetailsMap[
                                          foodStallIdList[index]]!
                                      .foodStall,
                                );
                              }, childCount: foodStallWithDetailsMap.length),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 15.h,
                        left: 0,
                        right: 0,
                        child: isPostingOrder
                            ? const Center(
                                child: LinearProgressIndicator(
                                  color: Color.fromRGBO(182, 85, 217, 1),
                                  backgroundColor: Colors.transparent,
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  if (await auth.isDeviceSupported()) {
                                    await _authenticate();
                                  }
                                  if (authenticated) {
                                    if (!isPostingOrder) {
                                      setState(() {
                                        isPostingOrder = true;
                                      });
                                      if (box.isNotEmpty) {
                                        var orderdict = CartScreenViewModel()
                                            .getPostRequestBody();
                                        try {
                                          await WalletViewModel().getBalance();
                                          if (WalletViewModel.error != null) {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: ErrorDialog(
                                                        errorMessage:
                                                            WalletViewModel
                                                                .error!),
                                                  );
                                                });
                                          } else {
                                            if (WalletViewModel.balance >=
                                                total) {
                                              OrderResult orderResult =
                                                  await CartScreenViewModel()
                                                      .postOrder(orderdict);
                                              if (CartScreenViewModel.error ==
                                                  null) {
                                                if (orderResult.id != null) {

                                                  WalletScreenController
                                                      .toRefresh
                                                      .notifyListeners();
                                                  // var snackBar = CustomSnackBar()
                                                  //     .oasisSnackBar(
                                                  //     'Order placed successfully');
                                                  // if (!mounted) {}
                                                  // ScaffoldMessenger.of(context)
                                                  //     .showSnackBar(snackBar);
                                                  if (!mounted) {}
                                                  persistentTabController.jumpToTab(
                                                      1); // Changes to the second screen (0-based index)


                                                  box.clear();
                                                } else {
                                                  isPostingOrder = false;
                                                  setState(() {});
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: ErrorDialog(
                                                              errorMessage:
                                                                  'Order Invalid'),
                                                        );
                                                      });
                                                }
                                              } else {
                                                isPostingOrder = false;
                                                setState(() {});
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: ErrorDialog(
                                                            errorMessage:
                                                                CartScreenViewModel
                                                                    .error!),
                                                      );
                                                    });
                                              }
                                            } else {
                                              isPostingOrder = false;
                                              setState(() {});
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: ErrorDialog(
                                                          errorMessage:
                                                              ErrorMessages
                                                                  .insufficientFunds),
                                                    );
                                                  });
                                            }
                                          }
                                        } catch (e) {
                                          print('goes into this');
                                          isPostingOrder = false;
                                          setState(() {});
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: ErrorDialog(
                                                      errorMessage:
                                                          WalletViewModel
                                                                  .error ??
                                                              ErrorMessages
                                                                  .unknownError),
                                                );
                                              });
                                        }
                                      } else {
                                        isPostingOrder = false;
                                        setState(() {});
                                        return showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: ErrorDialog(
                                                    errorMessage: 'Cart empty'),
                                              );
                                            });
                                      }
                                    }
                                  }
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 22.w),
                                  child: Container(
                                    width: 428.w,
                                    height: 72.h,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [
                                        Color.fromRGBO(103, 44, 160, 0.9),
                                        Color.fromRGBO(77, 0, 151, 0.9),
                                      ]),
                                      borderRadius: BorderRadius.circular(
                                        15.r,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Pay Now',
                                                style: GoogleFonts.notoSans(
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                  fontSize: 20.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '₹ $total',
                                                style: GoogleFonts.notoSans(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  fontSize: 20.sp,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
