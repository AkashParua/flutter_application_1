import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
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
  double _acc_x = 0.0;
  double _acc_y = 0.0;
  double _acc_z = 0.0;
  double _gy_x = 0.0;
  double _gy_y = 0.0;
  double _gy_z = 0.0;
  Location _location = Location();
  late StreamSubscription<LocationData> _locationSubscription;
  @override
  void initState() {
    super.initState();
    _locationSubscription =
        _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _latitude = currentLocation.latitude!;
        _longitude = currentLocation.longitude!;
      });
    });
    // [UserAccelerometerEvent (x: 0.0, y: 0.0, z: 0.0)]
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _acc_x = event.x;
        _acc_y = event.y;
        _acc_z = event.z;
      });
    });

    // [GyroscopeEvent (x: 0.0, y: 0.0, z: 0.0)]
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gy_x = event.x;
        _gy_y = event.y;
        _gy_z = event.z;
      });
    });
  }

  final style1 = const TextStyle(
      fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
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
                style: TextStyle(fontSize: 20, color: Colors.deepPurple),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.blue,
              child: Text('Latitude: $_latitude', style: style1),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.blue,
              child: Text(
                'Longitude: $_longitude',
                style: style1,
              ),
            ),
            const Center(
              child: Text(
                'Accelerometer',
                style: TextStyle(fontSize: 20, color: Colors.deepOrange),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.blue,
              child: Text('Acc. X-axis $_acc_x', style: style1),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.blue,
              child: Text('Acc. Y-axis $_acc_y', style: style1),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.blue,
              child: Text('Acc. Z-axis $_acc_z', style: style1),
            ),
            const Center(
              child: Text(
                'Gyroscope',
                style: TextStyle(fontSize: 20, color: Colors.amberAccent),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.blue,
              child: Text('Gyro. X-axis $_gy_x', style: style1),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.blue,
              child: Text('Gyro. Y-axis $_gy_y', style: style1),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              color: Colors.blue,
              child: Text('Gyro. Z-axis $_gy_z', style: style1),
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
