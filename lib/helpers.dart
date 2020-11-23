library helpers;

import 'package:location/location.dart';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

final uuid = Uuid();

Future<List> getGPS(gpsObject) async {
  var newLocation = await gpsObject.getLocation();
  print(newLocation);
  return [newLocation.latitude, newLocation.longitude];
}

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
  final Directory directory = await getApplicationDocumentsDirectory();
  var new_file = '${directory.path}/${folder}/${filename}.txt';
  final File file = await File(new_file).create(recursive: true);
  print(file);

  final data = await file.readAsString();
  final sink = file.openWrite();
  sink.write(data +
      "$vehicleId, ${uuid.v4()}, ${DateTime.now()}, $data_type, ${data_array.join(",")}\n\r");
  sink.close();
  return await file.readAsString();
}

Future<bool> movement_detection(filename, folder, distance_threshold) async {
  return true;
}

Future<void> move_file(filename, folder_from, folder_to) async {
  final Directory directory = await getApplicationDocumentsDirectory();
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
  final Directory directory = await getApplicationDocumentsDirectory();

  final Directory folder_dir =
      await Directory('${directory.path}/${folder}').create(recursive: true);

  File file = File('${folder_dir.path}/${filename}.txt');

  if (await File(file.path).exists()) {
    await file.delete();
  }
  return;
}

Future<bool> check_folder_empty(folder) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  Directory dir = Directory('${directory.path}/${folder}');
  List files = dir.listSync();
  return files.isEmpty;
}

Future<bool> is_connected() async {
  print('starting check connect');
  return await Future<String>.delayed(
    Duration(milliseconds: 100),
    () {
      return 'finished check connect';
    },
  ).then((value) {
    print(value);
    return false;
  });
}

Future<List> get_file_list(folder) async {
  print('starting get file list');
  return await Future<String>.delayed(
    Duration(milliseconds: 100),
    () {
      return 'finished get file list';
    },
  ).then((value) {
    print(value);
    return ['file1', 'file2'];
  });
}

Future<int> upload_file(url, filename, folder) async {
  print('Starting File Upload');
  return await Future<int>.delayed(Duration(milliseconds: 3000), () {
    return 200;
  }).then((value) {
    print(value);
    return 200;
  });
}

Future<void> upload_delete(url, filename, folder) async {
  try {
    upload_file(url, filename, folder).then((e) => {
          if (e == 200)
            {delete_file(filename, folder)}
          else
            {print("upload error!!!!!!!!!")}
        });
  } catch (err) {
    print("upload_delete failed");
  }
}

Future<void> create_filename(filename, folder) async {}
