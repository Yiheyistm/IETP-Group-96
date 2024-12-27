// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:ietp_g96/user/user_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class CheckConnection extends StatefulWidget {
  const CheckConnection({super.key});

  @override
  State<CheckConnection> createState() => _CheckConnectionState();
}

class _CheckConnectionState extends State<CheckConnection> {
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
                  UserMonitorPage(device: device, connection: connection)));
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
    print(locStatus);
    print(status);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Connection'),
      ),
      body: _isLoading
          ? Center(
              child: const CircularProgressIndicator(
              color: Colors.lightBlue,
            ))
          : _isConnected
              ? const Text('Connected')
              : Column(
                  children: [
                    const Text('Not Connected'),
                    SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        check_con();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: const Text(
                            'Connect',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
