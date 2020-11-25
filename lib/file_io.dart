library file_io;

import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';

final uuid = Uuid();

//Helper Helper function that I got from the internet: https://stackoverflow.com/questions/61919395/how-to-generate-random-string-in-dart
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

String generate_filename() {
  //PLACEHOLDER
  return getRandomString(5);
}

Future<String> write_file(
    data_array, data_type, filename, folder, vehicleId) async {
  final Directory directory = await getExternalStorageDirectory();
  var new_file = '${directory.path}/${folder}/${filename}.txt';
  final File file = await File(new_file).create(recursive: true);

  final data = await file.readAsString();
  final sink = file.openWrite();
  sink.write(data +
      "$vehicleId, ${uuid.v4()}, ${DateTime.now()}, ${DateTime.now().timeZoneOffset}, $data_type, ${data_array.join(",")}||");
  sink.close();
  return await file.readAsString();
}

Future<void> move_file(filename, folder_from, folder_to) async {
  final Directory directory = await getExternalStorageDirectory();
  File file = File(
      '${directory.path}/${folder_from}/${filename}.txt'); //gone to file and aquired it
  if (await File(file.path).exists()) {
    if (await Directory("${directory.path}/${folder_to}").exists()) {
      await file.rename(
          '${directory.path}/${folder_to}/$filename.txt'); //moving file to where it needs to go
    } else {
      final Directory folder_to_dir =
          await Directory("${directory.path}/${folder_to}")
              .create(recursive: true);
      await file.rename(
          '${folder_to_dir.path}/$filename.txt'); //moving file to where it needs to go
    }
  }
  return;
}

Future<void> delete_file(filename, folder) async {
  final Directory directory = await getExternalStorageDirectory();

  final Directory folder_dir =
      await Directory('${directory.path}/${folder}').create(recursive: true);

  File file = File('${folder_dir.path}/${filename}.txt');

  if (await File(file.path).exists()) {
    await file.delete();
  }
  return;
}

Future<String> readFile(filename, folder) async {
  final directory = await getExternalStorageDirectory();
  File file = new File('${directory.path}/$folder/$filename');
  if (!await file.exists()) await file.create(recursive: true);
  return await file.readAsString();
}

Future<bool> check_folder_empty(folder) async {
  final Directory directory = await getExternalStorageDirectory();
  Directory dir = Directory('${directory.path}/${folder}');
  List files = dir.listSync();
  return files.isEmpty;
}

Future<bool> movement_detection(filename, folder, distance_threshold) async {
  // final Directory directory = await getExternalStorageDirectory();
  // var file =
  //     File('${directory.path}/${folder}/$filename.txt'); //read whole file
  // print(file);
  // List lines = await file.readAsLines(); //read each line as a part of a list
  // List gpsLines = lines.where((x) {
  //   return x.split(',').length > 0 ? x.split(',')[3].trim() == 'gps' : false;
  // }).toList();
  // print('selected gps only');
  // print(gpsLines);

  // List initial = gpsLines[0]
  //     .split(","); // split the two values of each line where split by a comma
  // double lat1 = double.tryParse(initial[4]); //get latitude
  // double lon1 = double.tryParse(initial[5]); //get longitude
  // print('initial value');

  // for (int i = 1; i < gpsLines.length; i++) {
  //   List currentLine = gpsLines[i].split(",");
  //   double lat2 = double.tryParse(currentLine[4]); //getting second set of data
  //   double lon2 = double.tryParse(currentLine[5]);

  //   var distanceLength = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  //   if (distanceLength >= distance_threshold) {
  //     return true;
  //   }
  // }
  return true;
}
