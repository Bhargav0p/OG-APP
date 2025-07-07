import 'package:apogee_2022/screens/events/repository/model/miscEventResult.dart';
import 'package:apogee_2022/screens/food_stalls/repo/model/food_stall_model.dart';
import 'package:apogee_2022/screens/login/view/login_screen_view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import '../provider/user_details_model.dart';

//afterwards in the app use userDetailsViewModel().userDetails.userId to access

class UserDetailsViewModel {
  static UserDetails userDetails = UserDetails();
  final storage = const FlutterSecureStorage();

  Future<void> loadDetails() async {
    print('load details function called');
    userDetails.username = await storage.read(key: 'username');
    userDetails.Bearer = await storage.read(key: 'Bearer');
    userDetails.userID = await storage.read(key: 'userid');
    userDetails.referralCode = await storage.read(key: 'referralcode');
    userDetails.isBitsian =
        await storage.read(key: 'isBitsian') == 'true' ? true : false;
    userDetails.doesUserExist =
        await storage.read(key: "doesUserExist") == 'true' ? true : false;
    userDetails.qrCode = await storage.read(key: 'qrcode');
    userDetails.photoUrl = await storage.read(key: 'photoUrl');
    // notifyListeners();
  }

  Future<bool> userCheck() async {
    await loadDetails();
    if (userDetails.doesUserExist == true && userDetails.Bearer != null) {
      print('user exists');
      return true;
    }
    print('user does not exist');
    print(userDetails.doesUserExist);
    print(userDetails.Bearer);
    return false;
  }

  Future<void> removeUser() async {
    userDetails.username = null;
    userDetails.userID = null;
    userDetails.referralCode = null;
    userDetails.qrCode = null;
    userDetails.doesUserExist = null;
    userDetails.isBitsian = null;
    userDetails.Bearer = null;
    userDetails.photoUrl = null;
    await storage.deleteAll();
    final _box = Hive.box<MiscEventList>('miscEventListBox');
    final _box1 = Hive.box<MiscEventCatList>('miscEventCatBox');
    final _box2 = Hive.box<FoodStallList>('foodStallBox');
    final _box3 = Hive.box('firstRun');
    final _box4 = Hive.box('cartBox');
    await _box.clear();
    await _box1.clear();
    await _box2.clear();
    await _box3.clear();
    await _box4.clear();
    try {
      await googleSignIn.signOut();
    } catch (e) {
      print(e);
    }
  }
}
