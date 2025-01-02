// ignore_for_file: unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_helmet/aboutUs/web_view.dart';
import 'package:smart_helmet/bluetooth/widget/drawer.dart';
import 'package:smart_helmet/global/constant.dart';
import 'package:smart_helmet/user/user_screen.dart';

class CheckConnection extends StatefulWidget {
  const CheckConnection({super.key});

  @override
  State<CheckConnection> createState() => _CheckConnectionState();
}

class _CheckConnectionState extends State<CheckConnection> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BluetoothConnection? _connection;
  bool _isLoading = false;
  bool _isConnected = false;

  Future<void> check_con() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final List<BluetoothDevice> devices =
          await FlutterBluetoothSerial.instance.getBondedDevices();
      final BluetoothDevice device =
          devices.firstWhere((d) => d.name == "ESP32_Bluetooth");

      final BluetoothConnection connection =
          await BluetoothConnection.toAddress(device.address);

      if (connection.isConnected) {
        print('Connected to the device');

        setState(() {
          _connection = connection;
          _isLoading = false;
          _isConnected = true;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  UserMonitorPage(
                    connection: _connection!,
                    device: device,
                  )));
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> requestPermission() async {
    final locStatus = await Permission.location.request();
    final status = await Permission.bluetoothScan.request();
    if (status.isGranted && locStatus.isGranted) {
      check_con();
    } else if (status.isDenied ||
        status.isPermanentlyDenied ||
        locStatus.isDenied ||
        locStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  void initState() {
    
    requestPermission();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: BluetoothDrawer(),
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 1,
        title: const Text('Check Connection',
            style: TextStyle(color: Colors.amber, fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(
              message: 'Connect to Smart Helmet',
              child: IconButton.outlined(
                  onPressed: () {
                    // requestPermission();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.black.withOpacity(0.6),
                            title: const Text('Connect to Smart Helmet'),
                            content: const Text(
                                'Please make sure the Smart Helmet is turned on and in range.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel',
                                    style: TextStyle(color: Colors.red)),
                              ),
                              TextButton(
                                onPressed: () {
                                  requestPermission();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Connect',
                                    style: TextStyle(color: Colors.blueAccent)),
                              ),
                            ],
                          );
                        });
                  },
                  icon: Icon(
                    Icons.contactless_sharp,
                    color: Colors.amber,
                  )),
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
     
      body: _isLoading
          ? Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.amberAccent,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text("Finding Nearby Smart Helmet ....")
                  ],
                ),
              ))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.transparent,
                  child: Text(
                    'No Smart Helmet is Connected',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                    ),
                                      
                Expanded(child: HelmetWebView())
                  ],
                ),
    );
  }
}
