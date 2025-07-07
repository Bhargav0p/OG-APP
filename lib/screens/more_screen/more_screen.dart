import 'package:apogee_2022/main.dart';
import 'package:apogee_2022/provider/user_details_viewmodel.dart';
import 'package:apogee_2022/screens/developers_screen/demo.dart';
import 'package:apogee_2022/screens/more_screen/screens/contact_us.dart';
import 'package:apogee_2022/screens/more_screen/screens/epc_blog.dart';
import 'package:apogee_2022/screens/more_screen/screens/general_info.dart';
import 'package:apogee_2022/screens/more_screen/screens/hpc_blog.dart';
import 'package:apogee_2022/screens/more_screen/screens/industrySimulation/view/indSimView.dart';
import 'package:apogee_2022/screens/more_screen/screens/map.dart';
import 'package:apogee_2022/screens/more_screen/screens/sponsors/view/sponsors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MoreScreenMain extends StatelessWidget {
  MoreScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 21, 27, 1),
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
                      'See More',
                      style: TextStyle(
                          fontFamily: 'sui-generis',
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  buildTile('blog', 'EPC Blog', const EpcBlog(), context),
                  buildTile('blog', 'HPC Wall Mag', const HpcBlog(), context),
                  buildTile(
                      'sponsors', 'Sponsors', const SponsorScreen(), context),
                  buildTile('map', 'Map', const BitsMap(), context),
                  buildTile('contactUs', 'Contact Us', const ContactScreen(),
                      context),
                  buildTile('developers', 'Developers',
                      ConstellationsListDemo(), context),
                  buildTile(
                      'info', 'General Info', const GeneralInfo(), context),
                  buildTile('indSim', 'Industry Simulation',
                      const IndSimScreen(), context),
                  buildLogout('info', 'Logout', context),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLogout(String icon, String title, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await UserDetailsViewModel().removeUser();
        RestartWidget.restartApp(context);
      },
      child: Container(
        margin: EdgeInsets.only(left: 32.w, right: 32.w, bottom: 24.h),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(156, 174, 221, 1),
          borderRadius: BorderRadius.circular(5.r),
        ),
        padding: EdgeInsets.only(
          right: 0.9.w,
          bottom: 0.5.w,
        ),
        child: Container(
          //   margin: EdgeInsets.only(left: 32.w, right: 32.w, bottom: 24.h),
          padding: EdgeInsets.only(left: 11.w, top: 7.5.h, bottom: 7.5.h),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(46, 52, 66, 1),
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/icons/$icon.svg",
                width: 32.w,
                height: 32.h,
              ),
              SizedBox(width: 15.w),
              Text(
                title,
                style: GoogleFonts.openSans(
                    color: Color.fromRGBO(250, 250, 250, 1),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTile(
      String icon, String title, Widget screen, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        margin: EdgeInsets.only(left: 32.w, right: 32.w, bottom: 24.h),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(156, 174, 221, 1),
          borderRadius: BorderRadius.circular(5.r),
        ),
        padding: EdgeInsets.only(
          right: 0.9.w,
          bottom: 0.5.w,
        ),
        child: Container(
          //   margin: EdgeInsets.only(left: 32.w, right: 32.w, bottom: 24.h),
          padding: EdgeInsets.only(left: 11.w, top: 7.5.h, bottom: 7.5.h),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(46, 52, 66, 1),
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/icons/$icon.svg",
                width: 32.w,
                height: 32.h,
              ),
              SizedBox(width: 15.w),
              Text(
                title,
                style: GoogleFonts.openSans(
                    color: Color.fromRGBO(250, 250, 250, 1),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
