library web;

import 'dart:async';
import 'file_io.dart';
import 'package:uuid/uuid.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

final uuid = Uuid();

Future<int> upload_file(url, fileToUpload, folder) async {
  try {
    var data = await readFile('$fileToUpload.txt', folder);
    var response = await http
        .post(url, body: {'payload': '$data', 'filename': '$fileToUpload.txt'});
    print(response.statusCode);
    return response.statusCode;
  } catch (err) {
    print("UPLOAD FAILED");
    return 500;
  }
}

Future<void> upload_delete(url, filename, folder) async {
  try {
    upload_file(url, filename, folder).then((e) {
      print("response ${e.toString()}");
      if (e == 200) {
        delete_file(filename, folder);
      } else {
        print("upload error!!!!!!!!!");
      }
    });
  } catch (err) {
    print("UPLOAD_DELETE FAILED");
  }
}

Future<bool> is_connected() async {
  var connectivtyResult = await Connectivity().checkConnectivity();
  return connectivtyResult != ConnectivityResult.none ? true : false;
}

Future<bool> ping_server(url) async {
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      // print("succeed to ping server");
      return true;
    } else {
      // print("failed to ping server");
      return false;
    }
  } catch (err) {
    print("PING SERVER FAILED");
    return false;
  }
}
