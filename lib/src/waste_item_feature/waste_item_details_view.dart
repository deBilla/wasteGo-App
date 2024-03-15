import 'package:flutter/material.dart';
import 'package:wastego/src/services/http_service.dart';
import 'package:wastego/src/waste_item_feature/waste_item.dart';
import 'package:wastego/src/waste_item_feature/waste_item_list_view.dart';

/// Displays detailed information about a SampleItem.
class WasteItemDetailsView extends StatelessWidget {
  final HttpService httpService = HttpService();
  WasteItemDetailsView({super.key, required this.item});

  final WasteItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Item Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              bool isDeleted = await httpService.deleteWasteItem(item.id);
              if (isDeleted) {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WasteItemListView(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Waste Item: ${item.name}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              'Quantity: ${item.quantity}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
