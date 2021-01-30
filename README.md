# Quick Start Guide
## Getting Started
Before installing, follow the instructions in the "Get Started" section of the [flutter documentation](https://flutter.dev/docs/get-started/install).
The guide will walk you through how to get started with flutter. Ensure you readand follow the documentation clearly.

## Interfacing with the App
This app uses HTTP requests to send data from the app to a remote webserver and test if it is connected to the webserver.

As of now, the app writes to the file using the `writeFile` function in the `fileio.dart` file. Below is a snippet of the function.

``` dart
// Saving the sensor data
Future<String> write_file(
    data_array, data_type, filename, folder, vehicleId) async {
  final Directory directory = await getExternalStorageDirectory();
  var new_file = '${directory.path}/${folder}/${filename}.txt';
  final File file = await File(new_file).create(recursive: true);
  print(data_array);

  final data = await file.readAsString();
  final sink = file.openWrite();
  sink.write(data +
      "$vehicleId, ${uuid.v4()}, ${DateTime.now()}, ${DateTime.now().timeZoneOffset}, $data_type, ${data_array.join(",")}||");
  sink.close();
  return await file.readAsString();
}

// Sending the sensor data
Future<int> upload_file(url, fileToUpload, folder) async {
  print('sending to $url');
  var data = await readFile('$fileToUpload.txt', folder);
  var response = await http.post(url, body: {'payload': '$data', 'filename':'$fileToUpload.txt'});
  print(response.statusCode);
  return response.statusCode;
}
```

As seen below, the data is written to a file as defined by the `filename` parameter. Once ready, the file will be changed into a text format and send through an `HTTP:POST` request under the `payload` field. 

### Payload Structure
The payload was designed to be as small as possible. This therefore required us to remove any repetition in data. To this end, we decided on a 'csv-like' approach where fields were delimited by a comma `,` and separated by a double pipe `||`. The only drawback of our approach was the lack of headers as we assume that based on this API. 

As of now, each new datapoint is formatted as shown below:

```
||vehicleid, randomid, timestamp, timezone, datatype, data_values||

// Sample GPS Datapoint
||vehicle1, 95971042-3f9f-4ab1-aa51-f8e4495e692b, 2020-12-15T16:36:53.707Z, 8:00:00.000000, gps, -31.9798071,115.8160845||

// Sample Accelerometer Datapoint
||vehicle1, 2699b81d-df4e-4553-ac67-3000e246551, 2020-12-15T16:36:56.675Z, 8:00:00.000000, accel, 0.19365260004997253,-0.030435092747211456,9.787362098693848||

// Sample Battery Datapoint
||vehicle1, d09c6f14-3e9b-4a2d-aa6a-6484452c561f, 2020-12-15T16:36:56.683Z, 8:00:00.000000, battery, 100||

```

Notice how data values are appended to the end of the string and comma separated? To properly parse this, we recommend destructuring with the following method

``` javascript
// ... some request handling
let { payload } = request.body;
let dataRaw = payload.split('||');
let [vId, dId, ts, tz, datatype, ...data] = dataRaw[0].split(',');

console.log(data) // should return "x,y,z" as a string for accelerometer data
```

The schema for each sensor datatype is provided below.
#### GPS Datatype
```
latitude,longitude
```
#### Battery
```
battery
```
#### Accelerometer
```
acc_x,acc_y,acc_z
```
## Server Check
A server check is used to determine if a connection with the webserver has been established. To achieve this, the app simply creates a `GET` request to the `api/ping` endpoint.

# Outstanding Issues
Refer [here](https://github.com/Alphurious007/ewb_new_repo/issues)
