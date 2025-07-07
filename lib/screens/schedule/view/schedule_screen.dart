
import 'package:apogee_2022/screens/events/repository/model/miscEventResult.dart';
import 'package:apogee_2022/screens/events/view/event_block.dart';
import 'package:apogee_2022/screens/events/view_model/misc_events_view_model.dart';
import 'package:apogee_2022/screens/schedule/view/schedule_screen_controller.dart';
import 'package:apogee_2022/screens/schedule/view/schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/error_dialogue.dart';
import '../../../widgets/loader.dart';


class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  FocusNode focusNode = FocusNode();
  int isSelected = 0;
  ScheduleViewModel scheduleViewModel = ScheduleViewModel();
  bool isLoading = true;
  List<MiscEventData> currentDayMiscEventList = [];
  List<MiscEventData> catFilteredMiscEventList = [];
  List<MiscEventCategory> miscEventCategoryList = [];
  int? filterIndex;
  void checkMiscEventsResult() {
    if (MiscEventsViewModel.error == null) {
      if (mounted) {
        setState(() {
          updateCurrentDayMiscEventList();
          print('hi1');
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

  void updateCurrentDayMiscEventList() {
    print(ScheduleScreenController.selected_Tab.value);
    currentDayMiscEventList = scheduleViewModel
        .retrieveDayMiscEventData(ScheduleScreenController.selected_Tab.value);
  }

  bool emptyListHandler() {
    // print('the status is list emptiness is ${currentDayMiscEventList.isEmpty}');
    return currentDayMiscEventList.isEmpty;
  }

  List<MiscEventData> requiredListHandler() {
    return currentDayMiscEventList;
  }

  @override
  void initState() {
    ScheduleScreenController.selected_Tab.value = dategetter(0);
    scheduleViewModel.readFromBox();
    setState(() {
      updateCurrentDayMiscEventList();
    });
    isLoading = false;
    // ScheduleScreenController.selectedTab.addFner(() {
    //   if (mounted) setState(() {});
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // scheduleViewModel.readFromBox();
      setState(() {});
      if (MiscEventsViewModel.error == "403") {}
    });

    ScheduleScreenController.selected_Tab.addListener(() {
      if (mounted) {
        setState(() {
          updateCurrentDayMiscEventList();
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
            ScheduleScreenController.selected_Tab.value = dategetter(index);
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

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(19, 21, 27, 1),
        body: !isLoading
            ? Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 93.h, left: 24.w, right: 28.w),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        ScheduleScreenController.selected_Tab.value = dategetter(0);
                        Navigator.pop(context);

                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.white,
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      'Your Schedule',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 36.sp,
                          color: Colors.white,
                          fontFamily: 'sui-generis'),
                    ),
                  ),
                ],
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
                    height: 665.h,
                    child: !emptyListHandler()
                        ? ListView.builder(
                        padding: EdgeInsets.only(top: 25.h),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        itemCount: requiredListHandler().length,
                        itemBuilder: (context, index) {
                          return EventBlock(
                            time: currentDayMiscEventList[index].time ??
                                'TBA',
                            eventName:
                            currentDayMiscEventList[index].name,
                            eventDescription:
                            currentDayMiscEventList[index].about,
                            eventConductor:
                            currentDayMiscEventList[index]
                                .organiser,
                            eventLocation:
                            currentDayMiscEventList[index]
                                .venue_name,
                            eventData: currentDayMiscEventList[index],
                            scheduleList: scheduleViewModel
                                .retrieveScheduleList(),
                          );
                        })  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset('assets/images/no_events.svg'),
                          Padding(
                            padding: EdgeInsets.only(bottom: 130.h),
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
                    )
                )

              ],
            )
          ],
        )
            : SingleChildScrollView(
            child: Center(
              child: SizedBox(
                height: 1.sh,
                width: 1.sw,
                child: Loader(),
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
