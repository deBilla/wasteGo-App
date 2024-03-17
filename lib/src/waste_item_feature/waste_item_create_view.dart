import 'package:flutter/material.dart';
import 'package:wastego/src/services/http_service.dart';
import 'package:wastego/src/waste_item_feature/waste_item_list_view.dart';

class WasteItemFormData {
  String name = '';
  int quantity = 0;
  String type = '';

  WasteItemFormData({required this.type});
}

class WasteItemCreateView extends StatefulWidget {
  final String labelName;

  const WasteItemCreateView({Key? key, required this.labelName})
      : super(key: key);

  @override
  WasteItemCreateViewState createState() => WasteItemCreateViewState();
}

class WasteItemCreateViewState extends State<WasteItemCreateView> {
  final HttpService httpService = HttpService();
  late WasteItemFormData formData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    formData = WasteItemFormData(type: widget.labelName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Waste Item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _handleCloseButtonPressed,
          ),
        ],
      ),
      body: isLoading ? _buildLoadingIndicator() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: _handleNameChanged,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Type'),
              initialValue: widget.labelName,
              onChanged: _handleTypeChanged,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onChanged: _handleQuantityChanged,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleCreateButtonPressed,
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNameChanged(String value) {
    formData.name = value;
  }

  void _handleTypeChanged(String value) {
    formData.type = value;
  }

  void _handleQuantityChanged(String value) {
    formData.quantity = int.tryParse(value) ?? 0;
  }

  void _handleCreateButtonPressed() async {
    setState(() {
      isLoading = true;
    });
    bool isCreated = await _createWasteItem();
    setState(() {
      isLoading = false;
    });
    if (isCreated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WasteItemListView(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create waste item.'),
        ),
      );
    }
  }

  Future<bool> _createWasteItem() async {
    return httpService.createWasteItem(
      formData.name,
      formData.type,
      formData.quantity,
    );
  }

  void _handleCloseButtonPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WasteItemListView(),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
