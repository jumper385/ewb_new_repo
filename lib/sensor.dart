import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:battery/battery.dart';

final uuid = Uuid();

Future<List> getGPS(gpsObject) async {
  var newLocation = await gpsObject.getLocation();
  return [newLocation.latitude, newLocation.longitude];
}

Future<int> getBattery() async {
  var _battery = Battery();
  return await _battery.batteryLevel;
}
