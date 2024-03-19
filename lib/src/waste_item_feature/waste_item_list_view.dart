import 'package:flutter/material.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:wastego/src/services/http_service.dart';
import 'package:wastego/src/waste_item_feature/waste_item_details_view.dart';
import 'waste_item.dart';

class WasteItemListView extends StatelessWidget {
  final HttpService httpService = HttpService();
  final GoogleSignInUserData? currentUser;
  WasteItemListView({super.key, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await httpService.getWasteItems(currentUser!.id);
      },
      child: FutureBuilder(
        future: httpService.getWasteItems(currentUser!.id),
        builder:
            (BuildContext context, AsyncSnapshot<List<WasteItem>> snapshot) {
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
                      Navigator.pushReplacement(
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
    );
  }
}
