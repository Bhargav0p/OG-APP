import 'dart:async';
import 'dart:convert';

import 'package:apogee_2022/provider/firebase_init_bool.dart';
import 'package:apogee_2022/screens/developers_screen/env.dart';
import 'package:apogee_2022/screens/events/repository/model/miscEventResult.dart';
import 'package:apogee_2022/screens/events/view/events_view.dart';
import 'package:apogee_2022/screens/food_stalls/repo/model/food_stall_model.dart';
import 'package:apogee_2022/screens/food_stalls/repo/model/hive_model/hive_menu_entry.dart';
import 'package:apogee_2022/screens/food_stalls/view/food_stall_screen.dart';
import 'package:apogee_2022/screens/more_screen/game_screen.dart';
import 'package:apogee_2022/screens/more_screen/screens/sponsors/view/sponsors.dart';
import 'package:apogee_2022/screens/orders/order_screen.dart';
import 'package:apogee_2022/screens/slowInternetPage.dart';
import 'package:apogee_2022/screens/wallet_screen/view/wallet_screen.dart';
import 'package:apogee_2022/utils/urls.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;

import 'firebase_options.dart';
import 'home.dart';
import 'notificationservice/local_notification_service.dart';
import 'provider/user_details_viewmodel.dart';
import 'screens/login/view/login_screen_view.dart';

class TemporaryApp extends StatefulWidget {
  @override
  _TemporaryAppState createState() => _TemporaryAppState();
}

class _TemporaryAppState extends State<TemporaryApp> {
  static String _pkg = "constellations_list";

  static String? get pkg => Env.getPackage(_pkg);

  static String get bundle => Env.getBundle(_pkg);

  Future<void> initializeApp() async {
    print('goes into initialise');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseMessaging.instance.subscribeToTopic('all');
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("${message.data}");
        if (message.data != null) {
          print(message.data['title']);
          print(message.data['body']);
          LocalNotificationService.createanddisplaynotification(message);
        }
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
    await LocalNotificationService.initialize();
    // //remove this delay
    // await Future.delayed(const Duration(seconds: 30));
    isFirebaseInitialised.value = true;
    print('ended firebase initialise');
  }

  @override
  void initState() {
    initializeApp();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const RestartWidget(child: ApogeeApp());
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class ApogeeApp extends StatefulWidget {
  const ApogeeApp({super.key});

  @override
  State<ApogeeApp> createState() => _ApogeeAppState();
}

class _ApogeeAppState extends State<ApogeeApp> {
  UserDetailsViewModel userDetailsViewModel = UserDetailsViewModel();
  int checkInternetConnection = 0;
  bool calledRefreshFunctionOnce = false;

  Future<void> refreshQrCode() async {
    String auth = "Bearer ${UserDetailsViewModel.userDetails.Bearer}";
    {
      http.Response response = await http
          .post(
            Uri.parse('$kBaseUrl/wallet/auth/qr-code/refresh'),
            headers: {
              'Authorization': auth,
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'id': int.parse(UserDetailsViewModel.userDetails.userID!),
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        print('refreshed');
      } else {
        throw Exception(response.statusCode);
      }
    }
  }

  setInterenetConnection() async {
    print('set internet connection called');
    try {
      await refreshQrCode();
      checkInternetConnection = 2;
    } catch (e) {
      if (e.runtimeType == TimeoutException) {
        checkInternetConnection = 1;
      } else if (e.toString() == "Exception: 403") {
        print(e);
        print('error in internet connection');
        checkInternetConnection = 3;
      } else {
        checkInternetConnection = 4;
      }
      print(e);
    }
    print('set internet connection ended');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(428, 926),
        builder: (context, child) {
          return MaterialApp(
            navigatorObservers: [ChuckerFlutter.navigatorObserver],
            routes: {
              'food_stalls': (context) => const FoodStallScreen(),
              'login': (context) => const LoginScreenView(),
              'wallet': (context) => const WalletScreen(),
              'home': (context) => const HomeScreen(),
              'sponsors': (context) => const SponsorScreen(),
              'order': (context) => OrdersScreen(key: UniqueKey()),
              'game': (context) => GameScreen()
            },
            home: FutureBuilder(
              future: userDetailsViewModel.userCheck(),
              builder: (context, snapshot) {
                print('reached main app now');
                if (snapshot.hasData) {
                  if (snapshot.data == false) {
                    Future.microtask(() =>
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (builder) => const LoginScreenView()),
                          (route) => false,
                        ));
                  } else {
                    if (UserDetailsViewModel.userDetails.userID == '522') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainEventsScreen()));
                    } else {
                      if (calledRefreshFunctionOnce) {
                        if (checkInternetConnection == 1 ||
                            checkInternetConnection == 4) {
                          Future.microtask(
                              () => Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (builder) => SlowInternetPage(
                                            status: checkInternetConnection)),
                                    (route) => false,
                                  ));
                        } else if (checkInternetConnection == 2) {
                          Future.microtask(() =>
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (builder) => const HomeScreen()),
                                (route) => false,
                              ));
                        } else if (checkInternetConnection == 3) {
                          return Scaffold(
                            backgroundColor: Colors.black,
                            body: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 200.h,
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/no_events.svg',
                                    height: 335.h,
                                    width: 268.w,
                                  ),
                                  SizedBox(
                                    height: 32.h,
                                  ),
                                  const Text(
                                    "Error occured",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.black,
                            child: Image.asset(
                              'assets/images/APOGEELogoLogin.png',
                              width: 365.w,
                              height: 186.h,
                            ),
                          );
                        }
                      } else {
                        calledRefreshFunctionOnce = true;
                        setInterenetConnection();
                        return Container(
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                          color: Colors.black,
                          child: Image.asset(
                            'assets/images/APOGEELogoLogin.png',
                            width: 365.w,
                            height: 186.h,
                          ),
                        );
                      }
                    }
                  }
                }
                //TODO: change this to a splash screen
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  color: Colors.black,
                  child: Image.asset(
                    'assets/images/APOGEELogoLogin.png',
                    width: 365.w,
                    height: 186.h,
                  ),
                );
              },
            ),
          );
        });
  }
}

Future<void> main() async {
  print('started main');
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MiscEventListAdapter());
  Hive.registerAdapter(MiscEventDataAdapter());
  Hive.registerAdapter(MiscEventCatListAdapter());
  Hive.registerAdapter(MiscEventCategoryAdapter());
  Hive.registerAdapter(FoodStallAdapter());
  Hive.registerAdapter(MenuItemAdapter());
  Hive.registerAdapter(FoodStallListAdapter());
  Hive.registerAdapter(HiveMenuEntryAdapter());
  await Hive.openBox<MiscEventList>('miscEventListBox');
  await Hive.openBox<MiscEventCatList>('miscEventCatBox');
  await Hive.openBox('cartBox');
  await Hive.openBox('firstRun');
  await Hive.openBox<FoodStallList>('foodStallBox');
  ChuckerFlutter.showOnRelease = false;
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  print('initialised hive');
  runApp(TemporaryApp());
}
