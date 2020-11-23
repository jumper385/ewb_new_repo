library helpers;

import 'package:location/location.dart';
import 'dart:async';
import 'dart:math';

Future<List> getGPS(gpsObject) async {
  var newLocation = await gpsObject.getLocation();
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

Future<void> write_file(array, data_type, filename, compile) async {
  //PLACEHOLDER
  print('starting write');
  await Future<String>.delayed(
    Duration(milliseconds: 100),
    () {
      return 'finished write';
    },
  ).then((value) {
    print(value);
  });
}

Future<bool> movement_detection(filename, folder, distance_threshold) async {
  return true;
}

Future<void> move_file(filename, folder_from, folder_to) async {
  print('starting write move file');
  await Future<String>.delayed(
    Duration(milliseconds: 100),
    () {
      return 'finished write move file';
    },
  ).then((value) {
    print(value);
  });
}

Future<void> delete_file(filename, folder) async {
  print('starting write delete file');
  await Future<String>.delayed(
    Duration(milliseconds: 100),
    () {
      return 'finished write delete file';
    },
  ).then((value) {
    print(value);
  });
}

Future<bool> check_folder_empty(folder) async {
  print('starting check empty file');
  return await Future<String>.delayed(
    Duration(milliseconds: 100),
    () {
      return 'finished check empty file';
    },
  ).then((value) {
    print(value);
    return false;
  });
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
    return true;
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
