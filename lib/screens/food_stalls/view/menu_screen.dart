import 'dart:ui';

import 'package:apogee_2022/utils/scroll_remover.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import '../../../widgets/loader.dart';
import '../../cart/cartscreen.dart';
import '/screens/food_stalls/repo/model/food_stall_model.dart' as menu;
import '/utils/ui_utils.dart';
import '../view_model/menu_screen_viewmodel.dart';
import 'menu_add_buttons.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen(
      {Key? key,
        required this.menuItemList,
        required this.foodStallName,
        required this.image,
        required this.foodStallId})
      : super(key: key);
  List<menu.MenuItem> menuItemList;
  String foodStallName;
  String image;
  int foodStallId;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<menu.MenuItem> menuItemsFiltered = [];
  bool isNotEmpty = true;
  FocusNode searchFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  Map<int, int> menuItemsAmount = {};
  TextEditingController searchController = TextEditingController();

  void createSearchFilteredList(String? query) {
    menuItemsFiltered =
        MenuScreenViewModel().searchList(query ?? "", widget.menuItemList);
  }

  void makeMenuList() {
    menuItemsFiltered = widget.menuItemList;
    menuItemsAmount =
        MenuScreenViewModel().populateListFromHive(menuItemsFiltered);
  }

  //TODO: add a foodstall banner image in backend
  @override
  void initState() {
    makeMenuList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(9, 19, 25, 1),
        body: Stack(children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50.h, left: 20.w, right: 20.w),
                child: Center(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            // Image.asset('assets/images/pizza.png'),
                            CachedNetworkImage(
                              placeholder: (context, url) => SizedBox(
                                  height: 189.h,
                                  width: 390.w,
                                  child: const Loader()),
                              imageUrl: widget.image,
                            ),
                            Container(
                              height: 189.h,
                              width: 390.w,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.6281, 0.8156, 1.0],
                                  colors: [
                                    Colors.transparent,
                                    Color.fromRGBO(0, 0, 0, 0.602241),
                                    Colors.black,
                                  ],
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Stack(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)),
                              ),
                              width: 388.w,
                              height: 97.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16.h, left: 20.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [],
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.w, top: 20.h),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(30, 30, 30, 1),
                                borderRadius: BorderRadius.circular(5)),
                            height: 50.h,
                            width: 50.w,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Color.fromRGBO(198, 198, 198, 1),
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.w, top: 20.h),
                // child: RichText(
                //     text: TextSpan(children: [
                //       TextSpan(
                //
                //           text: widget.foodStallName,
                //
                //           style: GoogleFonts.openSans(
                //               fontSize: 28.sp,
                //               color: Colors.white,
                //               fontWeight: FontWeight.w600)),
                //     ])),
                child: Text(
                  '${widget.foodStallName}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 36.sp,
                      color: Colors.white,
                      fontFamily: 'sui-generis'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.h, left: 20.w, right: 20.w),
                child: Container(
                  height: 47.h,
                  width: 388.w,
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //     color: const Color.fromRGBO(248, 216, 72, 0.45)),
                    // boxShadow: const [
                    //   BoxShadow(
                    //       color: Color.fromRGBO(0, 0, 0, 0.25),
                    //       offset: Offset(0, 2.36364),
                    //       blurRadius: 4.72727)
                    // ],
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: const LinearGradient(
                          colors: <Color>[
                            Color.fromRGBO(62, 64, 82, 1),
                            Color.fromRGBO(57, 59, 77, 0.85)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(17.22.w, 0, 16.41.w, 0),
                          child: const Center(
                              child: Icon(
                                Icons.search,
                                color: Color.fromRGBO(192, 192, 192, 1),
                              )),
                        ),
                        Expanded(
                          child: Center(
                            child: Form(
                              key: _formKey,
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    createSearchFilteredList(value);
                                  });
                                },
                                controller: searchController,
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 14.sp),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelStyle:
                                  GoogleFonts.openSans(color: Colors.white),
                                  hintText: "Search",
                                  hintStyle: GoogleFonts.openSans(
                                      color: Color.fromRGBO(168, 168, 168, 1),
                                      fontSize: 16.sp),
                                  suffixIcon: IconButton(
                                      splashColor: Colors.transparent,
                                      onPressed: () {
                                        searchController.clear();
                                        setState(() {
                                          createSearchFilteredList("");
                                          searchFocusNode.unfocus();
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        });
                                      },
                                      icon: const Icon(Icons.close,
                                          color:
                                          Color.fromRGBO(192, 192, 192, 1),
                                          size: 16)),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box('cartBox').listenable(),
                  builder: (context, Box box, child) {
                    menuItemsAmount = MenuScreenViewModel()
                        .populateListFromHive(menuItemsFiltered);
                    return ScrollConfiguration(
                      behavior: CustomScrollBehavior(),
                      child: Padding(
                        padding: EdgeInsets.only(top: 28.h),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemCount: menuItemsFiltered.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 8.h, left: 20.w, right: 20.w),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.r),
                                        color: Color.fromRGBO(28, 30, 45, 1),
                                      ),
                                      height: 97.h,
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
                                                      37, 0, 20.1, 0),
                                                  child: Center(
                                                      child: SvgPicture.asset(
                                                        "assets/icons/nonveg.svg",
                                                        color: menuItemsFiltered[
                                                        index]
                                                            .is_veg
                                                            ? Colors.green
                                                            : Colors.red,
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Text(
                                                        menuItemsFiltered[
                                                        index]
                                                            .name,
                                                        style: GoogleFonts
                                                            .notoSans(
                                                            color: Colors
                                                                .white,
                                                            fontSize:
                                                            16.h,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
                                                      ),
                                                      Text(
                                                        "₹${menuItemsFiltered[index].price}",
                                                        style: GoogleFonts.openSans(
                                                            fontSize: 16.h,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                            color: const Color
                                                                .fromRGBO(
                                                                100,
                                                                100,
                                                                100,
                                                                1)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            EdgeInsets.only(right: 37.w),
                                            child: AddButton(
                                              is_available:
                                              menuItemsFiltered[index]
                                                  .is_available,
                                              isVeg: menuItemsFiltered[index]
                                                  .is_veg,
                                              menuItemName:
                                              menuItemsFiltered[index]
                                                  .name,
                                              amount: menuItemsAmount[
                                              menuItemsFiltered[index]
                                                  .id]!,
                                              foodStallId: widget.foodStallId,
                                              price: menuItemsFiltered[index]
                                                  .price,
                                              menuItemId:
                                              menuItemsFiltered[index].id,
                                              foodStallName:
                                              widget.foodStallName,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: Hive.box("cartBox").listenable(),
            builder: (context, Box box, child) {
              int total = MenuScreenViewModel().getTotalValue();
              if (total != 0) {
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartScreen()));
                    },
                    child: Container(
                      // alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width,
                      height: 70.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Color.fromRGBO(103, 44, 160, 0.9),
                          Color.fromRGBO(77, 0, 151, 0.9),
                        ]),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            blurRadius: 4.38,
                            offset: Offset(0, 4.38),
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.r),
                            topRight: Radius.circular(15.r)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'View Cart',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 20.w,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 6.w),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 13,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              '₹ $total',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 19.w,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (!isNotEmpty) {
                return Container();
              } else {
                return Container();
              }
            },
          )
        ]),
      ),
    );
  }
}
