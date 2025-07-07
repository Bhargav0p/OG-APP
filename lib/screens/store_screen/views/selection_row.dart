import 'package:apogee_2022/screens/store_screen/controllers/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/colors.dart';

class SelectionRow extends StatefulWidget {
  const SelectionRow({Key? key}) : super(key: key);

  @override
  State<SelectionRow> createState() => _SelectionRowState();
}

class _SelectionRowState extends State<SelectionRow> {
  @override
  void initState() {
    StoreController.selectedType.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            storeController.selectionChange(0);
          },
          child: Container(
            decoration: BoxDecoration(
                color: (StoreController.selectedType.value == 0)
                    ? ApogeeColors.purpleButtonColor
                    : ApogeeColors.greyButtonColor,
                borderRadius: BorderRadius.circular(5.r)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 9.h),
              child: Text(
                "Prof Shows",
                style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 17.w,
        ),
        GestureDetector(
          onTap: () {
            storeController.selectionChange(1);
          },
          child: Container(
            decoration: BoxDecoration(
                color: (StoreController.selectedType.value == 1)
                    ? ApogeeColors.purpleButtonColor
                    : ApogeeColors.greyButtonColor,
                borderRadius: BorderRadius.circular(5.r)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 9.h),
              child: Text(
                "Speakers",
                style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 17.w,
        ),
        GestureDetector(
          onTap: () {
            storeController.selectionChange(2);
          },
          child: Container(
            decoration: BoxDecoration(
                color: (StoreController.selectedType.value == 2)
                    ? ApogeeColors.purpleButtonColor
                    : ApogeeColors.greyButtonColor,
                borderRadius: BorderRadius.circular(5.r)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 9.h),
              child: Text(
                "Merch",
                style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
