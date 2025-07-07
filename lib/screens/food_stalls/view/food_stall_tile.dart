import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '/utils/ui_utils.dart';

class FoodStallTile extends StatelessWidget {
  FoodStallTile({Key? key, required this.image, required this.foodStallName, required this.location})
      : super(key: key);
  String image;
  String foodStallName;
  String location;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 184.w,
          height: 225.h,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: CachedNetworkImage(
                imageUrl: image,
              )),
        ),

        Container(
          width: 184.w,
          height: 230.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              gradient: const LinearGradient(colors: <Color>[
                Color.fromRGBO(0, 0, 0, 0),
                Color.fromRGBO(27, 27, 26, 0.84),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              16.w,
              160.h,
              16.w,
              UIUtills().getProportionalHeight(height: 0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                foodStallName,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoSans(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              Text(
                location,
                style: GoogleFonts.notoSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              )
            ],
          ),
        )
      ],
    );
  }
}
