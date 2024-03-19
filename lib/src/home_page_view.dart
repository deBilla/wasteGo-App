// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:wastego/src/services/http_service.dart';
import 'package:wastego/src/waste_item_feature/waste_item_label_result_view.dart';
import 'package:wastego/src/custom_widgets/camera_preview_widget.dart';
import 'package:wastego/src/waste_item_feature/waste_item_create_view.dart';
import 'package:camera/camera.dart';
import 'package:wastego/src/waste_item_feature/waste_item_list_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePageView> {
  final HttpService httpService = HttpService();
  GoogleSignInUserData? _currentUser;
  bool _isLoggedIn = false;
  Future<void>? _initialization;

  @override
  void initState() {
    super.initState();
    _signIn();
  }

  Future<void> _ensureInitialized() {
    return _initialization ??= GoogleSignInPlatform.instance
        .initWithParams(const SignInInitParameters(
      scopes: <String>[
        'email',
      ],
    ))
        .catchError((dynamic _) {
      _initialization = null;
    });
  }

  void _setUser(GoogleSignInUserData? user) {
    setState(() {
      _currentUser = user;
      _isLoggedIn = user != null; // Update the logged-in status
    });
  }

  Future<void> _signIn() async {
    await _ensureInitialized();
    final GoogleSignInUserData? newUser =
        await GoogleSignInPlatform.instance.signInSilently();
    _setUser(newUser);
  }

  Future<void> _handleSignIn() async {
    try {
      await _ensureInitialized();
      _setUser(await GoogleSignInPlatform.instance.signIn());
    } catch (error) {
      final bool canceled =
          error is PlatformException && error.code == 'sign_in_canceled';
      if (!canceled) {
        print(error);
      }
    }
  }

  Future<void> _handleSignOut() async {
    await _ensureInitialized();
    await GoogleSignInPlatform.instance.disconnect();
    _setUser(null);
  }

  void _openCamera(BuildContext context) async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      // Handle no available cameras
      return;
    }

    final camera = cameras.first;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPreviewWidget(
          camera: camera,
          onImageCaptured: (File image) async {
            // Handle the captured image here, for example, upload it
            List<dynamic> labels = await httpService.uploadImage(image);
            if (labels.isNotEmpty) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WasteItemLabelResultView(detectedLabels: labels, currentUser: _currentUser,),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Image uploaded successfully')),
              );
            } else {
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
        actions: _isLoggedIn
            ? [
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
                        builder: (context) => WasteItemCreateView(
                          labelName: '',
                          currentUser: _currentUser,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    _handleSignOut();
                  },
                ),
              ]
            : [],
      ),
      body: _isLoggedIn
          ? WasteItemListView(currentUser: _currentUser,)
          : ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Text('You are not currently signed in.'),
                  ElevatedButton(
                    onPressed: _handleSignIn,
                    child: const Text('SIGN IN'),
                  ),
                ],
              ),
            ),
    );
  }
}