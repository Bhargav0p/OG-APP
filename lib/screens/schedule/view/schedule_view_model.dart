import 'package:hive/hive.dart';

import '../../events/repository/model/miscEventResult.dart';

class ScheduleViewModel {
  static MiscEventList scheduleList = MiscEventList([]);
  static Map<int, List<int>> scheduleEventSortedMap = {};
  final _box = Hive.box<MiscEventList>('miscEventListBox');

  Future<void> storeInBox(
      MiscEventData miscEventData, List<MiscEventData> screenSchedule) async {
    scheduleList.events?.add(miscEventData);
    await _box.put('b', MiscEventList(scheduleList.events));
  }

  Future<void> removefrombox(
    List<MiscEventData> screenSchedule,
    MiscEventData miscEventData,
  ) async {
    scheduleList.events?.remove(miscEventData);
    await _box.put('b', MiscEventList(scheduleList.events));
  }

  Future<bool> readFromBox() async {
    scheduleList = _box.get("b") ?? MiscEventList([]);

    scheduleEventSortedMap = {};
    int indexPosition = 0;
    for (MiscEventData miscevent in scheduleList.events ?? []) {
      String a = miscevent.date_time ?? '2022-11-23T19:42:24z';

      try {
        var p = DateTime.parse(a);
        if (!(scheduleEventSortedMap.containsKey(p.day))) {
          scheduleEventSortedMap.putIfAbsent(p.day, () => [indexPosition]);
        } else {
          scheduleEventSortedMap.update(p.day, (oldList) {
            oldList.add(indexPosition);
            return oldList;
          });
        }
      } catch (e) {
        //TBA
        if (!(scheduleEventSortedMap.containsKey(31))) {
          scheduleEventSortedMap.putIfAbsent(31, () => [indexPosition]);
        } else {
          scheduleEventSortedMap.update(31, (oldList) {
            oldList.add(indexPosition);
            return oldList;
          });
        }
      }
      indexPosition++;
    }
    // statusInt = 1;
    // status.notifyListeners();
    return true;
  }

  List<MiscEventData> retrieveDayMiscEventData(int dayNo) {
    List<MiscEventData> assortedMiscEventList = [];
    if (scheduleEventSortedMap.containsKey(dayNo)) {
      for (var element in scheduleEventSortedMap[dayNo] ?? []) {
        assortedMiscEventList.add(scheduleList.events![element]);
      }
    }
    assortedMiscEventList.sort((a, b) => a.date_time!.compareTo(b.date_time!));
    return assortedMiscEventList;
  }

  List<MiscEventData> retrieveScheduleList() {
    return scheduleList.events ?? [];
  }

  bool checkSaved(MiscEventData miscEventData) {
    return scheduleList.events!.contains(miscEventData);
  }
}
