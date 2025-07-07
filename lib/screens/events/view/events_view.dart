import 'package:apogee_2022/provider/user_details_viewmodel.dart';
import 'package:apogee_2022/screens/more_screen/game_screen.dart';
import 'package:apogee_2022/screens/schedule/view/schedule_screen.dart';
import 'package:apogee_2022/screens/schedule/view/schedule_view_model.dart';
import 'package:apogee_2022/utils/scroll_remover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../../utils/colors.dart';
import '../../../widgets/error_dialogue.dart';
import '../../../widgets/loader.dart';
import '../../more_screen/more_screen.dart';
import '../repository/model/miscEventResult.dart';
import '../view_model/cached_misc_events_view_model.dart';
import '../view_model/misc_events_view_model.dart';
import 'event_block.dart';
import 'misc_screen_controller.dart';

class MainEventsScreen extends StatefulWidget {
  const MainEventsScreen({Key? key}) : super(key: key);

  @override
  State<MainEventsScreen> createState() => _MainEventsScreenState();
}

class _MainEventsScreenState extends State<MainEventsScreen> {
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  int isSelected = 0;

  CachedMiscEventsViewModel cachedMiscEventsViewModel =
      CachedMiscEventsViewModel();
  ScheduleViewModel scheduleViewModel = ScheduleViewModel();
  bool isLoading = true;
  List<MiscEventData> currentDayMiscEventList = [];
  List<MiscEventData> searchMiscEventList = [];
  List<MiscEventData> catFilteredMiscEventList = [];
  List<MiscEventCategory> miscEventCategoryList = [];
  int? filterIndex;

  void checkMiscEventsResult() {
    if (MiscEventsViewModel.error == null) {
      if (mounted) {
        setState(() {
          updateCurrentDayMiscEventList();
          isLoading = false;
        });
      }
    } else {
      //return MiscEventResult.error;
      setState(() {
        isLoading = false;
      });
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: ErrorDialog(errorMessage: MiscEventsViewModel.error!),
            );
          });
    }
  }

  Future<void> updateMiscEventsResult() async {
    await cachedMiscEventsViewModel.retrieveMiscEventResult();
    checkMiscEventsResult();
  }

  void updateCurrentDayMiscEventList() {
    currentDayMiscEventList = cachedMiscEventsViewModel
        .retrieveDayMiscEventData(MiscScreenController.selectedTab.value);
    miscEventCategoryList = cachedMiscEventsViewModel.getEventCategory();
  }

  void updateCurrentDayFilterEventList(int index, bool update) {
    catFilteredMiscEventList.clear();
    setState(() {});
    if (!update) {
      if (filterIndex != index) {
        filterIndex = index;
      } else {
        filterIndex = -1;
      }
    }
    if (searchController.text.isEmpty) {
      for (MiscEventData miscEventData in currentDayMiscEventList) {
        if (miscEventData.categories!
            .contains(miscEventCategoryList[index].category_name)) {
          catFilteredMiscEventList.add(miscEventData);
          setState(() {});
        }
      }
    } else {
      for (MiscEventData miscEventData in searchMiscEventList) {
        if (miscEventData.categories!
            .contains(miscEventCategoryList[index].category_name)) {
          catFilteredMiscEventList.add(miscEventData);
          setState(() {});
        }
      }
    }
  }

  void updateSearchList(String? a) {
    if (a != null) {
      searchMiscEventList =
          cachedMiscEventsViewModel.retrieveSearchMiscEventData(
              MiscScreenController.selectedTab.value, a);
    }
    setState(() {});
  }

  bool emptyListHandler() {
    if (searchController.text.isEmpty) {
      return currentDayMiscEventList.isEmpty;
    } else {
      return searchMiscEventList.isEmpty;
    }
  }

  bool checkScheduleStatus(MiscEventData miscEventData) {
    return (scheduleViewModel.retrieveScheduleList().contains(miscEventData));
  }

  List<MiscEventData> requiredListHandler() {
    // assortedMiscEventList.sort((a, b) => a.date_time!.compareTo(b.date_time!));
    // return assortedMiscEventList.reversed.toList();
    if (searchController.text.isEmpty) {
      if (filterIndex == null || filterIndex == -1) {
        currentDayMiscEventList.sort((a, b) => a.time!.compareTo(b.time!));
        return currentDayMiscEventList;
      } else {
        catFilteredMiscEventList.sort((a, b) => a.time!.compareTo(b.time!));
        return catFilteredMiscEventList;
      }
    } else {
      if (filterIndex == null || filterIndex == -1) {
        searchMiscEventList.sort((a, b) => a.time!.compareTo(b.time!));
        return searchMiscEventList;
      } else {
        catFilteredMiscEventList.sort((a, b) => a.time!.compareTo(b.time!));
        return catFilteredMiscEventList;
      }
    }
  }

  @override
  void initState() {
    isSelected = DateTime.now().day;
    scheduleViewModel.readFromBox();
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cachedMiscEventsViewModel.mergedRetriveMiscResult();
      if (MiscEventsViewModel.error == "403") {}
    });

    CachedMiscEventsViewModel.status.addListener(() {
      if (CachedMiscEventsViewModel.statusInt == 2) {
        checkMiscEventsResult();
      } else if (CachedMiscEventsViewModel.statusInt == 1) {
        if (MiscEventsViewModel.error == null) {
          updateCurrentDayMiscEventList();
          // updateCategories();
          setState(() {
            isLoading = false;
          });
        } else {
          //return MiscEventResult.error;
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: ErrorDialog(errorMessage: MiscEventsViewModel.error!),
                );
              });
        }
      }
    });
    MiscScreenController.selectedTab.addListener(() {
      if (mounted) {
        setState(() {
          searchController.text.isEmpty
              ? updateCurrentDayMiscEventList()
              : updateSearchList(searchController.text);
          filterIndex != null && filterIndex != -1
              ? updateCurrentDayFilterEventList(filterIndex!, true)
              : {};
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildDateWidget(String date, String month, int index) {
      return Padding(
        padding: EdgeInsets.only(top: 25.h),
        child: GestureDetector(
          onTap: () {
            MiscScreenController.selectedTab.value = dategetter(index);
            isSelected = index;

            setState(() {});
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 2.h),
                child: Container(
                  height: 80.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                      color: isSelected == index
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8.r),
                      )),
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: '$date\n',
                  style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 28.sp,
                    color: isSelected == index ? Colors.black : Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: month,
                      style: GoogleFonts.notoSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color:
                            isSelected == index ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: -8.h,
                  right: -8.w,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(19, 21, 27, 1),
                    ),
                  )),
              isSelected == index
                  ? Positioned(
                      top: 0.h,
                      right: 0.w,
                      child: Container(
                        width: 17,
                        height: 17,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(152, 85, 217, 1),
                        ),
                      ))
                  : Container()
            ],
          ),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: (UserDetailsViewModel.userDetails.userID == "522")
          ? Container()
          : Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) => const ScheduleScreen(),
                  ))
                      .then((_) {
                    setState(() {});
                  });
                },
                backgroundColor: const Color.fromRGBO(152, 85, 217, 0.5),
                child: const Icon(Icons.bookmark_border_sharp),
              ),
            ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(19, 21, 27, 1),
      body: RefreshIndicator(
        color: ApogeeColors.purpleButtonColor,
        backgroundColor: Colors.black,
        onRefresh: updateMiscEventsResult,
        child: !isLoading
            ? GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Stack(
                  children: [
                    Positioned(
                      top: 0.h,
                      right: 0.h,
                      child: Image.asset(
                          'assets/images/purpleGradientSeeMore.png'),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 93.h, left: 32.w, right: 28.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Events',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 36.sp,
                                    color: Colors.white,
                                    fontFamily: 'sui-generis'),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        PersistentNavBarNavigator.pushNewScreen(
                                            context,
                                            screen: GameScreen(),
                                            withNavBar: false);
                                      },
                                      child: SvgPicture.asset(
                                          'assets/icons/ARgame.svg')),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: GestureDetector(
                                        onTap: () {
                                          PersistentNavBarNavigator
                                              .pushNewScreen(context,
                                                  screen: MoreScreenMain(),
                                                  withNavBar: false);
                                        },
                                        child: SvgPicture.asset(
                                            'assets/icons/menu.svg')),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 48.h, left: 20.w, right: 20.w),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              gradient: const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color.fromRGBO(62, 64, 82, 1),
                                    Color.fromRGBO(57, 59, 77, 0.85)
                                  ]),
                            ),
                            child: TextField(
                              onChanged: updateSearchList,
                              focusNode: focusNode,
                              controller: searchController,
                              style: GoogleFonts.notoSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color:
                                      const Color.fromRGBO(168, 168, 168, 1)),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 18.h),
                                border: InputBorder.none,
                                hintText: "Search for your favourite events",
                                hintStyle: GoogleFonts.notoSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    color:
                                        const Color.fromRGBO(168, 168, 168, 1)),
                                prefixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    color: Color.fromRGBO(192, 192, 192, 1),
                                  ),
                                  onPressed: () {},
                                ),
                                suffixIcon: searchController.text.isEmpty
                                    ? const Icon(
                                        Icons.close,
                                        color: Colors.transparent,
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          searchController.clear();

                                          focusNode.unfocus();
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color:
                                              Color.fromRGBO(192, 192, 192, 1),
                                        )),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20.w, top: 20.h, right: 20.h),
                          child: SizedBox(
                            height: 50.h,
                            child: ScrollConfiguration(
                              behavior: CustomScrollBehavior(),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: miscEventCategoryList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.w, 0.h, 16.w, 0.h),
                                      child: GestureDetector(
                                        onTap: () {
                                          updateCurrentDayFilterEventList(
                                              index, false);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                            boxShadow: filterIndex == index
                                                ? const [
                                                    BoxShadow(
                                                        color: Color.fromRGBO(
                                                            152, 85, 217, 0.15),
                                                        offset: Offset(10, 10),
                                                        blurRadius: 20)
                                                  ]
                                                : [
                                                    const BoxShadow(
                                                        color:
                                                            Colors.transparent,
                                                        offset: Offset(10, -10),
                                                        blurRadius: 12)
                                                  ],
                                            color: filterIndex != index
                                                ? const Color.fromRGBO(
                                                    61, 63, 80, 1)
                                                : const Color.fromRGBO(
                                                    152, 85, 217, 1),
                                          ),

                                          //  padding: EdgeInsets.fromLTRB(28.w, 10.h, 28.w, 15.h),
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                28.w, 12.5.h, 28.w, 12.5.h),
                                            child: Text(
                                              '${miscEventCategoryList[index].category_name}',
                                              style: GoogleFonts.notoSans(
                                                color: Colors.white,
                                                fontWeight: filterIndex != index
                                                    ? FontWeight.w500
                                                    : FontWeight.w400,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                          child: Divider(
                            color: Color.fromRGBO(56, 56, 56, 1),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                children: [
                                  _buildDateWidget('31', 'March', 0),
                                  _buildDateWidget('1', 'April', 1),
                                  _buildDateWidget('2', 'April', 2),
                                  _buildDateWidget('3', 'April', 3),
                                ],
                              ),
                            ),
                            SizedBox(
                                width: 280.w,
                                height: 490.h,
                                child: requiredListHandler().isNotEmpty
                                    ? ListView.builder(
                                        padding: EdgeInsets.only(top: 25.h),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: requiredListHandler().length,
                                        itemBuilder: (context, index) {
                                          return EventBlock(
                                            time: requiredListHandler()[index]
                                                    .time ??
                                                'TBA',
                                            eventName:
                                                requiredListHandler()[index]
                                                    .name,
                                            eventDescription:
                                                requiredListHandler()[index]
                                                    .about,
                                            eventConductor:
                                                requiredListHandler()[index]
                                                    .organiser,
                                            eventLocation:
                                                requiredListHandler()[index]
                                                    .venue_name,
                                            eventData:
                                                requiredListHandler()[index],
                                            scheduleList: scheduleViewModel
                                                .retrieveScheduleList(),
                                          );
                                        })
                                    : Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                                'assets/images/no_events.svg'),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 130.h),
                                              child: Text(
                                                'No Upcoming Events',
                                                style: GoogleFonts.notoSans(
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color.fromRGBO(
                                                        151, 151, 151, 1)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Center(
                child: SizedBox(
                  height: 1.sh,
                  width: 1.sw,
                  child: const Loader(),
                ),
              )),
      ),
    );
  }

  int dategetter(int index) {
    if (index == 0) {
      return 31;
    } else if (index == 1) {
      return 1;
    } else if (index == 2) {
      return 2;
    } else if (index == 3) {
      return 3;
    }
    return 0;
  }
}
