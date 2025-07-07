import 'package:apogee_2022/screens/events/view/events_view.dart';
import 'package:apogee_2022/screens/food_stalls/view/food_stall_screen.dart';
import 'package:apogee_2022/screens/orders/order_screen.dart';
import 'package:apogee_2022/screens/store_screen/views/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../screens/wallet_screen/view/wallet_screen.dart';
import 'provider/firebase_init_bool.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 2);

  List<Widget> _buildScreens() {
    return [
      const FoodStallScreen(),
      OrdersScreen(key: UniqueKey()),
      const MainEventsScreen(),
      const StoreScreen(),
      const WalletScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset("assets/navbar_icons/stalls_active.svg"),
        inactiveIcon:
            SvgPicture.asset("assets/navbar_icons/stalls_inactive.svg"),
        iconSize: 22.r,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset("assets/navbar_icons/orders_active.svg"),
        inactiveIcon:
            SvgPicture.asset("assets/navbar_icons/order_inactive.svg"),
        iconSize: 22.r,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset("assets/navbar_icons/events_active.svg"),
        inactiveIcon:
            SvgPicture.asset("assets/navbar_icons/events_inactive.svg"),
        iconSize: 22.r,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset("assets/navbar_icons/store_active.svg"),
        inactiveIcon:
            SvgPicture.asset("assets/navbar_icons/store_inactive.svg"),
        iconSize: 22.r,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset("assets/navbar_icons/wallet_active.svg"),
        inactiveIcon:
            SvgPicture.asset("assets/navbar_icons/wallet_inactive.svg"),
        iconSize: 22.r,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: persistentTabController,
      screens: _buildScreens(),
      onItemSelected: (index) {
        if (index == 1) {
          setState(() {
            _controller.index = index;
          });
        }
      },
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: const Color(0xFF1A1C21),
      stateManagement: true,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      hideNavigationBarWhenKeyboardShows: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style12,
    );
    return PersistentTabView.custom(
      context,
      controller: _controller,
      backgroundColor: Colors.transparent,
      itemCount: 5,
      // This is required in case of custom style! Pass the number of items for the nav bar.
      screens: _buildScreens(),
      bottomScreenMargin: 0,
      confineInSafeArea: true,
      stateManagement: true,
      screenTransitionAnimation: const ScreenTransitionAnimation(
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
          animateTabTransition: true),
      onWillPop: (context) async {
        return true;
      },
      customWidget: CustomNavBarWidget(
        // Your custom widget goes here
        items: _navBarsItems(),
        selectedIndex: _controller.index,
        onItemSelected: (index) {
          setState(() {
            _controller.index = index;
          });
        },
      ),
    );
  }
}

class CustomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final List<PersistentBottomNavBarItem>
      items; // NOTE: You CAN declare your own model here instead of `PersistentBottomNavBarItem`.
  final ValueChanged<int> onItemSelected;

  CustomNavBarWidget({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  });

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
    return Flexible(
      child: Container(
        alignment: Alignment.center,
        child: IconTheme(
          data: IconThemeData(
              color: isSelected
                  ? (item.activeColorSecondary ?? item.activeColorPrimary)
                  : item.inactiveColorPrimary ?? item.activeColorPrimary),
          child: isSelected ? item.icon : item.inactiveIcon!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(),
      child: Container(
        // margin: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r)),
            color: const Color(0xff11131a),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.04),
                blurRadius: 5,
                blurStyle: BlurStyle.normal,
                spreadRadius: 0.1,
              )
            ]),
        child: Padding(
          padding:
              EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h, bottom: 10.w),
          child: Container(
            // height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44.r),
              color: const Color(0xff1a1c21),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.map((item) {
                int index = items.indexOf(item);
                return Container(
                  child: Flexible(
                    child: GestureDetector(
                      onTap: () {
                        onItemSelected(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildItem(item, selectedIndex == index),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
