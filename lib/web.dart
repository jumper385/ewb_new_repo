library web;

import 'dart:async';
import 'file_io.dart';
import 'package:uuid/uuid.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

final uuid = Uuid();

Future<int> upload_file(url, fileToUpload, folder) async {
  print('sending to $url');
  var data = await readFile('$fileToUpload.txt', folder);
  var response = await http
      .post(url, body: {'payload': '$data', 'filename': '$fileToUpload.txt'});
  print(response.statusCode);
  return response.statusCode;
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
    print("upload_delete failed");
  }
}

Future<bool> is_connected() async {
  var connectivtyResult = await Connectivity().checkConnectivity();
  // print(connectivtyResult != ConnectivityResult.none
  //     ? "CONNECTED"
  //     : "NOT CONNECTED");
  return connectivtyResult != ConnectivityResult.none ? true : false;
}

Future<bool> ping_server(url) async {
  try{
    print('pinging $url/ping');
    var response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("succeed to ping server");
      return true;
    } else {
      print("failed to ping server");
      return false;
    }
  } catch (err){
    print("ping_server() failed");
    return false;
  }
}

Future<int> ping_button(url, string) async {
  print('SERVER PING BUTTTON PRESSED');
  var response = await http.post(url, body: {'payload': '$string'});
  print(response.statusCode);
  return response.statusCode;
}
