import 'package:apogee_2022/utils/colors.dart';
import 'package:apogee_2022/utils/scroll_remover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '/screens/food_stalls/repo/model/food_stall_model.dart';
import '/widgets/error_dialogue.dart';
import '/widgets/loader.dart';
import '../../cart/cartscreen.dart';
import '../view_model/cached_food_stalls_viewmodel.dart';
import '../view_model/food_stalls_viewmodel.dart';
import 'food_stall_tile.dart';
import 'menu_screen.dart';

class FoodStallScreen extends StatefulWidget {
  const FoodStallScreen({Key? key}) : super(key: key);

  @override
  State<FoodStallScreen> createState() => _FoodStallScreenState();
}

class _FoodStallScreenState extends State<FoodStallScreen> {
  List<FoodStall> foodStall = [];
  CachedFoodStallsViewModel cachedFoodStallEventsViewModel =
      CachedFoodStallsViewModel();
  bool isLoading = true;
  bool isStallsClosed = false;

  Future<void> updateFoodStallResult() async {
    await cachedFoodStallEventsViewModel.retrieveFoodStallNetworkResult();
    checkFoodStallResult();
  }

  void checkFoodStallResult() {
    if (FoodStallViewModel.error == null) {
      if (mounted) {
        setState(() {
          foodStall = CachedFoodStallsViewModel.listFoodStalls;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: ErrorDialog(errorMessage: FoodStallViewModel.error!),
            );
          });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cachedFoodStallEventsViewModel.getFoodStalls();
    });
    CachedFoodStallsViewModel.status.addListener(() {
      if (CachedFoodStallsViewModel.statusInt == 2) {
        isStallsClosed = false;

        checkFoodStallResult();
      } else if (CachedFoodStallsViewModel.statusInt == 1) {
        isStallsClosed = false;

        setState(() {
          foodStall = CachedFoodStallsViewModel.listFoodStalls;
          isLoading = false;
        });
      } else if (CachedFoodStallsViewModel.statusInt == 4) {
        setState(() {
          isStallsClosed = true;
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(18, 19, 24, 1),
      body: !isLoading
          ? RefreshIndicator(
              color: ApogeeColors.purpleButtonColor,
              backgroundColor: Colors.black,
              onRefresh: updateFoodStallResult,
              child: Stack(
                children: [
                  Positioned(
                      top: 0.h,
                      right: 0.h,
                      child: Image.asset(
                          'assets/images/purpleGradientSeeMore.png')),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 93.h, left: 32.w, right: 27.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Stalls',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 36.sp,
                                  color: Colors.white,
                                  fontFamily: 'sui-generis'),
                            ),
                            isStallsClosed
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          screen: CartScreen(),
                                          withNavBar: true);
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/cart.svg',
                                      height: 28.h,
                                      width: 28.h,
                                    ))
                          ],
                        ),
                      ),
                      Expanded(
                        child: isStallsClosed
                            ? ScrollConfiguration(
                                behavior: CustomScrollBehavior(),
                                child: ListView(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 182.h),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'assets/images/no_stalls.svg',
                                          width: 290.h,
                                          height: 280.h,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ScrollConfiguration(
                                behavior: CustomScrollBehavior(),
                                child: GridView.builder(
                                  padding:
                                      EdgeInsets.fromLTRB(20.w, 43.h, 20.w, 0),
                                  itemCount: foodStall.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.81777,
                                          crossAxisSpacing: 20.w,
                                          mainAxisSpacing: 24.h),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkResponse(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MenuScreen(
                                                      menuItemList:
                                                          foodStall[index].menu,
                                                      foodStallName:
                                                          foodStall[index].name,
                                                      image: foodStall[index]
                                                              .menu_image_url ??
                                                          '',
                                                      foodStallId:
                                                          foodStall[index].id,
                                                    )));
                                      },
                                      child: FoodStallTile(
                                        foodStallName: foodStall[index].name,
                                        image: foodStall[index].image_url,
                                        location: foodStall[index].description,
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  )
                ],
              ),
            )
          : const Loader(),
    );
  }
}
