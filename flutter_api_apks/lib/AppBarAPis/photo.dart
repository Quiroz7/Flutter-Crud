import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class TakePhoto extends StatelessWidget {
  const TakePhoto({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo de Cámara en Flutter',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara & GPS'),
           backgroundColor: const Color.fromARGB(255, 3, 37, 65),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            image == null
                ? const Icon(Icons.image)
                : Image.file(File(image!.path)),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  _showCamera();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 8, 79, 100),
                ),
                child: const Text(
                  "Tomar Foto",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                mapScreen();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 8, 79, 100),
              ),
              child: const Text('Ver Mapa'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    if (!mounted) return;
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePicturePage(camera: camera)));
    if (result != null) {
      setState(() {
        image = result;
      });
    }
  }

  void mapScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );
  }
}

class TakePicturePage extends StatefulWidget {
  final CameraDescription camera;

  const TakePicturePage({Key? key, required this.camera}) : super(key: key);

  @override
  State<TakePicturePage> createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  late CameraController _cameraController;
  late Future<void> _initializeCameraControllerFuture;

  @override
  void initState() {
    super.initState();
    _cameraController =
        CameraController(widget.camera, ResolutionPreset.max);
    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera),
        onPressed: () => _takePicture(context),
      ),
      body: FutureBuilder<void>(
        future: _initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CameraPreview(_cameraController),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _takePicture(BuildContext context) async {
    try {
      if (!_cameraController.value.isTakingPicture) {
        XFile image = await _cameraController.takePicture();
        if (!mounted) return;
        Navigator.pop(context, image);
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Ya se está tomando una foto.')),
          );
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}

// ignore: constant_identifier_names
const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoicGl0bWFjIiwiYSI6ImNsY3BpeWxuczJhOTEzbnBlaW5vcnNwNzMifQ.ncTzM4bW-jpq-hUFutnR1g';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? myPosition;

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await determinePosition();
    setState(() {
      myPosition = LatLng(position.latitude, position.longitude);
      print(myPosition);
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mapa'),
        backgroundColor: const Color.fromARGB(255, 3, 37, 65),
      ),
      body: myPosition == null
          ? const CircularProgressIndicator()
          : FlutterMap(
              options: MapOptions(
                  center: myPosition, minZoom: 5, maxZoom: 25, zoom: 18),
              nonRotatedChildren: [
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                  additionalOptions: const {
                    'accessToken': MAPBOX_ACCESS_TOKEN,
                    'id': 'mapbox/streets-v12'
                  },
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: myPosition!,
                      builder: (context) {
                        return Container(
                          child: const Icon(
                            Icons.person_pin,
                            color: Colors.blueAccent,
                            size: 40,
                          ),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
    );
  }
}