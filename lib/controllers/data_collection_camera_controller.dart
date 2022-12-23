import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/styles.dart';

class DataCollectionCameraController extends StatefulWidget {
  const DataCollectionCameraController({super.key});

  @override
  State<StatefulWidget> createState() {
    return DataCollectionCameraControllerState();
  }
}

class DataCollectionCameraControllerState extends State<DataCollectionCameraController> {
  late dynamic cameras;
  late dynamic camera;
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  List<Image> pictures = [];

  void getDeviceCamera() async {
    cameras = await availableCameras();
    camera = cameras.first;
    _controller = CameraController(camera, ResolutionPreset.medium,);
    setState(() {
      _initializeControllerFuture = _controller.initialize();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getDeviceCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Take a picture')),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              _controller
                ..setExposureMode(ExposureMode.auto)
                ..setFlashMode(FlashMode.off);
              final image = await _controller.takePicture();
              if (!mounted) return;
              Image? res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DisplayPictureScreen(imagePath: image.path,)));

              if (res != null) {
                setState(() {
                  pictures.add(res);
                  if (kDebugMode) {
                    print('____________________${pictures.length}_________________');
                  }
                });
              }
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
            }
          },
          child: const Icon(Icons.camera_alt),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, pictures);
            return false;
          },
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    CameraPreview(_controller),
                    Row(
                      children: [
                        Text(
                          ' Photos taken: ',
                          style: CustomTextStyle.merriweatherBold(context),
                        ),
                        Text(
                            '${pictures.length}',
                            style: CustomTextStyle.inconsolata(context)
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Column(
        children: [
          Image.file(File(imagePath)),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: "addImg",
                  backgroundColor: Colors.green,
                  onPressed: () {
                    Navigator.pop(context, Image.file(File(imagePath)));
                  },
                  child: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                  ),
                ),
                FloatingActionButton(
                  heroTag: "discardImg",
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.dangerous_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}