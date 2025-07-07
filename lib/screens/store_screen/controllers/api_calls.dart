import 'package:apogee_2022/screens/store_screen/data/models/showsData.dart';
import 'package:apogee_2022/screens/store_screen/data/models/ticketPostBody.dart';
import 'package:apogee_2022/screens/store_screen/data/retrofit/getAllShows.dart';
import 'package:apogee_2022/screens/store_screen/data/retrofit/getSignedTickets.dart';
import 'package:apogee_2022/screens/store_screen/data/retrofit/postTicket.dart';
import 'package:dio/dio.dart';
import '../../../provider/user_details_viewmodel.dart';
import '../../../utils/error_messages.dart';
import '../data/models/signedTicketsData.dart';

class ApiCalls {
  Future<AllShowsData> getAllShows() async {
    final dio = Dio();
    final client = AllShowsRestClient(dio);
    String jwt = UserDetailsViewModel.userDetails.Bearer!;
    try {
      AllShowsData allShowsData = await client.getAllShows("Bearer $jwt");
      return allShowsData;
    } catch (e) {
      if (e.runtimeType == DioError) {
        if ((e as DioError).response == null) {
          throw Exception(ErrorMessages.noInternet);
        }
        throw Exception(e.response!.data["display_message"]);
      } else {
        throw Exception(e);
      }
    }
  }

  Future<SignedTickets> getSigned() async {
    final dio = Dio();
    final client = SignedTicketsRestClient(dio);
    String jwt = UserDetailsViewModel.userDetails.Bearer!;
    try {
      SignedTickets signedTickets =
          await client.getCurrentTickets("Bearer $jwt");
      return signedTickets;
    } catch (e) {
      if (e.runtimeType == DioError) {
        if ((e as DioError).response == null) {
          throw Exception(ErrorMessages.noInternet);
        }
        throw Exception(e.response!.data["display_message"]);
      } else {
        throw Exception(e);
      }
    }
  }

  Future<void> buyTicket(TicketPostBody ticketPostBody) async {
    final dio = Dio();
    final client = PostTicketRestClient(dio);
    String jwt = UserDetailsViewModel.userDetails.Bearer!;
    try {
      await client.postTicket("Bearer $jwt", ticketPostBody);
    } catch (e) {
      if (e.runtimeType == DioError) {
        if ((e as DioError).response == null) {
          throw Exception(ErrorMessages.noInternet);
        }
        throw Exception(e.response!.data["display_message"]);
      } else {
        throw Exception(e);
      }
    }
  }
}
