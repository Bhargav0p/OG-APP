import 'package:apogee_2022/home.dart';
import 'package:apogee_2022/provider/user_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SlowInternetPage extends StatefulWidget {
  SlowInternetPage({Key? key, required this.status}) : super(key: key);
  int status;

  @override
  State<SlowInternetPage> createState() => _SlowInternetPageState();
}

class _SlowInternetPageState extends State<SlowInternetPage> {
  String? qrCode;
  String? email;

  readEmail() async {
    print('read email called');
    FlutterSecureStorage storage = const FlutterSecureStorage();
    email = await storage.read(key: 'email');
    print('Email:$email');
    setState(() {});
  }

  @override
  void initState() {
    readEmail();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String emailString = email == null
        ? 'User ID : ${UserDetailsViewModel.userDetails.userID}'
        : 'Email : ${email?.split('@')[0]}';
    qrCode = UserDetailsViewModel.userDetails.qrCode;
    return Scaffold(
      backgroundColor: const Color(0xFF2F3036),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100.h),
            Container(
              width: 268.w,
              child: Text(
                widget.status == 1
                    ? "Seems like your internet connection is weak..."
                    : "Seems like you are not connected to the internet...",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: const Color.fromRGBO(161, 161, 161, 1),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 100.h),
            Container(
              width: 268.w,
              child: Text(
                "Use this QR to gain access to prof shows and merch",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: const Color.fromRGBO(161, 161, 161, 1),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: qrCode == null ? Color(0xFF2F3036) : Colors.white),
              height: 268.sp,
              width: 268.sp,
              child: qrCode == null
                  ? SvgPicture.asset('assets/images/no_events.svg')
                  : Center(
                      child: QrImage(
                          backgroundColor: Colors.white,
                          size: 260.sp,
                          foregroundColor: Colors.black,
                          data: qrCode!),
                    ),
            ),
            SizedBox(height: 28.h),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (builder) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: Container(
                  width: 250.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.r)),
                    boxShadow: const [
                      BoxShadow(
                          color:
                              Color.fromRGBO(152, 85, 217, 0.15000000596046448),
                          offset: Offset(10, 10),
                          blurRadius: 20)
                    ],
                    color: const Color.fromRGBO(152, 85, 217, 1),
                  ),
                  child: Center(
                    child: Text(
                      'Go to the main app',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'sui-generis',
                          fontSize: 16.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  )),
            ),
            SizedBox(height: 28.h),
            Container(
              width: 324.w,
              child: Text(
                  ' ${UserDetailsViewModel.userDetails.username}\n$emailString',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.sp,
                      letterSpacing: -0.40799999237060547,
                      fontWeight: FontWeight.normal,
                      height: 1.375)),
            ),
          ],
        ),
      ),
    );
  }
}
