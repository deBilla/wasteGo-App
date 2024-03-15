import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:wastego/src/waste_item_feature/waste_item.dart';

class HttpService {
  final String backendHost = "https://6792-2406-3003-2003-19dd-2533-3c36-8144-e32c.ngrok-free.app/";

  Future<List<WasteItem>> getWasteItems() async {
    Response res = await get(Uri.parse("${backendHost}wasteItems"));
 
    if (res.statusCode == 200) {
      final obj = jsonDecode(res.body);
      final receivedWasteItemList = obj['data'];
      List<WasteItem> wasteItems = List.empty(growable: true);

      for (int i = 0; i < receivedWasteItemList.length; i++) {
        WasteItem wasteItem = WasteItem.fromJson(receivedWasteItemList[i]);
        wasteItems.add(wasteItem);
      }

      return wasteItems;
    } else {
      return [];
    }
  }

  Future<bool> deleteWasteItem(id) async {
    // ignore: prefer_interpolation_to_compose_strings
    String url = "${backendHost}wasteItem/" + id.toString();

    Response res = await delete(Uri.parse(url));

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createWasteItem(String name, String type, int quantity) async {
    Response res = await post(
      Uri.parse('${backendHost}wasteItem'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'Name': name,
        'Type': type,
        'Quantity': quantity,
      }),
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> uploadImage(File image) async {
    try {
      var request = MultipartRequest('POST', Uri.parse('${backendHost}wasteItem/uploadImage'));
      request.files.add(MultipartFile(
        'file',
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: image.path.split('/').last,
      ));
      var response = await request.send();
      
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return false;
    }
  }
}
