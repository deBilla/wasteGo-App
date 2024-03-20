import 'package:flutter/material.dart';
import 'package:wastego/src/home_page_view.dart';
import 'package:wastego/src/services/http_service.dart';
import 'package:wastego/src/waste_item_feature/waste_item.dart';

/// Displays detailed information about a SampleItem.
class WasteItemDetailsView extends StatelessWidget {
  final HttpService httpService = HttpService();
  WasteItemDetailsView({super.key, required this.item});

  final WasteItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waste Item ${item.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              bool isDeleted = await httpService.deleteWasteItem(item.id);
              if (isDeleted) {
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePageView(),
                  ),
                );
              }
            },
          ),
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePageView(),
                  ),
                );
              }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Waste Type: ${item.type}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Quantity: ${item.quantity}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'User ID: ${item.userId}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Placeholder(
                    fallbackWidth: 200,
                    fallbackHeight: 200,
                    color: Colors
                        .grey,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
