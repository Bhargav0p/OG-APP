import 'package:flutter/material.dart';

class MiscScreenController {
  static ValueNotifier<int> selectedTab = ValueNotifier(
      (DateTime.now().day <= 3 && DateTime.now().day >= 1 || DateTime.now().day == 31)
          ? (DateTime.now().day)
          : 31);
}
