import 'package:apogee_2022/widgets/error_dialogue.dart';
import 'package:apogee_2022/widgets/ok_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../repository/model/forgotPasswordData.dart';
import '../view_model/forgotpwd_view_model.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ForgotPasswordDialog> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isPressed = false;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Card(
        color: Colors.black,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
          width: 408.w,
          height: 250.h,
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 32.w, right: 32.w),
                child: TextFormField(
                    // cursorColor: const Color.fromRGBO(255, 255, 255, 0.7),
                    controller: emailController,
                    style: GoogleFonts.openSans(
                        fontSize: 16.sp,
                        color: const Color.fromRGBO(255, 255, 255, 0.7)),
                    decoration: InputDecoration(
                        fillColor: const Color(0xFF1A1C1C),
                        contentPadding: EdgeInsets.only(
                            top: 19.h, bottom: 19.h, left: 24.w),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.7936.r),
                            borderSide:
                                const BorderSide(color: Color(0xFFF8D848))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.7936.r),
                            borderSide:
                                const BorderSide(color: Color(0xFFF8D848))),
                        filled: true,
                        // fillColor: const Color(0xFF1A1C1C),
                        hintText:
                            "Enter your email id used during registration",
                        hintStyle: GoogleFonts.openSans(
                            fontSize: 12.6.w,
                            color: const Color.fromRGBO(255, 255, 255, 0.7),
                            fontWeight: FontWeight.w400))),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 35.h,
                  left: 50.w,
                  right: 50.w,
                  top: 10.h,
                ),
              ),
              TextButton(
                  onPressed: () async {
                    if (isPressed) {
                    } else {
                      isPressed = true;
                      if (emailController.text.isNotEmpty) {
                        ForgotPasswordResponse forgotPasswordResponse =
                            await ForgotPasswordViewModel()
                                .forgotPassword(emailController.text);
                        isPressed = false;
                        if (forgotPasswordResponse.display_message == null) {
                          if (!mounted) {}
                          Navigator.pop(context);
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return Align(
                                  alignment: Alignment.bottomCenter,
                                  child: ErrorDialog(
                                      isSuccesspopup: true,
                                      errorMessage:
                                          'Login with the credentials sent on your email'),
                                );
                              });
                        } else {
                          isPressed = false;
                          if (!mounted) {}
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return Align(
                                  alignment: Alignment.bottomCenter,
                                  child: ErrorDialog(
                                      errorMessage: forgotPasswordResponse
                                          .display_message),
                                );
                              });
                        }
                      } else {
                        isPressed = false;
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: ErrorDialog(
                                    errorMessage: 'Enter an email id'),
                              );
                            });
                      }
                    }
                  },
                  child: const OkButton(
                    buttonText: 'Send email',
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
