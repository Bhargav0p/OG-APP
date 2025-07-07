import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ok_button.dart';

class ErrorDialog extends StatefulWidget {
  const ErrorDialog(
      {Key? key, this.errorMessage, this.isFatalError, this.isSuccesspopup})
      : super(key: key);
  final String? errorMessage;
  final bool? isFatalError;
  final bool? isSuccesspopup;

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        width: 408.w,
        height: widget.isSuccesspopup == true ? 450.h : 650.h,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: widget.isSuccesspopup == true ? 100.h : 80.h,
                left: 70.w,
                right: 70.w,
              ),
              child: SvgPicture.asset(
                widget.isSuccesspopup == true
                    ? 'assets/images/greenTick.svg'
                    : 'assets/images/no_events.svg',
                height: widget.isSuccesspopup == true ? 100.h : 335.h,
                width: 268.w,
              ),
            ),
            SizedBox(
              height: 32.h,
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: widget.isSuccesspopup == true ? 50.h : 35.h,
                left: 50.w,
                right: 50.w,
                top: 10.h,
              ),
              child: Text(
                widget.errorMessage ?? 'Loading...',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ),
            (widget.isFatalError == null || widget.isFatalError == false)
                ? TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const OkButton())
                : Container()
          ],
        ),
      ),
    );
  }
}
