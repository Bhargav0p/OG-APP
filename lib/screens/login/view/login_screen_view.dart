import 'package:apogee_2022/provider/user_details_viewmodel.dart';
import 'package:apogee_2022/screens/events/view/events_view.dart';
import 'package:apogee_2022/screens/onboarding/onboardingpage.dart';
import 'package:apogee_2022/utils/error_messages.dart';
import 'package:apogee_2022/widgets/error_dialogue.dart';
import 'package:apogee_2022/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../widgets/apogee_snackbar.dart';
import '../repository/model/data.dart';
import '../repository/model/gloginData.dart';
import '../view_model/glogin_view_model.dart';
import '../view_model/login_view_model.dart';
import 'forgot_password_dialog.dart';

GoogleSignIn googleSignIn =
    GoogleSignIn(hostedDomain: "pilani.bits-pilani.ac.in", scopes: <String>[
  'email',
]);

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({super.key});

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView>
    with TickerProviderStateMixin {
  bool isHidden = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late AnimationController iconColorController;
  Animation? animation;

  // late final AnimationController backgroundRotationController =
  //     AnimationController(
  //         vsync: this, duration: const Duration(milliseconds: 10000))
  //       ..repeat();

  // late final Animation<double> _rotationAnimation =
  //     Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
  //         parent: backgroundRotationController, curve: Curves.linear));

  late final AnimationController passwordTextFieldShakeController =
      AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );

  late final Animation<Offset> _passwordOffsetAnimation =
      TweenSequence<Offset>([
    TweenSequenceItem(
        tween: Tween<Offset>(begin: Offset.zero, end: const Offset(0.125, 0.0)),
        weight: 1),
    TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(0.125, 0.0), end: Offset.zero),
        weight: 1),
    TweenSequenceItem(
        tween:
            Tween<Offset>(begin: Offset.zero, end: const Offset(-0.0625, 0.0)),
        weight: 1),
    TweenSequenceItem(
        tween:
            Tween<Offset>(begin: const Offset(-0.0625, 0.0), end: Offset.zero),
        weight: 1),
  ]).animate(CurvedAnimation(
    parent: passwordTextFieldShakeController,
    curve: Curves.linear,
  ));

  late final AnimationController usernameTextFieldShakeController =
      AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );

  late final Animation<Offset> _usernameOffsetAnimation =
      TweenSequence<Offset>([
    TweenSequenceItem(
        tween: Tween<Offset>(begin: Offset.zero, end: const Offset(0.125, 0.0)),
        weight: 1),
    TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(0.125, 0.0), end: Offset.zero),
        weight: 1),
    TweenSequenceItem(
        tween:
            Tween<Offset>(begin: Offset.zero, end: const Offset(-0.0625, 0.0)),
        weight: 1),
    TweenSequenceItem(
        tween:
            Tween<Offset>(begin: const Offset(-0.0625, 0.0), end: Offset.zero),
        weight: 1),
  ]).animate(CurvedAnimation(
    parent: usernameTextFieldShakeController,
    curve: Curves.linear,
  ));

  @override
  void dispose() {
    passwordController.dispose();
    usernameController.dispose();
    iconColorController.dispose();
    usernameTextFieldShakeController.dispose();
    passwordTextFieldShakeController.dispose();
    //  backgroundRotationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    iconColorController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    animation = ColorTween(
      begin: const Color.fromRGBO(255, 255, 255, 0.7),
      end: const Color.fromRGBO(152, 85, 217, 1),
    ).animate(iconColorController);
    super.initState();
  }

  LoginViewModel loginViewModel = LoginViewModel();
  GoogleLoginViewModel googleLoginViewModel = GoogleLoginViewModel();
  var authOrGoogleAuthResult;
  bool isLoaderVisible = false, statusTypeGoogle = false;
  ValueNotifier<bool> isPwdHidden = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: const Color.fromRGBO(22, 23, 29, 1),
            body: !isLoaderVisible
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Positioned(
                            child: Image.asset(
                              "assets/images/purpleGradientIndSim.png",
                            ),
                          ),
                          Positioned(
                            bottom: 31.h,
                            left: 0,
                            right: 0,
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Made with ❤️ by DVM",
                                    style: GoogleFonts.notoSans(
                                        color: Colors.white, fontSize: 14.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Padding(
                                    padding: EdgeInsets.only(top: 98.h),
                                    child: Image.asset(
                                      "assets/images/APOGEELogoLogin.png",
                                      height: 133.h,
                                      width: 258.w,
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 75.h, left: 42.w),
                                child: Text('Login',
                                    style: TextStyle(
                                        fontFamily: 'sui-generis',
                                        color: Colors.white,
                                        fontSize: 36.sp,
                                        fontWeight: FontWeight.w400)
                                    // style: GoogleFonts.notoSansGujarati(
                                    //     color: Colors.white,
                                    //     fontSize: 36.sp,
                                    //     fontWeight: FontWeight.w400),
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.h, left: 44.w),
                                child: Text(
                                  'Please sign in to continue',
                                  style: GoogleFonts.notoSansGujarati(
                                      color: const Color.fromRGBO(
                                          161, 161, 161, 1),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Form(
                                  child: Padding(
                                padding: EdgeInsets.only(top: 59.h, left: 35.w),
                                child: SizedBox(
                                  width: 360.w,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 22.h,
                                        ),
                                        child: SlideTransition(
                                          position: _usernameOffsetAnimation,
                                          child: TextFormField(
                                            cursorColor: const Color.fromRGBO(
                                                255, 255, 255, 0.7),
                                            controller: usernameController,
                                            validator: (value) {
                                              return null;
                                            },
                                            style: GoogleFonts.notoSansGujarati(
                                                fontSize: 16.sp,
                                                color: const Color.fromRGBO(
                                                    255, 255, 255, 0.7)),
                                            decoration: InputDecoration(
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 17.w, right: 18.w),
                                                child: SvgPicture.asset(
                                                  'assets/images/EnvelopeUsernameLogin.svg',
                                                ),
                                              ),
                                              prefixIconConstraints:
                                                  BoxConstraints(
                                                      maxWidth: 70.w,
                                                      maxHeight: 21.h),
                                              contentPadding: EdgeInsets.only(
                                                  top: 24.h,
                                                  bottom: 19.h,
                                                  left: 27.w),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                borderSide: BorderSide(
                                                  width: 1.w,
                                                  color: const Color.fromRGBO(
                                                      152, 85, 217, 1),
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: const Color.fromRGBO(
                                                  15, 16, 20, 1),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r)),
                                              hintText: "Enter your username",
                                              hintStyle:
                                                  GoogleFonts.notoSansGujarati(
                                                fontSize: 16.sp,
                                                color: const Color.fromRGBO(
                                                    169, 169, 169, 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SlideTransition(
                                        position: _passwordOffsetAnimation,
                                        child: TextFormField(
                                          cursorColor: const Color.fromRGBO(
                                              255, 255, 255, 0.7),
                                          controller: passwordController,
                                          obscureText: isHidden,
                                          style: GoogleFonts.notoSansGujarati(
                                              fontSize: 16.sp,
                                              color: const Color.fromRGBO(
                                                  255, 255, 255, 0.7)),
                                          decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 13.w, right: 12.w),
                                              child: SvgPicture.asset(
                                                'assets/images/CrossedLockPasswordLogin.svg',
                                                width: 32.w,
                                              ),
                                            ),
                                            prefixIconConstraints:
                                                BoxConstraints(
                                                    maxWidth: 75.w,
                                                    maxHeight: 23.h),
                                            contentPadding: EdgeInsets.only(
                                                top: 24.h,
                                                bottom: 19.h,
                                                left: 57.w),
                                            suffixIcon: IconButton(
                                                focusColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onPressed: () {
                                                  bool blockTap = true;
                                                  if (iconColorController
                                                              .value !=
                                                          1 ||
                                                      iconColorController
                                                              .value !=
                                                          0) {
                                                    blockTap = true;
                                                  }
                                                  if (iconColorController
                                                              .value ==
                                                          1 &&
                                                      blockTap) {
                                                    isHidden = !isHidden;
                                                    iconColorController
                                                        .reverse();
                                                  }
                                                  if (blockTap &&
                                                      iconColorController
                                                              .value ==
                                                          0) {
                                                    isHidden = !isHidden;
                                                    iconColorController
                                                        .forward();
                                                  }
                                                },
                                                icon: Icon(
                                                    Icons.visibility_outlined,
                                                    color: animation?.value ??
                                                        const Color.fromRGBO(
                                                            255,
                                                            255,
                                                            255,
                                                            0.7))),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              borderSide: BorderSide(
                                                width: 1.w,
                                                color: const Color.fromRGBO(
                                                    152, 85, 217, 1),
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: const Color.fromRGBO(
                                                15, 16, 20, 1),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.r)),
                                            hintText: "Enter your password",
                                            hintStyle:
                                                GoogleFonts.notoSansGujarati(
                                              fontSize: 16.sp,
                                              color: const Color.fromRGBO(
                                                  169, 169, 169, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) {
                                        return const Align(
                                          alignment: Alignment(1, 0.30),
                                          child: ForgotPasswordDialog(),
                                        );
                                      });
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 304.w, top: 7.h),
                                  child: Text('Forgot Password?',
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ).copyWith(
                                              decoration:
                                                  TextDecoration.underline))),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 37.h, bottom: 41.h),
                                child: GestureDetector(
                                  onTap: () {
                                    bool tempBlock = true;
                                    if ((passwordController.text
                                                .trim()
                                                .isEmpty ||
                                            passwordController.text.trim() ==
                                                "") &&
                                        (usernameController.text
                                                .trim()
                                                .isEmpty ||
                                            usernameController.text.trim() ==
                                                "")) {
                                      passwordTextFieldShakeController.reset();
                                      usernameTextFieldShakeController.reset();
                                      passwordTextFieldShakeController
                                          .forward();
                                      usernameTextFieldShakeController
                                          .forward();
                                      tempBlock = false;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          CustomSnackBar().apogeeSnackBar(
                                              'Enter the password and username'));
                                    } else if (tempBlock &&
                                        (passwordController.text
                                                .trim()
                                                .isEmpty ||
                                            passwordController.text.trim() ==
                                                "")) {
                                      if (passwordTextFieldShakeController
                                              .value ==
                                          1) {
                                        passwordTextFieldShakeController
                                            .reset();
                                      }
                                      passwordTextFieldShakeController
                                          .forward();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(CustomSnackBar()
                                              .apogeeSnackBar(
                                                  'Enter the password'));
                                    } else if (tempBlock &&
                                        (usernameController.text
                                                .trim()
                                                .isEmpty ||
                                            usernameController.text.trim() ==
                                                "")) {
                                      if (usernameTextFieldShakeController
                                              .value ==
                                          1) {
                                        usernameTextFieldShakeController
                                            .reset();
                                      }
                                      usernameTextFieldShakeController
                                          .forward();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        content: SizedBox(
                                            height: 25.h,
                                            child: const Center(
                                                child: Text(
                                                    "Enter the username"))),
                                      ));
                                    } else if (usernameController
                                            .text.isNotEmpty &&
                                        passwordController.text.isNotEmpty) {
                                      setState(() {
                                        isLoaderVisible = true;
                                        statusTypeGoogle = false;
                                      });
                                      authOrGoogleAuthResult =
                                          loginViewModel.authenticate(
                                              usernameController.text.trim(),
                                              passwordController.text.trim(),
                                              false);
                                      // usernameController.clear();
                                      // passwordController.clear();
                                    } else {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return const Align(
                                              alignment: Alignment.bottomCenter,
                                              child: ErrorDialog(
                                                  errorMessage: ErrorMessages
                                                      .emptyUsernamePassword),
                                            );
                                          });
                                    }
                                  },
                                  child: Center(
                                    child: Container(
                                      height: 60.h,
                                      width: 245.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                                color: const Color.fromRGBO(
                                                    152, 85, 217, 0.15),
                                                offset: Offset(10.w, 10.h),
                                                blurRadius: 20.r)
                                          ],
                                          color: const Color.fromRGBO(
                                              152, 85, 217, 1)),
                                      child: Text('Login',
                                          style: TextStyle(
                                              fontFamily: 'sui-generis',
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 18.h),
                                  child: SvgPicture.asset(
                                    'assets/images/LoginDivider.svg',
                                    width: 326.2.w,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    if (await googleSignIn.isSignedIn()) {
                                      googleSignIn.disconnect();
                                    }
                                    print('inside google login');
                                    await googleSignIn.signIn().then((result) {
                                      String? photoUrl = result?.photoUrl;
                                      String? email = result?.email;
                                      bool isBitsian;
                                      if (email != null) {
                                        email = email.toLowerCase();
                                        isBitsian = email.contains(
                                            "pilani.bits-pilani.ac.in");
                                      } else {
                                        isBitsian = false;
                                      }
                                      result?.authentication.then((googleKey) {
                                        setState(() {
                                          isLoaderVisible = true;
                                          statusTypeGoogle = true;
                                        });
                                        print('id token: ${googleKey.idToken}');
                                        authOrGoogleAuthResult =
                                            googleLoginViewModel.authenticate(
                                                googleKey.idToken,
                                                isBitsian,
                                                photoUrl,
                                                email);
                                      });
                                    });
                                  } catch (error) {
                                    Future.microtask(() => setState(() {
                                          isLoaderVisible = false;
                                        }));
                                    Future.microtask(() => showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return Align(
                                            alignment: Alignment.bottomCenter,
                                            child: ErrorDialog(
                                                errorMessage: ErrorMessages
                                                    .platformException),
                                          );
                                        }));
                                  }
                                },
                                child: Center(
                                  child: Container(
                                    height: 33.h,
                                    width: 230.w,
                                    alignment: Alignment.center,
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 13.w),
                                            child: SvgPicture.asset(
                                                "assets/images/GoogleLogoLogin.svg",
                                                height: 33.w,
                                                width: 33.w),
                                          ),
                                          Text(
                                            'Login with BITS Mail',
                                            style: GoogleFonts.notoSansGujarati(
                                                color: const Color.fromRGBO(
                                                    213, 213, 213, 1),
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ]),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                : statusTypeGoogle
                    ? FutureBuilder<GoogleAuthResult>(
                        future: authOrGoogleAuthResult,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data?.error == null) {
                              Future.microtask(() async {
                                await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const OnBoardingPage()));
                              });
                            } else {
                              googleSignIn.disconnect();
                              Future.microtask(() => setState(() {
                                    isLoaderVisible = false;
                                  }));
                              Future.microtask(() => showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return Align(
                                      alignment: Alignment.bottomCenter,
                                      child: ErrorDialog(
                                          errorMessage: snapshot.data?.error),
                                    );
                                  }));
                            }
                          } else {
                            return const Loader();
                          }
                          return Container();
                        },
                      )
                    : FutureBuilder<AuthResult>(
                        future: authOrGoogleAuthResult,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data?.error == null) {
                              Future.microtask(() async {
                                if (UserDetailsViewModel.userDetails.userID ==
                                    '522') {
                                  await Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainEventsScreen())); //wait for 1 second
                                } else {
                                  print('onboarding');
                                  // Navigator.of(context, rootNavigator: true)
                                  //     .pushNamedAndRemoveUntil(
                                  //         'onboarding', (route) => true);
                                  await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const OnBoardingPage()));
                                  print('onboarding2');
                                }
                              });
                            } else {
                              Future.microtask(() => setState(() {
                                    isLoaderVisible = false;
                                  }));
                              Future.microtask(() => showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return Align(
                                      alignment: Alignment.bottomCenter,
                                      child: ErrorDialog(
                                          errorMessage: snapshot.data?.error),
                                    );
                                  }));
                            }
                          } else {
                            return const Loader();
                          }
                          return Container();
                        },
                      )),
      ),
    );
  }
}
