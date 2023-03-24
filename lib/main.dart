import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() => runApp(
      MaterialApp(home: Position()),
    );

class Position extends StatefulWidget {
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
  double _speed = 0;
  var clock = DateTime.now();
  Location _location = Location();
  late StreamSubscription<LocationData> _locationSubscription;
  @override
  void initState() {
    super.initState();

    _locationSubscription =
        _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _speed = currentLocation.speed!;
        _latitude = currentLocation.latitude!;
        _longitude = currentLocation.longitude!;
      });
    });
    // [UserAccelerometerEvent (x: 0.0, y: 0.0, z: 0.0)]
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _accx = event.x;
        _accy = event.y;
        _accz = event.z;
      });
    });

    // [GyroscopeEvent (x: 0.0, y: 0.0, z: 0.0)]
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyx = event.x;
        _gyy = event.y;
        _gyz = event.z;
      });
    });
  }

  final style1 = const TextStyle(
      fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: const Text(
            'VANET INTERFACE',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
