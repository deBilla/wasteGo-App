import 'package:flutter/material.dart';
import 'package:wastego/src/waste_item_feature/waste_item_create_view.dart';

class WasteItemLabelResultView extends StatelessWidget {
  final List<dynamic> detectedLabels;

  const WasteItemLabelResultView({Key? key, required this.detectedLabels})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detected Labels'),
      ),
      body: ListView.builder(
        itemCount: detectedLabels.length,
        itemBuilder: (context, index) {
          var label = detectedLabels[index];
          return ListTile(
            title: Text('Label: ${label['label']}'),
            subtitle: Text('Confidence: ${label['confidence']}'),
            onTap: () {
              // Navigate to WasteItemCreateView with labelName as the name
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WasteItemCreateView(
                    labelName: label['label'], // Pass the labelName as a parameter
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
