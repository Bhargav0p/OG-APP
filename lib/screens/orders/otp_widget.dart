import 'package:apogee_2022/screens/orders/order_screen_viewmodel.dart';
import 'package:apogee_2022/screens/orders/repo/model/order_card_model.dart';
import 'package:apogee_2022/widgets/apogee_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpWidget extends StatefulWidget {
  OtpWidget({Key? key, required this.orderCardModel}) : super(key: key);
  OrderCardModel orderCardModel;

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  String otp = 'Get OTP';

  @override
  void initState() {
    widget.orderCardModel.status2.addListener(() {
      if (!mounted) {
        return;
      }
      setState(() {
        print('otp color changed');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('otp widget built');
    return GestureDetector(
      onTap: () async {
        print('tapped');
        if (widget.orderCardModel.status2.value < 2) {
          {
            var snackBar = CustomSnackBar().apogeeSnackBar(
                'OTP will be available when your order is ready');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
          if (widget.orderCardModel.status2.value >= 4) {
            var snackBar = CustomSnackBar()
                .apogeeSnackBar('OTP is not available for cancelled orders');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }
          if (widget.orderCardModel.status2.value == 2) {
            try {
              await OrderScreenViewModel()
                  .makeOtpSeen(widget.orderCardModel.orderId!);
              print('success');
              if (!mounted) {
                return;
              }
              setState(() {
                otp = widget.orderCardModel.otp.toString();
              });
            } catch (e) {
              var snackBar = CustomSnackBar()
                  .apogeeSnackBar(e.toString() ?? 'Error occured');
              if (!mounted) {}
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
        }
      },
      child: Container(
        alignment: Alignment.center,
        // alignment: Alignment.bottomCenter,
        width: 171.w,
        height: 52.h,
        // margin: EdgeInsets.symmetric(
        //     horizontal:
        //     UIUtills().getProportionalWidth(width: 20.00)),
        decoration: BoxDecoration(
          color: widget.orderCardModel.status2.value >= 2 &&
                  widget.orderCardModel.status2.value < 4
              ? const Color(0xff9855D9)
              : const Color(0xFF42255E),
          borderRadius: BorderRadius.circular(
            15.r,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.orderCardModel.status2.value == 3
                  ? widget.orderCardModel.otp.toString()
                  : otp,
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
