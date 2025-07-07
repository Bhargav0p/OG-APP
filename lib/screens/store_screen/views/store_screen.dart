import 'package:apogee_2022/screens/more_screen/more_screen.dart';
import 'package:apogee_2022/screens/store_screen/controllers/store_controller.dart';
import 'package:apogee_2022/screens/store_screen/views/merch/merch_screen.dart';
import 'package:apogee_2022/screens/store_screen/views/profshow/prof_show_carousel.dart';
import 'package:apogee_2022/screens/store_screen/views/selection_row.dart';
import 'package:apogee_2022/screens/store_screen/views/speakers/speaker_list.dart';
import 'package:apogee_2022/utils/colors.dart';
import 'package:apogee_2022/utils/scroll_remover.dart';
import 'package:apogee_2022/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../data/models/showsData.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List<StoreItemData> profShowList = [];
  List<StoreItemData> merchList = [];
  List<StoreItemData> speakerList = [];

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    initialiseValues();
    StoreController.selectedType.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  initialiseValues() async {
    await storeController.initController();
    profShowList = storeController.getProfShowList();
    merchList = storeController.getMerchList();
    speakerList = storeController.getSpeakerList();
    storeController.isStoreScreenLoading.value = false;
  }

  refreshValues() async {
    await storeController.refreshController();
    profShowList = storeController.getProfShowList();
    merchList = storeController.getMerchList();
    speakerList = storeController.getSpeakerList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApogeeColors.bgColor,
      body: LayoutBuilder(builder: (context, constraints) {
        return RefreshIndicator(
          displacement: 25.h,
          edgeOffset: 10.h,
          color: ApogeeColors.purpleButtonColor,
          backgroundColor: ApogeeColors.greyButtonColor,
          onRefresh: () async {
            storeController.isStoreScreenLoading.value = true;
            await refreshValues();
            storeController.isStoreScreenLoading.value = false;
          },
          child: Stack(children: [
            Positioned(
              top: 0.h,
              right: 0.h,
              child: Image.asset('assets/images/purpleGradientSeeMore.png'),
            ),
            ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: ValueListenableBuilder(
                      valueListenable: storeController.isStoreScreenLoading,
                      builder: (context, value, child) {
                        if (!value) {
                          return Padding(
                            padding: EdgeInsets.only(top: 92.h),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 32.w, right: 27.w),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Exclusives",
                                          style: TextStyle(
                                              fontFamily: "sui-generis",
                                              color: Colors.white,
                                              fontSize: 36.sp),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            PersistentNavBarNavigator
                                                .pushNewScreen(context,
                                                    screen: MoreScreenMain(),
                                                    withNavBar: false);
                                          },
                                          child: const Icon(
                                            Icons.more_vert_rounded,
                                            color: Colors.white,
                                          ),
                                        )
                                      ]),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 25.h, left: 32.w, right: 27.w),
                                    child: const SelectionRow()),
                                if (StoreController.selectedType.value == 0)
                                  Padding(
                                      padding: EdgeInsets.only(top: 40.h),
                                      child: ProfShowCarousel(
                                          profShowList: profShowList)),
                                if (StoreController.selectedType.value == 1)
                                  Padding(
                                      padding: EdgeInsets.only(top: 40.h),
                                      child: SpeakerCarousel(
                                        speakerList: speakerList,
                                      )),
                                if (StoreController.selectedType.value == 2)
                                  Padding(
                                      padding: EdgeInsets.only(top: 0.h),
                                      child: MerchScreen(merchList: merchList))
                              ],
                            ),
                          );
                        } else {
                          return SingleChildScrollView(
                              child: Center(
                            child: SizedBox(
                              height: 1.sh,
                              width: 1.sw,
                              child: const Loader(),
                            ),
                          ));
                        }
                      }),
                ),
              ),
            )
          ]),
        );
      }),
    );
  }
}
