import 'package:flutter/material.dart';

class ScheduleScreenController {
  static ValueNotifier<int> selected_Tab = ValueNotifier(
      (DateTime.now().day <= 3 && DateTime.now().day >= 1 || DateTime.now().day == 31)
          ? (DateTime.now().day)
          : 31);
}
