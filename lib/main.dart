import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sensors_plus/sensors_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(home: Position()),
  );
}

class Position extends StatefulWidget {
  const Position({super.key});
  @override
  State<Position> createState() => _PositionState();
}

class _PositionState extends State<Position> {
  double _latitude = 0.0;
  double _longitude = 0.0;
  double _accx = 0.0;
  double _accy = 0.0;
  double _accz = 0.0;
  double _gyx = 0.0;
  double _gyy = 0.0;
  double _gyz = 0.0;
  double _speed = 0.0;
  String _deviceId = "";
  final Location _location = Location();
  final _geo = Geoflutterfire();
  late StreamSubscription<LocationData> _locationSubscription;

  final _onroad = FirebaseDatabase.instance.ref().child('onroad');

  void sendLocation(
      String deviceId, double longitude, double latitude, double speed) {
    final geofirepoint = _geo.point(latitude: latitude, longitude: longitude);
    _onroad.child(deviceId).set({
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'hash': geofirepoint.hash,
    });
  }

  void erase(String deviceId) {
    _onroad.child(deviceId).remove();
  }

  void getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      setState(() {
        _deviceId = androidInfo.androidId;
      });
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        _deviceId = iosInfo.identifierForVendor;
      });
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getDeviceId();
    _locationSubscription =
        _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _speed = double.parse(currentLocation.speed!.toStringAsFixed(3));
        _latitude = double.parse(currentLocation.latitude!.toStringAsFixed(4));
        _longitude =
            double.parse(currentLocation.longitude!.toStringAsFixed(4));
        sendLocation(_deviceId, _longitude, _latitude, _speed);
      });
    });
    // [UserAccelerometerEvent (x: 0.0, y: 0.0, z: 0.0)]
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _accx = double.parse(event.x.toStringAsFixed(3));
        _accy = double.parse(event.x.toStringAsFixed(3));
        _accz = double.parse(event.x.toStringAsFixed(3));
      });
    });

    // [GyroscopeEvent (x: 0.0, y: 0.0, z: 0.0)]
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyx = double.parse(event.x.toStringAsFixed(3));
        _gyy = double.parse(event.x.toStringAsFixed(3));
        _gyz = double.parse(event.x.toStringAsFixed(3));
      });
    });
  }

  final style1 = const TextStyle(
      fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              erase(_deviceId);
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.grey,
          title: Text(
            'VANET INTERFACE $_deviceId',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Center(
              child: Text(
                'Location',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.grey,
              child: Text('Latitude: $_latitude', style: style1),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.grey,
              child: Text(
                'Longitude: $_longitude',
                style: style1,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.grey,
              child: Text(
                'Speed: $_speed',
                style: style1,
              ),
            ),
            const Center(
              child: Text(
                'Accelerometer',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.grey,
              child: Text('Acc. X-axis $_accx', style: style1),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.grey,
              child: Text('Acc. Y-axis $_accy', style: style1),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.grey,
              child: Text('Acc. Z-axis $_accz', style: style1),
            ),
            const Center(
              child: Text(
                'Gyroscope',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.grey,
              child: Text('Gyro. X-axis $_gyx', style: style1),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.grey,
              child: Text('Gyro. Y-axis $_gyy', style: style1),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.grey,
              child: Text('Gyro. Z-axis $_gyz', style: style1),
            ),
          ],
        )));
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }
}
