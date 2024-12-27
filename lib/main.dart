import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:ietp_g96/splash/splash_view.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bluetooth Connection',
      theme: ThemeData.dark(),
      home: SplashView(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   BluetoothConnection? _connection;
//   bool _isConnected = false;
//   bool isLoading = false;
//   String _receivedData = "";


//   late StreamSubscription<BluetoothState> _bluetoothStateSubscription;
  
//   @override
//   void initState() {
//     super.initState();
//     _bluetoothStateSubscription = FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState state) {
//       print('Bluetooth state changed: $state');
//       if (state == BluetoothState.STATE_OFF) {
//         setState(() {
//           _isConnected = false;
//           _connection = null;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _bluetoothStateSubscription.cancel();
//     _disconnectFromDevice();
//     super.dispose();
//   }



//   Future<void> check_con() async {
//     try {
//       final List<BluetoothDevice> devices =
//           await FlutterBluetoothSerial.instance.getBondedDevices();
//       final BluetoothDevice device =
//           devices.firstWhere((d) => d.name == "ESP32_Bluetooth");

//       final BluetoothConnection connection =
//           await BluetoothConnection.toAddress(device.address);

//       print('Connected to the device');

//       connection.input!.listen((Uint8List data) {
//         print('Row incoming: ${data}');
//         // connection.output.add(data); // Sending data
//         String received =
//             String.fromCharCodes(data); // Handles non-UTF-8 gracefully
//         print("Received Data: $received");

//         String received2 = utf8.decode(data, allowMalformed: true);
//         print("Received2 Data: $received2");

//         // if (ascii.decode(data).contains('!')) {
//         //   connection.finish(); // Closing connection
//         //   print('Disconnecting by local host');
//         // }
//         if (connection.isConnected) {
//           setState(() {
//             _connection = connection;
//             _isConnected = true;
//             isLoading = false;
//           });
//         }
//       }).onDone(() {
//         print('Disconnected by remote request');
//       });
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
  

// Map<String, dynamic> parseArduinoData(String data) {
//   // Define regular expressions for each sensor type
//   final heartbeatRegExp = RegExp(r'heartbeat:\s*(\d+)');
//   final temperatureRegExp = RegExp(r'Temperature:\s*(\d+)');
//   final gasRegExp = RegExp(r'Gas:\s*(\d+)');
//   final gpsRegExp = RegExp(r'GPS:\s*\[(\d+),\s*(\d+)\]');

//   // Initialize a result map
//   Map<String, dynamic> sensorData = {};

//   // Match and extract Heartbeat data
//   final heartbeatMatch = heartbeatRegExp.firstMatch(data);
//   if (heartbeatMatch != null) {
//     sensorData['Heartbeat'] = int.parse(heartbeatMatch.group(1)!);
//   }

//   // Match and extract Temperature data
//   final temperatureMatch = temperatureRegExp.firstMatch(data);
//   if (temperatureMatch != null) {
//     sensorData['Temperature'] = int.parse(temperatureMatch.group(1)!);
//   }

//   // Match and extract Gas data
//   final gasMatch = gasRegExp.firstMatch(data);
//   if (gasMatch != null) {
//     sensorData['Gas'] = int.parse(gasMatch.group(1)!);
//   }

//   // Match and extract GPS data
//   final gpsMatch = gpsRegExp.firstMatch(data);
//   if (gpsMatch != null) {
//     sensorData['GPS'] = [
//       int.parse(gpsMatch.group(1)!),
//       int.parse(gpsMatch.group(2)!)
//     ];
//   }

//   return sensorData;
// }


//   Future<void> _connectToDevice() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       final List<BluetoothDevice> devices =
//           await FlutterBluetoothSerial.instance.getBondedDevices();
//       final BluetoothDevice device =
//           devices.firstWhere((d) => d.name == "ESP32_Bluetooth");

//       final BluetoothConnection connection =
//           await BluetoothConnection.toAddress(device.address);

//       if (connection.isConnected) {
//         setState(() {
//           _connection = connection;
//           _isConnected = true;
//           isLoading = false;
//         });

//         // Listen for disconnection events
//         connection.input!.listen(null).onDone(() {
//           print('Disconnected!');
//           setState(() {
//             _isConnected = false;
//             _connection = null;
//           });
//         });

//         // Handle incoming data from Arduino
//         _listenToData(connection);
//       }
//     } catch (e) {
//       print("Connection error: $e");
//       setState(() {
//         isLoading = false;
//         _isConnected = false;
//       });
//     }
//   }

//   void _listenToData(BluetoothConnection connection) {
//     print("#####################333");
//     connection.input!.listen((Uint8List data) {
//       String received = utf8.decode(data);
//       print("Received Data: $received");
//       setState(() {
//         _receivedData = received;
//       });
//     }, onError: (error) {
//       print("Error while receiving data: $error");
//     });
//     print("@@@@@@@@@@@@@@@@@@@2");
//   }

//   Future<void> _disconnectFromDevice() async {
//     await _connection?.finish();
//     setState(() {
//       _connection = null;
//       _isConnected = false;
//     });
//   }

//   Future<void> _sendData(int value) async {
//     if (_connection != null) {
//       Uint8List bytes = Uint8List.fromList(utf8.encode(value.toString()));
//       _connection!.output.add(bytes);
//       await _connection!.output.allSent;
//     }
//   }

//   Future<void> requestPermission() async {
//     final status = await Permission.location.request();
//     if (status.isGranted) {
//       _connectToDevice();
//     } else if (status.isDenied || status.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   }

//   @override
//   void initState() {
//     // requestPermission();
//     // check_con();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _disconnectFromDevice();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Control Servo"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             FlutterLogo(size: 150),
//             Text(
//               _isConnected ? "CONNECTED" : "DISCONNECTED",
//               style: TextStyle(
//                 color: _isConnected ? Colors.green : Colors.red,
//                 fontSize: 20,
//               ),
//             ),
//             ElevatedButton(
//               onPressed: _isConnected ? () => _sendData(1) : null,
//               child: const Text('Rotate 0'),
//             ),
//             ElevatedButton(
//               onPressed: _isConnected ? () => _sendData(2) : null,
//               child: const Text('Rotate 360'),
//             ),
//             const SizedBox(height: 20),
//             isLoading
//                 ? const CircularProgressIndicator()
//                 : Text(
//                     _receivedData.isNotEmpty
//                         ? "Received: $_receivedData"
//                         : "No data received yet.",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//             ElevatedButton(
//               onPressed: () async {
//                 check_con();
//                 // await requestPermission();
//               },
//               child: Text(_isConnected ? "Disconnect" : "Connect"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
