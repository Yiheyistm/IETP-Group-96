// // ignore_for_file: use_build_context_synchronously, deprecated_member_use

// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:ietp_g96/user/user_screen.dart';

// class ScanScreen extends StatefulWidget {
//   const ScanScreen({super.key});

//   @override
//   _ScanScreenState createState() => _ScanScreenState();
// }

// class _ScanScreenState extends State<ScanScreen> {
//   FlutterBluePlus flutterBlue = FlutterBluePlus();
//   List<BluetoothDiscoveryResult> scanResults = [];
//   bool isScanning = false;
//   bool isTapped = false;
//   DeviceIdentifier? tappedDeviceId;

//   @override
//   void initState() {
//     super.initState();
//     startScan();
//   }

//   // void monitorDeviceConnection(BluetoothDevice device) {
//   //   device.state.listen((BluetoothConnectionState state) {
//   //     if (state == BluetoothConnectionState.connected) {
//   //       print("Device is now connected");
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(
//   //           backgroundColor: Colors.lightGreen,
//   //           content: Text("Device is now connected!"),
//   //         ),
//   //       );
//   //       Navigator.push(
//   //           context,
//   //           MaterialPageRoute(
//   //             builder: (context) =>
//   //                 UserMonitorPage(device: device, deviceName: device.advName),
//   //           ));
//   //     } else if (state == BluetoothConnectionState.disconnected) {
//   //       print("Device is now disconnected");
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(
//   //           backgroundColor: Colors.red[300],
//   //           content: Text("Device is now Disconnected!"),
//   //         ),
//   //       );
//   //     }
//   //   });
//   // }

//   void startScan() async {
//     try {
//       setState(() {
//         Future.delayed(Duration(seconds: 2));
//         isScanning = true;
//       });
//       final result = await FlutterBluetoothSerial.instance.startDiscovery();
//       result.listen((result) {
//         scanResults.add(result);
//         print(
//             'Discovered device: ${result.device.name} (${result.device.address})');
//       });

//       setState(() {
//         isScanning = false;
//       });
//     } catch (e) {
//       print(e);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.red[300],
//           content: Text(
//             "Error Scanning for Devices! Try Again!",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       );
//       setState(() {
//         isScanning = false;
//       });
//     }
//   }

//   // void connectToDevice(BluetoothDevice device) async {
//   //   try {
//   //     FlutterBluetoothSerial.instance.cancelDiscovery();
//   //     BluetoothConnection connection =
//   //         await BluetoothConnection.toAddress(result.device.address);
//   //     print('Connected to the device');
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //         backgroundColor: Colors.lightGreen,
//   //         content: Text(
//   //           "Connected to the device",
//   //           style: TextStyle(color: Colors.white),
//   //         ),
//   //       ),
//   //     );

//   //     connection.input!.listen((Uint8List data) {
//   //       String received = utf8.decode(data);
//   //       print("Received Data: $received");
//   //       setState(() {
//   //         // _receivedData = received;
//   //       });
//   //     }).onDone(() {
//   //       print('Disconnected by remote request');
//   //       setState(() {
//   //         // _isConnected = false;
//   //         // _connection = null;
//   //       });
//   //     });

//   //     // await device.connect();
//   //     // monitorDeviceConnection(device);
//   //   } on FlutterBluePlusException catch (e) {
//   //     print('Connection failed: ${e.toString()}');
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //         backgroundColor: Colors.red[300],
//   //         content: Text(
//   //           "Can't Connect to Device! Try Again!",
//   //           style: TextStyle(color: Colors.white),
//   //         ),
//   //       ),
//   //     );
//   //   }
//   //   setState(() {
//   //     tappedDeviceId = null; // Reset after connecting
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     print("#################");
//     print(scanResults);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Scan for Devices'),
//       ),
//       // body: StreamBuilder<BluetoothDiscoveryResult>(
//       //     stream: null,
//       //     builder: (context, snapshot) {
//       //       print('Snapshot: $snapshot');
//       //       // print(snapshot.data!.device.address);
//       //       if (isScanning) {
//       //         return Center(
//       //           child: Column(
//       //             children: [
//       //               CircularProgressIndicator(
//       //                 valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//       //               ),
//       //               SizedBox(height: 10),
//       //               Text(
//       //                 'Scanning for Devices...',
//       //                 style: TextStyle(color: Colors.blue),
//       //               ),
//       //             ],
//       //           ),
//       //         );
//       //       } else {
//       //         // print(snapshot.data);

//       //         return RefreshIndicator(
//       //           color: Colors.blue,
//       //           edgeOffset: 10,
//       //           onRefresh: () async {
//       //             // startScan();
//       //           },
//       //           child: Container(
//       //             child: Text('Hello ${snapshot.data!.device.name}'),
//       //           ),
//                 // child: ListView.builder(
//                 //   itemCount: snapshot.data!,
//                 //   itemBuilder: (context, index) {
//                 //     // if (scanResults.isEmpty) {
//                 //     //   return Center(
//                 //     //     child: Column(
//                 //     //       children: [
//                 //     //         Icon(
//                 //     //           Icons.error_outline,
//                 //     //           size: 100.0,
//                 //     //           color: Colors.red,
//                 //     //         ),
//                 //     //         Text(
//                 //     //           'No devices found',
//                 //     //           style: TextStyle(color: Colors.red),
//                 //     //         ),
//                 //     //       ],
//                 //     //     ),
//                 //     //   );
//                 //     // }
//                 //     final result = snapshot.data!;
//                 //     isTapped = tappedDeviceId == result.device.id;
//                 //     return Card(
//                 //       child: ListTile(
//                 //         leading: isTapped &&
//                 //                 result.device == scanResults[index].device
//                 //             ? CircularProgressIndicator(
//                 //                 strokeWidth: 3,
//                 //                 valueColor:
//                 //                     AlwaysStoppedAnimation<Color>(Colors.blue),
//                 //               )
//                 //             : Icon(
//                 //                 Icons.phone_android,
//                 //                 color: Colors.blue,
//                 //               ),
//                 //         title: Text(
//                 //           result.device.advName.isEmpty
//                 //               ? 'Unknown Device'
//                 //               : result.device.advName,
//                 //           style: TextStyle(color: Colors.blue),
//                 //         ),
//                 //         subtitle: Text(
//                 //           result.device.id.toString(),
//                 //           style: TextStyle(fontSize: 14, color: Colors.grey),
//                 //         ),
//                 //         onTap: () {
//                 //           setState(() {
//                 //             tappedDeviceId = result.device.id;
//                 //           });
//                 //           connectToDevice(result.device);

//                 //           print(tappedDeviceId);
//                 //           print(scanResults[index].device.id);
//                 //         },
//                 //       ),
//                 //     );
//                 //   },
//                 // ),
//               );
//             }
//           }),
//     );
//   }
// }
