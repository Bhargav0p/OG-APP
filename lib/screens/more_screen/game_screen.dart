import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/colors.dart';
import '../../widgets/apogee_snackbar.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String gameUrl =
      'https://drive.google.com/drive/folders/1qhOyhacsF8ThhMrLVTGjwlwpVmckMB19?usp=share_link';

  Future<void> getUrlValue() async {
    await FirebaseFirestore.instance
        .collection('gamepath')
        .doc('1')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        var path = data['path'] as String?;
        if (path != null) {
          gameUrl = path;
        }
        // do something with the path value
      } else {
        print('Document does not exist on the database');
      }
    }).catchError((error) {
      print('Error getting document: $error');
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void launchUrlInBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 21, 27, 1),
      body: Stack(
        children: [
          Image.asset("assets/images/purpleGradientSeeMore.png"),
          Column(
            children: [
              SizedBox(
                height: 93.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 24.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                    SizedBox(
                      width: 24.w,
                    ),
                    Text(
                      'BitsARoute',
                      style: TextStyle(
                          fontFamily: 'sui-generis',
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60.h),
              Padding(
                padding: EdgeInsets.only(left: 40.w),
                child: Image.asset(
                  'assets/images/game_img.png',
                  height: 304.h,
                  width: 278.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 64.h, left: 44.w, right: 44.w),
                child: Text(
                    'Explore the Campus without getting lost, now with mysteries to discover on campus which can not be seen with mortal eyes.',
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w300,
                        fontSize: 16.sp,
                        color: Colors.white),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Text('A unique AR Campus experience',
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w300,
                        fontSize: 16.sp,
                        color: Color.fromRGBO(253, 219, 67, 1)),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: EdgeInsets.only(top: 71.h),
                child: GestureDetector(
                  onTap: () async {
                    if (Platform.isAndroid) {
                      try {
                        await getUrlValue();
                      } catch (e) {
                        gameUrl =
                            'https://play.google.com/store/apps/details?id=com.DVM.ARBITS';
                      }
                      launchUrlInBrowser(gameUrl);
                    } else {
                      var snackBar = CustomSnackBar().apogeeSnackBar(
                          "App is currently available only for android users");
                      if (!mounted) {}
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(
                    height: 60.h,
                    width: 194.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: ApogeeColors.purpleButtonColor),
                    child: Center(
                      child: Text(
                        "Download Now",
                        style: GoogleFonts.notoSans(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
