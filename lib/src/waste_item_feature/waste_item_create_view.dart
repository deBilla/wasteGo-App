import 'package:flutter/material.dart';
import 'package:wastego/src/services/http_service.dart';
import 'package:wastego/src/waste_item_feature/waste_item_list_view.dart';

class WasteItemFormData {
  String name = '';
  int quantity = 0;
  String type = '';
}

// ignore: must_be_immutable
class WasteItemCreateView extends StatelessWidget {
  final HttpService httpService = HttpService();
  WasteItemFormData formData = WasteItemFormData();
  final String labelName;

  WasteItemCreateView({Key? key, required this.labelName})
      : formData = WasteItemFormData()..name = labelName,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Waste Item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                initialValue: labelName,
                onChanged: (value) {
                  formData.name = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Type'),
                onChanged: (value) {
                  formData.type = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  formData.quantity = int.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool isCreated = await httpService.createWasteItem(
                      formData.name, formData.type, formData.quantity);
                  // ignore: duplicate_ignore
                  if (isCreated) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WasteItemListView(),
                      ),
                    );
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to create waste item.'),
                      ),
                    );
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
