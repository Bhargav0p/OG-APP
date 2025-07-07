import 'package:apogee_2022/screens/schedule/view/schedule_view_model.dart';
import 'package:apogee_2022/utils/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/apogee_snackbar.dart';
import '../repository/model/miscEventResult.dart';

class EventBlock extends StatefulWidget {
  EventBlock(
      {Key? key,
      required this.time,
      required this.eventName,
      required this.eventDescription,
      required this.eventConductor,
      required this.eventLocation,
      required this.eventData,
      required this.scheduleList})
      : super(key: key);
  String? time;
  String? eventName;
  String? eventDescription;
  String? eventConductor;
  String? eventLocation;
  MiscEventData eventData;
  List<MiscEventData> scheduleList;

  @override
  State<EventBlock> createState() => _EventBlockState();
}

class _EventBlockState extends State<EventBlock> {
  String removeHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  bool isExpanded = false;
  bool isNameExpanded = false;
  final ScrollController _controllerOne = ScrollController();
  late bool isSaved;
  late bool isLong;
  late bool isNameLong;

  ScheduleViewModel scheduleViewModel = ScheduleViewModel();

  @override
  Widget build(BuildContext context) {
    isSaved = scheduleViewModel.checkSaved(widget.eventData);
    print(widget.eventData.name);
    isLong = (widget.eventDescription == null)
        ? false
        : (widget.eventDescription!.length > 172);
    isNameLong =
        (widget.eventName == null) ? false : (widget.eventName!.length > 30);
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: const Color.fromRGBO(54, 56, 72, 1),
            ),
            // height: 290.h,
            // width: 267.w,
            child: Padding(
              padding: EdgeInsets.only(left: 24.w, top: 20.h, right: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (isNameLong) {
                            {
                              setState(() {
                                isNameExpanded = !isNameExpanded;
                              });
                            }
                          }
                        },
                        child: SizedBox(
                          width: 200.w,
                          child: !isNameLong
                              ? Text('${widget.eventName}',
                                  style: GoogleFonts.notoSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24.sp,
                                  ))
                              : isNameExpanded
                                  ? Padding(
                                      padding: EdgeInsets.only(right: 0.w),
                                      child: Text(
                                        removeHtmlTags(widget.eventName!),
                                        style: GoogleFonts.notoSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24.sp,
                                        ),
                                      ),
                                    )
                                  : RichText(
                                      text: TextSpan(
                                        text: (widget.eventName!)
                                            .substring(0, 20),
                                        style: GoogleFonts.notoSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24.sp,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: ' ...see more',
                                              style: GoogleFonts.notoSans(
                                                color: const Color.fromRGBO(
                                                    152, 85, 217, 1),
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14.sp,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  setState(() {
                                                    isNameExpanded = true;
                                                  });
                                                }),
                                        ],
                                      ),
                                    ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () async {
                            isSaved = !isSaved;
                            if (isSaved) {
                              await scheduleViewModel.storeInBox(
                                  widget.eventData, widget.scheduleList);
                              {
                                var snackBar = CustomSnackBar().apogeeSnackBar(
                                    'Event has been added to your schedule');
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } else {
                              await scheduleViewModel.removefrombox(
                                  widget.scheduleList, widget.eventData);
                              {
                                var snackBar = CustomSnackBar().apogeeSnackBar(
                                    'Event has been removed from your schedule');
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                            setState(() {});
                          },
                          child: isSaved
                              ? const Icon(
                                  Icons.bookmark_sharp,
                                  color: Color.fromRGBO(253, 219, 67, 1),
                                )
                              : const Icon(
                                  Icons.bookmark_border_sharp,
                                  color: Color.fromRGBO(253, 219, 67, 1),
                                ))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
                    child: widget.eventConductor != 'TBA'
                        ? Text(
                            '${widget.eventConductor}',
                            style: GoogleFonts.notoSans(
                              color: const Color.fromRGBO(253, 219, 67, 1),
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),

                          )
                        : Container(),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (isLong) {
                        {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        }
                      }
                    },
                    child: !isLong
                        ? Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child:
                                Text(removeHtmlTags(widget.eventDescription!),
                                    style: GoogleFonts.notoSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14.sp,
                                    )),
                          )
                        : isExpanded
                            ? widget.eventDescription!.length < 400
                                ? Padding(
                                    padding: EdgeInsets.only(right: 0.w),
                                    child: Text(
                                      removeHtmlTags(widget.eventDescription!),
                                      style: GoogleFonts.notoSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(right: 15.w),
                                    child: RawScrollbar(
                                        padding: EdgeInsets.zero,
                                        controller: _controllerOne,
                                        thumbVisibility: true,
                                        thickness: 2.w,
                                        //minThumbLength: 45.h,
                                        thumbColor: Colors.white,
                                        scrollbarOrientation:
                                            ScrollbarOrientation.right,
                                        child: Container(
                                          padding: EdgeInsets.only(right: 15.w),
                                          height: 240.h,
                                          child: ListView(
                                            padding: EdgeInsets.zero,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            controller: _controllerOne,
                                            children: [
                                              Text(
                                                removeHtmlTags(
                                                    widget.eventDescription!),
                                                style: GoogleFonts.notoSans(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14.sp,
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                  )
                            : Padding(
                                padding: EdgeInsets.only(right: 25.w),
                                child: RichText(
                                  text: TextSpan(
                                    text: (removeHtmlTags(
                                            widget.eventDescription!))
                                        .substring(0, 160),
                                    style: GoogleFonts.notoSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14.sp,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ' ...see more',
                                          style: GoogleFonts.notoSans(
                                            color: const Color.fromRGBO(
                                                152, 85, 217, 1),
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14.sp,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              setState(() {
                                                isExpanded = true;
                                              });
                                            }),
                                    ],
                                  ),
                                ),
                              ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20.h, 0, 20.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          convertTime(widget.time!),
                          style: GoogleFonts.notoSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 14.sp,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Container(
                            width: 70.w,
                            child: Center(
                              child: Text(
                                '${widget.eventLocation}',
                                style: GoogleFonts.notoSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Positioned(
          //   bottom: 36.h,
          //   child: Container(
          //     width: 290.w,
          //     child: Padding(
          //       padding:  EdgeInsets.symmetric(horizontal: 40.w),
          //       child:
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  String convertTime(String timeString) {
    final time =
        TimeOfDay.fromDateTime(DateTime.parse('2022-03-29 $timeString'));
    final hour = time.hourOfPeriod;
    final minute = time.minute;
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '${hour}:${minute.toString().padLeft(2, '0')} ${period}';
  }
}
