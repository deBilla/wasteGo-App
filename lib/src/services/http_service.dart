import 'dart:convert';
import 'package:http/http.dart';
import 'package:wastego/src/waste_item_feature/waste_item.dart';

class HttpService {
  final String wasteItemsURL = "http://localhost:8080/wasteItems";

  Future<List<WasteItem>> getWasteItems() async {
    Response res = await get(Uri.parse(wasteItemsURL));

    if (res.statusCode == 200) {
      final obj = jsonDecode(res.body);
      final receivedWasteItemList = obj['data'];
      List<WasteItem> wasteItems =  List.empty(growable: true);

      for (int i = 0; i < receivedWasteItemList.length; i++) {
        WasteItem wasteItem = WasteItem.fromJson(receivedWasteItemList[i]);
        wasteItems.add(wasteItem);
      }

      return wasteItems;
    } else {
      throw "Unable to retrieve waste items.";
    }
  }
}