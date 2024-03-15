import 'package:flutter/material.dart';
import 'package:wastego/src/services/http_service.dart';
import 'package:wastego/src/waste_item_feature/waste_item_create_view.dart';
import 'package:wastego/src/waste_item_feature/waste_item_details_view.dart';
import 'waste_item.dart';

class WasteItemListView extends StatelessWidget {
  final HttpService httpService = HttpService();
  WasteItemListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Waste Items'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WasteItemCreateView(),
                  ),
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await httpService.getWasteItems();
          },
          child: FutureBuilder(
            future: httpService.getWasteItems(),
            builder: (BuildContext context,
                AsyncSnapshot<List<WasteItem>> snapshot) {
              if (snapshot.hasData) {
                List<WasteItem> wasteItems = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: wasteItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = wasteItems[index];

                    return ListTile(
                        title: Text(item.name),
                        leading: const CircleAvatar(
                          foregroundImage:
                              AssetImage('assets/images/flutter_logo.png'),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WasteItemDetailsView(item: item),
                            ),
                          );
                        });
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }
}
