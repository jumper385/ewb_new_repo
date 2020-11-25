import 'dart:async';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

Future<List> getGPS(gpsObject) async {
  var newLocation = await gpsObject.getLocation();
  print(newLocation);
  return [newLocation.latitude, newLocation.longitude];
}
