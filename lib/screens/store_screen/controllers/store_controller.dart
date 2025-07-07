import 'package:apogee_2022/screens/store_screen/controllers/api_calls.dart';
import 'package:apogee_2022/screens/store_screen/data/models/showsData.dart';
import 'package:apogee_2022/screens/store_screen/data/models/signedTicketsData.dart';
import 'package:apogee_2022/screens/store_screen/data/models/ticketPostBody.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

StoreController storeController = StoreController();

class StoreController extends ChangeNotifier {
  static AllShowsData allShowsData = AllShowsData([], []);
  static SignedTickets signedTickets = SignedTickets();
  static bool isCancelled = false;
  ValueNotifier<bool> isStoreScreenLoading = ValueNotifier(true);
  static ValueNotifier<int> selectedType = ValueNotifier(0);

  void selectionChange(int newNumber) {
    selectedType.value = newNumber;
  }

  Future<void> initController() async {
    allShowsData = AllShowsData([], []);
    signedTickets = SignedTickets();
    allShowsData = await ApiCalls().getAllShows();
    signedTickets = await ApiCalls().getSigned();
  }

  Future<void> refreshController() async {
    await initController();
    notifyListeners();
  }

  List<StoreItemData> getProfShowList() {
    if (allShowsData.shows != null) {
      return allShowsData.shows!
          .where((element) =>
              (element.is_merch == false && element.isSpeaker == false))
          .toList();
    } else {
      return [];
    }
  }

  List<StoreItemData> getMerchList() {
    if (allShowsData.shows != null) {
      return allShowsData.shows!
          .where((element) =>
              (element.is_merch == true && element.isSpeaker == false))
          .toList();
    } else {
      return [];
    }
  }

  List<StoreItemData> getSpeakerList() {
    if (allShowsData.shows != null) {
      return allShowsData.shows!
          .where((element) =>
              (element.isSpeaker == true && element.is_merch == false))
          .toList();
    } else {
      return [];
    }
  }

  int? getUsedTickets(int id) {
    try {
      return signedTickets.shows!
          .firstWhere((element) => (element.id == id))
          .used_count;
    } catch (e) {
      return 0;
    }
  }

  int? getUnusedTickets(int id) {
    try {
      return signedTickets.shows!
          .firstWhere((element) => (element.id == id))
          .unused_count;
    } catch (e) {
      return 0;
    }
  }

  int? getPrice(int id) {
    if (allShowsData.shows != null) {
      return allShowsData.shows!
          .firstWhere((element) => (element.id == id))
          .price;
    } else {
      return 0;
    }
  }

  Future<void> buyTicket(int id, int amount) async {
    TicketPostBody ticketPostBody =
        TicketPostBody(individual: {"$id": amount}, combos: {});
    await ApiCalls().buyTicket(ticketPostBody);
  }
}
