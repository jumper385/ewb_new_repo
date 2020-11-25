import 'dart:async';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

Future<List> getGPS(gpsObject) async {
  var newLocation = await gpsObject.getLocation();
  return [newLocation.latitude, newLocation.longitude];
}
