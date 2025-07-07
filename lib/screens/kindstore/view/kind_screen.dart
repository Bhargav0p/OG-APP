import 'package:apogee_2022/resources/resources.dart';
import 'package:apogee_2022/screens/kindstore/view_model/kind_store_catalog_view_model.dart';
import 'package:apogee_2022/utils/colors.dart';
import 'package:apogee_2022/widgets/error_dialogue.dart';
import 'package:apogee_2022/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class KindScreen extends StatefulWidget {
  const KindScreen({Key? key}) : super(key: key);

  @override
  State<KindScreen> createState() => _KindScreenState();
}

class _KindScreenState extends State<KindScreen> {
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  Future<void> onRefresh() async {
    await KindStoreViewModel().getKindStoreCatalogItems();
    setState(() {});
  }

  Future<void> onInit() async {
    await KindStoreViewModel().getKindStoreCatalogItems();
    isLoading.value = false;
  }

  @override
  void initState() {
    onInit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
          color: ApogeeColors.purpleButtonColor,
          onRefresh: onRefresh,
          child: ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (context, value, child) {
                return value
                    ? Loader()
                    : Stack(
                        children: KindStoreViewModel
                                    .kindItemsResult.items_details!.isEmpty ||
                                KindStoreViewModel.error != null
                            ? [
                                Center(
                                  child: ErrorDialog(
                                    errorMessage: KindStoreViewModel.error ??
                                        'Store Catalog will be updated soon.',
                                  ),
                                )
                              ]
                            : [
                                Image.asset(
                                    'assets/images/purpleGradientIndSim.png',
                                    fit: BoxFit.cover,
                                    height: 575.h,
                                    width: 575.h),
                                Column(
                                  children: [
                                    SizedBox(height: 72.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 24.h, right: 24.h),
                                            child: SvgPicture.asset(
                                              ImageAssets.leftArrow,
                                              height: 24.h,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Kind Store',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: const Color.fromRGBO(
                                                  218, 218, 218, 1),
                                              fontFamily: 'sui-generis',
                                              fontSize: 28.sp,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w400,
                                              height: 1),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: GridView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        padding: EdgeInsets.only(
                                            left: 23.00.w,
                                            right: 23.00.w,
                                            top: 24.h),
                                        itemCount: KindStoreViewModel
                                            .kindItemsResult
                                            .items_details!
                                            .length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.65,
                                          crossAxisSpacing: 20.w,
                                          mainAxisSpacing: 24.h,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            width: 179.w,
                                            height: 270.h,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.r),
                                              ),
                                              color: const Color.fromRGBO(
                                                  0, 0, 0, 0.10000000149011612),
                                              border: Border.all(
                                                color: const Color.fromRGBO(
                                                    152, 85, 217, 1),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 9.h),
                                                Container(
                                                  width: 152.w,
                                                  height: 183.h,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                          10.735174179077148.r),
                                                    ),
                                                    color: const Color.fromRGBO(
                                                        15, 16, 20, 1),
                                                  ),
                                                  child: Image.network(
                                                    KindStoreViewModel
                                                            .kindItemsResult
                                                            .items_details![
                                                                index]
                                                            .image ??
                                                        "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Error.svg/1200px-Error.svg.png",
                                                    width: 150.w,
                                                    height: 150.h,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            Colors
                                                                .red, // set the color of the loading indicator
                                                          ),
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: 15.h),
                                                // Figma Flutter Generator BoseheadphonesWidget - TEXT
                                                Text(
                                                    KindStoreViewModel
                                                            .kindItemsResult
                                                            .items_details![
                                                                index]
                                                            .name ??
                                                        "NA",
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts
                                                        .notoSansGujarati(
                                                            color: const Color(
                                                                0xFF9855D9),
                                                            fontSize: 16.sp,
                                                            letterSpacing:
                                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            height: 1.5)),
                                                SizedBox(height: 15.22.h),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 17.67.w),
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        ImageAssets.handShake,
                                                        height: 20.h,
                                                        width: 20.w,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 3.23.w),
                                                      Text(
                                                        KindStoreViewModel
                                                            .kindItemsResult
                                                            .items_details![
                                                                index]
                                                            .price
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: GoogleFonts
                                                            .notoSansGujarati(
                                                                color: const Color(
                                                                    0xFFFAFAFA),
                                                                fontSize: 15.sp,
                                                                letterSpacing:
                                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                height: 1.5),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ]);
              })),
    );
  }
}
