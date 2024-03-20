import 'package:flutter/material.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:wastego/src/home_page_view.dart';
import 'package:wastego/src/services/http_service.dart';

class WasteItemFormData {
  String name = '';
  int quantity = 0;
  String type = '';
  String imageUrl = '';

  WasteItemFormData({required this.type, required this.imageUrl});
}

class WasteItemCreateView extends StatefulWidget {
  final String labelName;
  final String imageUrl;
  final GoogleSignInUserData? currentUser;

  const WasteItemCreateView({Key? key, required this.labelName, required this.currentUser, required this.imageUrl})
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
    formData = WasteItemFormData(type: widget.labelName, imageUrl: widget.imageUrl);
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
            TextFormField(
              decoration: const InputDecoration(labelText: 'Image URL'),
              initialValue: widget.imageUrl,
              onChanged: _handleImageUrlChanged,
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

  void _handleImageUrlChanged(String value) {
    formData.imageUrl = value;
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
          builder: (context) => HomePageView(),
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
      widget.currentUser!.id,
      formData.name,
      formData.type,
      formData.quantity,
      formData.imageUrl,
    );
  }

  void _handleCloseButtonPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePageView(),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
