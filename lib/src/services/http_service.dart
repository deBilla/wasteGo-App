import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:wastego/src/waste_item_feature/waste_item.dart';

class HttpService {
  final String backendHost = "https://wastego-api.onrender.com/";

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

  Future<List<dynamic>> uploadImage(File image) async {
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
        var jsonResponse = await response.stream.bytesToString();
        var decodedResponse = jsonDecode(jsonResponse);

        // Access the data from the JSON response
        var data = decodedResponse['labels'];
        var jsonDecodedData = jsonDecode(data);
        var clarifai = jsonDecodedData['clarifai'];
        var labels = clarifai['items'];
        return labels;
      } else {
        return [];
      }
    } catch (e) {
      print('Error uploading image: $e');
      return [];
    }
  }
}
