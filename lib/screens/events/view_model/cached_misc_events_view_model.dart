import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../repository/model/miscEventResult.dart';
import 'misc_events_view_model.dart';

class CachedMiscEventsViewModel {
  static String? error;
  static List<MiscEventData> miscEventList = <MiscEventData>[];
  static List<MiscEventCategory> miscCatList = <MiscEventCategory>[];
  static Map<int, List<int>> miscEventSortedMap = {}; //19:[1,3,4,6],20:[]....
  final _box = Hive.box<MiscEventList>('miscEventListBox');
  final _box1 = Hive.box<MiscEventCatList>('miscEventCatBox');

  static ChangeNotifier status =
  ChangeNotifier(); //0 is initial state, 1 is its in hive and read from hive, 2 is read from network call
  static int statusInt =
  0; //0 is initial state, 1 is its in hive and read from hive, 2 is read from network call

  mergedRetriveMiscResult() {
    readFromBox();
    retrieveMiscEventResult();
  }

  Future<void> retrieveMiscEventResult() async {
    print('goes in network call');
    List<MiscEventData> networkMiscEventList = [];
    Map<int, List<int>> networkMiscEventSortedMap = {};
    List<MiscEventCategory> networkMiscEventCategoryList = [];
    error = null;
    networkMiscEventCategoryList =
    await MiscEventsViewModel().retrieveMiscEventResult();
    int indexPosition = 0;
    for (MiscEventCategory miscEventCategory in networkMiscEventCategoryList) {
      if (miscEventCategory.events != null &&
          miscEventCategory.category_name != 'visitors') {
        for (MiscEventData miscevent in miscEventCategory.events!) {
          String a = miscevent.date_time ?? '2022-11-23T19:42:24z';
          try {
            var p = DateTime.parse(a);
            if (!(networkMiscEventSortedMap.containsKey(p.day))) {
              networkMiscEventSortedMap.putIfAbsent(
                  p.day, () => [indexPosition]);
            } else {
              networkMiscEventSortedMap.update(p.day, (oldList) {
                oldList.add(indexPosition);
                return oldList;
              });
            }
          } catch (e) {
            //TBA
            if (!(networkMiscEventSortedMap.containsKey(31))) {
              networkMiscEventSortedMap.putIfAbsent(31, () => [indexPosition]);
            } else {
              networkMiscEventSortedMap.update(31, (oldList) {
                oldList.add(indexPosition);
                return oldList;
              });
            }
          }
          indexPosition++;
          networkMiscEventList.add(miscevent);
        }
      }
    }

    if (networkMiscEventList.isNotEmpty) {
      miscEventList = networkMiscEventList;
      miscCatList = networkMiscEventCategoryList;
      miscEventSortedMap = networkMiscEventSortedMap;
      statusInt = 2;
      status.notifyListeners();
      print('storing');
      storeInBox();
    }
    print('goes out of network');
    error = MiscEventsViewModel.error;
  }

  Future<void> storeInBox() async {
    await _box.put('a', MiscEventList(miscEventList));
    await _box1.put('a', MiscEventCatList(miscCatList) );


    print('stored, length is');
    print(_box.values.toList().cast<MiscEventList>()[0].events?.length);
    print('read, length is');
    print(_box1.values.toList().cast<MiscEventCatList>()[0].categories?.length);
  }

  Future<bool> readFromBox() async {
    print('goes in local');
    miscEventList = _box.values.toList().cast<MiscEventList>().isNotEmpty
        ? _box.values.toList().cast<MiscEventList>()[0].events ?? []
        : [];
    miscCatList = _box1.values.toList().cast<MiscEventCatList>().isNotEmpty
        ? _box1.values.toList().cast<MiscEventCatList>()[0].categories ?? []
        : [];

    if (miscEventList.isEmpty) {
      print('goes in empty database condition');
      return false;
    }

    miscEventSortedMap = {};
    int indexPosition = 0;
    for (MiscEventData miscevent in miscEventList) {
      String a = miscevent.date_time ?? '2022-11-23T19:42:24z';

      try {
        var p = DateTime.parse(a);
        if (!(miscEventSortedMap.containsKey(p.day))) {
          miscEventSortedMap.putIfAbsent(p.day, () => [indexPosition]);
        } else {
          miscEventSortedMap.update(p.day, (oldList) {
            oldList.add(indexPosition);
            return oldList;
          });
        }
      } catch (e) {
        //TBA
        if (!(miscEventSortedMap.containsKey(31))) {
          miscEventSortedMap.putIfAbsent(31, () => [indexPosition]);
        } else {
          miscEventSortedMap.update(31, (oldList) {
            oldList.add(indexPosition);
            return oldList;
          });
        }
      }
      indexPosition++;
    }
    statusInt = 1;
    status.notifyListeners();
    print('goes out of local');
    return true;
  }

  List<MiscEventData> retrieveSearchMiscEventData(int day_no, String text) {
    List<MiscEventData> searchedMiscEventList = [];
    text = text.toLowerCase();
    if (miscEventSortedMap.containsKey(day_no)) {
      for (int element in miscEventSortedMap[day_no] ?? []) {
        if (((miscEventList[element].name == null)
            ? false
            : miscEventList[element].name!.toLowerCase().contains(text)) ||
            ((miscEventList[element].organiser == null)
                ? false
                : miscEventList[element]
                .organiser!
                .toLowerCase()
                .contains(text)) ||
            ((miscEventList[element].about == null)
                ? false
                : miscEventList[element].about!.toLowerCase().contains(text)))
          searchedMiscEventList.add(miscEventList[element]);
      }
    }
    return searchedMiscEventList;
  }

  List<MiscEventData> retrieveDayMiscEventData(int day_no) {
    List<MiscEventData> assortedMiscEventList = [];
    if (miscEventSortedMap.containsKey(day_no)) {
      for (var element in miscEventSortedMap[day_no] ?? []) {
        assortedMiscEventList.add(miscEventList[element]);
      }
    }
    return assortedMiscEventList;
  }

  List<MiscEventCategory> getEventCategory() {
    return miscCatList;
  }
}
