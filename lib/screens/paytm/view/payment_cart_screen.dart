import 'package:apogee_2022/provider/user_details_viewmodel.dart';
import 'package:apogee_2022/resources/resources.dart';
import 'package:apogee_2022/screens/paytm/repository/model/paytmResponse.dart';
import 'package:apogee_2022/screens/paytm/repository/model/paytmResult.dart';
import 'package:apogee_2022/screens/paytm/view_model/paytm_response_view_model.dart';
import 'package:apogee_2022/screens/paytm/view_model/paytm_view_model.dart';
import 'package:apogee_2022/screens/wallet_screen/view/add_money_screens/add_money_success_screen.dart';
import 'package:apogee_2022/screens/wallet_screen/view/wallet_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../utils/colors.dart';
import '../../../widgets/apogee_snackbar.dart';

class PaytmCartScreen extends StatefulWidget {
  const PaytmCartScreen({Key? key}) : super(key: key);

  @override
  State<PaytmCartScreen> createState() => _PaytmCartScreenState();
}

class _PaytmCartScreenState extends State<PaytmCartScreen> {
  PaytmViewModel paytmViewModel = PaytmViewModel();
  var textEditingController = TextEditingController();
  late PaytmResponse paytmResponse;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  late PaytmResult _paytmApiResponse;
  late String mid, orderId, txnToken;
  late String amount;
  String result = "";
  bool isStaging = false;
  bool isApiCallInprogress = false;
  String callbackUrl =
      "https://securegw.paytm.in/theia/api/v1/initiateTransaction?mid={mid}&orderId={order-id}";
  bool restrictAppInvoke = false;
  bool enableAssist = true;
  final LocalAuthentication auth = LocalAuthentication();

  bool authenticated = true;
  int amountToAdd = 0;
  late int balance = 0;
  String letter = '';

  Future<void> _authenticate() async {
    authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to view QR',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      return;
    }
    if (!mounted) {
      return;
    }
  }

  @override
  void initState() {
    WalletScreenController.returnToWalletScreen.addListener(() {
      Navigator.pop(context);
    });
    super.initState();
  }

  Future<void> _paytmInitialResponse() async {
    // paytmViewModel.getPaytmResponse(amountController.text);
    isApiCallInprogress = true;
    _paytmApiResponse = await PaytmViewModel()
        .getPaytmResponse(textEditingController.text.toString());
    mid = _paytmApiResponse.mid;
    orderId = _paytmApiResponse.order_id;
    txnToken = _paytmApiResponse.txntoken;
    amount = textEditingController.text;
    callbackUrl =
        "https://securegw.paytm.in/theia/api/v1/initiateTransaction?mid=$mid&orderId=$orderId";
  }

  Future<void> _startTransaction() async {
    if (txnToken == "") {
      return;
    }
    print('started transaction');
    print(mid);
    print(orderId);
    print(amount);
    print(txnToken);
    print(callbackUrl);
    print(isStaging);
    print(restrictAppInvoke);
    print(enableAssist);

    var sendMap = <String, dynamic>{
      "mid": mid,
      "orderId": orderId,
      "amount": amount,
      "txnToken": txnToken,
      "callbackUrl": callbackUrl,
      "isStaging": isStaging,
      "restrictAppInvoke": restrictAppInvoke,
      "enableAssist": enableAssist
    };

    try {
      var response = AllInOneSdk.startTransaction(
        mid,
        orderId,
        amount,
        txnToken,
        callbackUrl,
        isStaging,
        restrictAppInvoke,
        enableAssist,
      );
      print('KJEFEWKJFN');
      response.then((value) {
        setState(() async {
          PaytmResponse paytmResponse =
              PaytmResponse.fromJson(Map<String, dynamic>.from(value as Map));
          var response =
              await PaytmResponseViewModel().postPaytmResponse(paytmResponse);
          //TODO: get whether response is correct or not
          bool isSuccess = paytmResponse.RESPMSG == "Txn Success" ||
              paytmResponse.STATUS == "TXN_SUCCESS";
          print(paytmResponse.RESPMSG);
          print(paytmResponse.STATUS);
          print('KJFBWEF');
          if (isSuccess) {
            if (!mounted) {}
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: AddMoneySuccessScreen(
                amount: amountToAdd,
                dateTime: DateTime.now(),
                isSuccess: true,
              ),
              withNavBar: false,
            );
            WalletScreenController.toRefresh.notifyListeners();
          } else {
            if (!mounted) {}
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: AddMoneySuccessScreen(
                amount: amountToAdd,
                dateTime: DateTime.now(),
                isSuccess: false,
              ),
              withNavBar: false,
            );
          }
          WalletScreenController.toRefresh.notifyListeners();
          if (!mounted) {}
        });
      }).catchError((onError) {
        if (onError is PlatformException) {
          setState(() {
            result = "${onError.message} \n  ${onError.details}";
          });
        } else {
          setState(() {
            result = onError.toString();
          });
        }
      });
    } catch (err) {
      result = err.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Positioned(
                  child: Container(
                      width: 430,
                      height: 265,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment(
                                0.9144497513771057, 0.02883869595825672),
                            end: Alignment(
                                -0.02883869782090187, 0.34730789065361023),
                            colors: [
                              Color.fromRGBO(174, 103, 244, 1),
                              Color.fromRGBO(84, 15, 151, 1)
                            ]),
                      ))),
              Positioned(
                top: 0,
                right: 0,
                child: SvgPicture.asset(
                  ImageAssets.bgImage2,
                  fit: BoxFit.cover,
                  height: 210.h,
                  width: 210.h,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 72.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 24.h, right: 24.h),
                          child: SvgPicture.asset(
                            ImageAssets.leftArrow,
                            height: 24.h,
                            color: const Color.fromRGBO(218, 218, 218, 1),
                          ),
                        ),
                      ),
                      Text(
                        'Add Money',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: const Color.fromRGBO(218, 218, 218, 1),
                            fontFamily: 'sui-generis',
                            fontSize: 28.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w400,
                            height: 1),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                  top: 232.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      width: 390.w,
                      height: 300.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.r),
                        ),
                        color: const Color.fromRGBO(56, 57, 74, 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 32.w, top: 23.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.notoSansGujarati(
                                  color: const Color(0xFF8D8D8D),
                                  fontSize: 16.sp,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                                UserDetailsViewModel.userDetails.username ??
                                    'NA',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSansGujarati(
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: 28.sp,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500,
                                    height: 1)),
                            SizedBox(height: 16.h),
                            const Divider(
                                color: Color.fromRGBO(96, 96, 96, 1),
                                thickness: 1),
                            SizedBox(height: 10.h),
                            Text(
                              "Amount",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.notoSansGujarati(
                                  color: const Color(0xFF8D8D8D),
                                  fontSize: 16.sp,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1),
                            ),
                            SizedBox(height: 15.h),
                            Container(
                              alignment: Alignment.center,
                              width: 110.w,
                              height: 40.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '₹ ',
                                    style: GoogleFonts.openSans(
                                        color: Colors.white,
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.41.sp),
                                  ),
                                  Flexible(
                                    child: TextField(
                                      controller: textEditingController,
                                      cursorColor: Colors.white,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.ltr,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(4)
                                      ],
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: false, signed: false),
                                      style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.41.sp),
                                      decoration: const InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 40.h),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(right: 32.w),
                                child: Text(
                                  "DISCLAIMER : Money added via PayTM is non-refundable",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.notoSansGujarati(
                                      color: const Color(0xFF8D8D8D),
                                      fontSize: 16.sp,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w500,
                                      height: 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              Positioned(
                  bottom: 20.h,
                  left: 20.w,
                  child: ValueListenableBuilder(
                      valueListenable: isLoading,
                      builder: (context, bool value, child) {
                        return !isLoading.value
                            ? GestureDetector(
                                onTap: () async {
                                  if (textEditingController.text == "") {
                                    var snackBar = CustomSnackBar()
                                        .apogeeSnackBar("Enter a value");
                                    if (!mounted) {}
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                  if (int.parse(textEditingController.text) ==
                                          0 ||
                                      int.parse(textEditingController.text) <
                                          0) {
                                    var snackBar = CustomSnackBar()
                                        .apogeeSnackBar(
                                            "Enter A Non Zero Positive Value");
                                    if (!mounted) {}
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    amountToAdd = int.parse(
                                        textEditingController.text.toString());
                                    if (await auth.isDeviceSupported()) {
                                      isLoading.value = true;
                                      await _authenticate();
                                      isLoading.value = false;
                                    }
                                    if (authenticated) {
                                      if (!isApiCallInprogress) {
                                        await _paytmInitialResponse();
                                        await _startTransaction();
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  width: 390.w,
                                  height: 64.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.r),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Color.fromRGBO(152, 85, 217,
                                              0.15000000596046448),
                                          offset: Offset(0, 2.799999952316284),
                                          blurRadius: 10)
                                    ],
                                    gradient: const LinearGradient(
                                        begin: Alignment(0.9233271479606628,
                                            0.0766749233007431),
                                        end: Alignment(-0.0766749233007431,
                                            0.07667377591133118),
                                        colors: [
                                          Color.fromRGBO(103, 44, 160, 1),
                                          Color.fromRGBO(76, 0, 150, 1)
                                        ]),
                                  ),
                                  child: Center(
                                    child: Text(
                                      isLoading.value
                                          ? "Please Wait.."
                                          : "Approve",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.notoSans(
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 1),
                                          fontSize: 20.sp,
                                          letterSpacing: -0.40799999237060547,
                                          fontWeight: FontWeight.normal,
                                          height: 1.1),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 10.h,
                                width: 390.w,
                                child: LinearProgressIndicator(
                                  color: ApogeeColors.purpleButtonColor,
                                  backgroundColor: Colors.black,
                                ));
                      }))
            ],
          ),
        ));
  }
}
