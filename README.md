# Helper Functions

## `List get_accel(accelStream)`
### Description
Gets data from accelerometer
### Parameters
- `accelStream`: The accelerometer stream object that we have to listen to
### Returns
- `[acc_x, acc_y, acc_z]`: single array consisting of x, y and z values from accelerometer data.

## `Future<List> get_gps(gpsObject)`
### Description
Gets data from the GPS
### Parameters
- `gpsObject`: The GPS object provided by the library you will be using to get the GPS data.
### Returns
- `[latitude, longitude]`: single array consisting of latitude and longitude

## `Future<void> write_file(array, data_type, filename)`
### Description
Gets an input array of arbitrary length and writes to the `filename` with the following structure: 
```
[
    vehicle_id(String), # A string containing the vehicle id
    datapoint_id(String), # A datapoint id to locate this specific datapoint
    timestamp(String), # Timestamp of the datapoint
    content(String) # A string of comma separated values (i.e. array of data [arr1, arr2, arr3] is sent as "arr1,arr2,arr3")
]
```
The function must then write to a new line in the file of `filename` (look into `writeln` method [here](https://api.dart.dev/stable/2.10.4/dart-io/Stdout/writeln.html))

The file contents upon upload should look like this
```
[...datapoint1]
\n
[...datapoint2]
\n
[...datapoint3]
\n
...
[...datapointx]
```
### Parameters
- `array (Array)`: array of data
- `data_type (String)`: the type of data we are writing (i.e. accelerometer or gps)
- `filename (String)`: the filename we are writing to

### Output
`NONE`

## `String generate_filename()`
### Description
Generates a random filename string. We suggest using UUID v4 to generate the filename. More information can be found [here](https://pub.dev/packages/uuid)
### Parameters
`NONE`
### Returns
- `filename (String)`: A unique filename ID

## `String change_filename(new_filename)`
### Description
This function changes the widget state variable that controls the filename we are writing to `new_filename` whilst also returning the previous filename for reference in the future.
### Parameters
`NONE`
### Returns
- `last_filename (String)` The filename of the file we last wrote into

## `Future<void> move_file(filename, folder_from, folder_to)`
### Description
A function that moves the selected `filename` from `root/${folder_from}` to `root/${folder_to}`. This function will be used to move files from the `root/compile` to `root/upload` folder.
### Parameters
- `filename (String)`: the target filename we want to move
- `folder_from (String)`: the target folder the file is in
- `folder_to (String)`: the target folder we want to move the file into
### Returns
`NONE` 

## `Future<void> delete_file(filename, folder)`
### Description
A function that deletes a specific `filename` from a specified `folder` path. We will use this to delete folders which have been successfully uploaded OR contain data that has no sufficient movement being logged.
## Parameters
- `filename (String)`: The target filename
- `folder (String)`: The target folder path
## Returns
`NONE`

## `Future<Boolean> check_folder_empty(folder)`
A function that checks if the `folder` path is empty
### Parameters
- `folder (String)`: Which folder to look in
### Returns
- `is_empty(Boolean)`: A boolean which is `true` when the folder is empty and `false` if it contains files

## `is_connected()`
A function that checks if there is cellular connection
### Parameters
`NONE`
### Returns
- `has_connection (Boolean)`: A boolean which is `true` if the there is an active connection and `false` if no connection is present.

## `Future<List> get_file_list(folder)`
A function that looks into a folder and returns an array containing a list of filenames present within the `folder` path. This should return a list as follows:
`[fn1, fn2, fn3, ... fnN]`
### Parameters
- `folder (String)`: A string cointaining the target `folder` path to look at
### Returns
- `file_list (String)`: A list of files present inside the folder

## `Future<List> upload_file(url, filename, folder)`
### Description
This function should send the contents of the `filename` inside a `folder` path to a `url` via an `HTTP:POST` request. We advise it be a `Future` function that returns a `String` of the response which can be used for future reference later.
### Parameters
- `url (String)`: The url endpoint we want to `POST` to
- `filename (String)`: The name of the file we want to upload 
- `folder (String)`: The path the `filename` exists in
### Returns
- `response (String)`: A string of the response from the server

## Future<Boolean> movement_detection(filename, folder, distance_threshold)
### Description
Analyses the GPS data within `filename` in `folder` path and find the maximum distance from the first datapoint. If it is less than `distance_threshold`, return `false` else, return `true`. 
### Parameters
- `filename (String)`: the filename of the target file
- `folder (String)`: the folder in which the file is located in
- `distance_threshold (Double)`: The minimum threshold displacement of a point that must be exceeded for the function to consider movement within the recorded file 
### Returns
- `movement_detected (Boolean)` `true` if maximum displacement exceeds the threshold distance else `false`
