import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wastego/src/services/http_service.dart';
import 'package:wastego/src/waste_item_feature/waste_item_label_result_view.dart';
import 'package:wastego/src/custom_widgets/camera_preview_widget.dart';
import 'package:wastego/src/waste_item_feature/waste_item_create_view.dart';
import 'package:wastego/src/waste_item_feature/waste_item_details_view.dart';
import 'waste_item.dart';
import 'package:camera/camera.dart';

class WasteItemListView extends StatelessWidget {
  final HttpService httpService = HttpService();
  WasteItemListView({super.key});

  void _openCamera(BuildContext context) async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      // Handle no available cameras
      return;
    }

    final camera = cameras.first;
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPreviewWidget(
          camera: camera,
          onImageCaptured: (File image) async {
            // Handle the captured image here, for example, upload it
            List<dynamic> labels = await httpService.uploadImage(image);
            if (labels.isNotEmpty) {
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WasteItemLabelResultView(detectedLabels: labels),
                ),
              );
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Image uploaded successfully')),
              );
            } else {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to upload image')),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Waste Items'),
          actions: [
            IconButton(
              icon: const Icon(Icons.camera),
              onPressed: () async {
                _openCamera(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WasteItemCreateView(labelName: '',),
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
        ));
  }
}
