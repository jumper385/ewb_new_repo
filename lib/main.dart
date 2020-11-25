import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sensors/sensors.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'file_io.dart';
import 'sensor.dart';
import 'web.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

final accel_delay = Duration(seconds: 3);
final gps_delay = Duration(seconds: 3);
final thread2_delay = Duration(seconds: 10);
final thread3_delay = Duration(seconds: 15);
final thread4_delay = Duration(seconds: 20);
final String vehicleID = 'this is vehicle 1';
final String upload = "upload";
final String stagging = "stagging";
final String compile = "compile";
final double distance_threshold = 10.0;
final String databaseurl = "http://172.20.10.2:80/apiv1";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[300],
          title: Text('EWB APPtech'),
        ),
        body: Column(
          children: [MainStructure()],
        ),
      ),
    );
  }
}

class MainStructure extends StatefulWidget {
  @override
  _MainStructureState createState() => _MainStructureState();
}

class _MainStructureState extends State<MainStructure> {
  //State Variables
  double x, y, z = 0;
  List<double> accelValues;
  Location location = new Location();
  var latlong;
  String filename;
  bool connected = false;

  //Main Threads
  Future<void> accelData() async {
    setState(() {
      accelValues = [x, y, z];
    });
    write_file(accelValues, 'accel', filename, compile, vehicleID);
  }

  Future<void> gpsData() async {
    getGPS(location).then((value) {
      setState(() {
        latlong = value;
      });
      write_file(latlong, 'gps', filename, compile, vehicleID);
    });
  }

  Future<void> thread2() async {
    if (!await check_folder_empty(compile)) {
      setState(() {
        filename = generate_filename();
      });

      final Directory directory = await getExternalStorageDirectory();
      Directory compileDir = Directory('${directory.path}/$compile');
      print(compileDir);
      compileDir.list(recursive: true, followLinks: false).listen((e) {
        String name = e.path.split('/').last.split('.')[0];
        if (name != filename) {
          move_file(name, compile, stagging);
          print('moved file to stagging');
        }
      });
    }
  }

  Future<void> thread3() async {
    final Directory directory = await getExternalStorageDirectory();
    Directory staggingDir = Directory('${directory.path}/$stagging');

    staggingDir.list(recursive: true, followLinks: false).listen((e) async {
      String name = e.path.split('/').last.split('.')[0];
      if (await movement_detection(name, stagging, distance_threshold)) {
        move_file(name, stagging, upload);
        print('move_stagging');
      } else {
        delete_file(name, stagging);
        print("delete_stagging");
      }
    });
  }

  Future<void> thread4() async {
    if (!await check_folder_empty(upload)) {
      print('checked!');
      if (await is_connected()) {
        if (await ping_server(databaseurl)) {
          print("uploading to server");
          final Directory directory = await getExternalStorageDirectory();
          Directory uploadDir = Directory('${directory.path}/$upload');

          uploadDir.list(recursive: true, followLinks: false).listen((e) async {
            String name = e.path.split('/').last.split('.')[0];
            upload_delete(databaseurl, name, upload);
          });
        }
      }
    }
  }

  //Initialization
  @override
  void initState() {
    super.initState();
    filename = generate_filename();

    accelerometerEvents.listen((event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
    });

    Timer.periodic(accel_delay, (Timer accelTimer) {
      print("Hello world");
      accelData();
    });

    Timer.periodic(gps_delay, (Timer gpsTimer) {
      print("hello world 2");
      gpsData();
    });

    Timer.periodic(thread2_delay, (Timer thread2Timer) {
      print("hello world 3");
      thread2();
    });

    Timer.periodic(thread3_delay, (Timer thread3Timer) {
      print("hello world 4");
      thread3();
    });

    Timer.periodic(thread4_delay, (Timer thread3Timer) {
      print("hello world 5");
      thread4();
    });

    Timer.periodic(Duration(milliseconds: 250), (timer) async {
      bool conn = await is_connected();
      setState(() {
        connected = conn != null ? conn : false;
      });
    });
  }

  //Display
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Text(connected
                ? '🟢 Connected to Internet 😌'
                : '🟠 Currently Offline 😴'),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Accel Data",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("X-Axis"),
                      Text(accelValues != null
                          ? accelValues[0].toStringAsFixed(3)
                          : 'nothing...'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Y-Axis"),
                      Text(accelValues != null
                          ? accelValues[1].toStringAsFixed(3)
                          : 'nothing...'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Z-Axis"),
                      Text(accelValues != null
                          ? accelValues[2].toStringAsFixed(3)
                          : 'nothing...'),
                    ],
                  ),
                ),
                Text(
                  "GPS Data",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
                Text(latlong != null
                    ? "latitude: " + latlong[0].toString()
                    : 'nothing...'),
                Text(latlong != null
                    ? "longitude: " + latlong[1].toString()
                    : 'nothing...'),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      ping_button(databaseurl, "vehicle 500");
                    },
                    label: Text('Ping Server'),
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
