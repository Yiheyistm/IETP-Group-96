// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:ietp_g96/aboutUs/about_us.dart';
import 'package:ietp_g96/aboutUs/tips.dart';
import 'package:ietp_g96/database/data_helper.dart';
import 'package:ietp_g96/global/global.dart';
import 'package:ietp_g96/notification/notification_service.dart';
import 'package:ietp_g96/user/widget/blink_alert.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class UserMonitorPage extends StatefulWidget {
  final BluetoothConnection connection;
  final BluetoothDevice device;

  const UserMonitorPage(
      {super.key, required this.device, required this.connection});

  @override
  _UserMonitorPageState createState() => _UserMonitorPageState();
}

class _UserMonitorPageState extends State<UserMonitorPage> {
  BluetoothDevice? device;
  BluetoothConnection? _connection;
  double temperature = 0.0;
  int gasLevel = 0;
  int heartbeat = 0;
  List<int> gps = [0, 0];
  String alertMessage = "";

  @override
  void initState() {
    _connection = widget.connection;
    device = widget.device;
    _listenData();
    // _listenDisconnection();
    super.initState();
    // discoverServices();
  }

  Future<void> _listenData() async {
    if (_connection != null) {
      _connection!.input!.listen((Uint8List data) {
        final rawData = String.fromCharCodes(data);
        print(rawData);
        try {
          // final data = parseArduinoData(rawData);
          // setState(() {
          //   temperature = data['Temperature'];
          //   gasLevel = data['Gas'];
          //   heartbeat = data['heartbeat'];
          //   gps = data['GPS'];
          //   checkThresholds();
          // });
          logData();
        } catch (e) {
          print("Error parsing data: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[200],
              content: Text('Error parsing data: $e'),
            ),
          );
        }
      }, onError: (error) {
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[200],
            content: Text('Error: $error'),
          ),
        );
      });
    }
  }

  // _listenDisconnection() {
  //   // Listen for disconnection events
  //   _connection!.input!.listen(null).onDone(() {
  //     print('Disconnected!');
  //     setState(() {
  //       _connection = null;
  //     });
  //   });
  // }

  Future<void> _sendData(int value) async {
    if (_connection != null) {
      Uint8List bytes = Uint8List.fromList(utf8.encode(value.toString()));
      _connection!.output.add(bytes);
      await _connection!.output.allSent;
    }
  }

  Future<void> _disconnectFromDevice() async {
    await _connection?.finish();
    setState(() {
      _connection = null;
    });
  }

  Map<String, dynamic> parseArduinoData(String data) {
    // Define regular expressions for each sensor type
    final heartbeatRegExp = RegExp(r'heartbeat:\s*(\d+)');
    final temperatureRegExp = RegExp(r'Temperature:\s*(\d+)');
    final gasRegExp = RegExp(r'Gas:\s*(\d+)');
    final gpsRegExp = RegExp(r'GPS:\s*\[(\d+),\s*(\d+)\]');

    // Initialize a result map
    Map<String, dynamic> sensorData = {};

    // Match and extract Heartbeat data
    final heartbeatMatch = heartbeatRegExp.firstMatch(data);
    if (heartbeatMatch != null) {
      sensorData['Heartbeat'] = int.parse(heartbeatMatch.group(1)!);
    }

    // Match and extract Temperature data
    final temperatureMatch = temperatureRegExp.firstMatch(data);
    if (temperatureMatch != null) {
      sensorData['Temperature'] = int.parse(temperatureMatch.group(1)!);
    }

    // Match and extract Gas data
    final gasMatch = gasRegExp.firstMatch(data);
    if (gasMatch != null) {
      sensorData['Gas'] = int.parse(gasMatch.group(1)!);
    }

    // Match and extract GPS data
    final gpsMatch = gpsRegExp.firstMatch(data);
    if (gpsMatch != null) {
      sensorData['GPS'] = [
        int.parse(gpsMatch.group(1)!),
        int.parse(gpsMatch.group(2)!)
      ];
    }

    return sensorData;
  }

  // void discoverServices() async {
  //   setState(() {
  //     temperature = 100;
  //     gasLevel = 400;
  //     heartbeat = 200;
  //     // temperature = data['temperature'];
  //     // gasLevel = data['gasLevel'];
  //     // heartbeat = data['heartbeat'];
  //     checkThresholds();
  //   });
  //   List<BluetoothService> services = await widget.device.discoverServices();
  //   for (BluetoothService service in services) {
  //     for (BluetoothCharacteristic characteristic in service.characteristics) {
  //       if (characteristic.properties.notify) {
  //         characteristic.value.listen((value) {
  //           final rawData = String.fromCharCodes(value);
  //           try {
  //             final data = parseData(rawData);
  //             setState(() {
  //               temperature = 100;
  //               gasLevel = 100;
  //               heartbeat = 100;
  //               temperature = data['temperature'];
  //               gasLevel = data['gasLevel'];
  //               heartbeat = data['heartbeat'];
  //               checkThresholds();
  //             });
  //             logData();
  //           } catch (e) {
  //             print("Error parsing data: $e");
  //           }
  //         });
  //         await characteristic.setNotifyValue(true);
  //       }
  //     }
  //   }
  // }

  void checkThresholds() {
    alertMessage = "";

    // if three conditions are met
    if (temperature > tempThresholdHigh &&
        gasLevel > gasThreshold &&
        (heartbeat < heartbeatThresholdLow ||
            heartbeat > heartbeatThresholdHigh)) {
      alertMessage += "All Thresholds Reached!\n";
      NotificationService().showNotification(
          title: "Alert: All Thresholds Reached",
          body:
              "The temperature, gas level, and heartbeat values have exceeded the safe thresholds.",
          payload: "All Thresholds",
          intesities: "High");
    }
    if (temperature > tempThresholdHigh) {
      alertMessage += "High Temperature!\n";
      NotificationService().showNotification(
          title: "Alert: Temperature Threshold Reached",
          body:
              "The temperature value is $temperature, which exceeds the safe threshold.",
          payload: "Temperature Threshold",
          intesities: "High");
    }
    if (temperature < tempThresholdLow) {
      alertMessage += "Low Temperature!\n";
      NotificationService().showNotification(
          title: "Alert: Temperature Threshold Reached",
          body:
              "The temperature value is $temperature, which is below the safe threshold.",
          payload: "Temperature Threshold",
          intesities: "Low");
    }
    if (gasLevel > gasThreshold) {
      alertMessage += "Hazardous Gas!\n";
      NotificationService().showNotification(
          title: "Alert: Gas Threshold Reached",
          body: "The gas level is $gasLevel, which exceeds the safe threshold.",
          payload: "Gas Threshold",
          intesities: "Normal");
    }
    if (heartbeat < heartbeatThresholdLow ||
        heartbeat > heartbeatThresholdHigh) {
      alertMessage += "Abnormal Heartbeat!\n";
      NotificationService().showNotification(
          title: "Alert: Heartbeat Threshold Reached",
          body:
              "The heartbeat value is $heartbeat, which is outside the safe threshold.",
          payload: "Heartbeat Threshold",
          intesities: "Normal");
    }
    // if (alertMessage.isNotEmpty) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => ThresholdAlertScreen()),
    //   );
    // }
  }

  void logData() async {
    await DatabaseHelper().insertLog({
      'temperature': temperature,
      'gasLevel': gasLevel,
      'heartbeat': heartbeat,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<void> openMap(double latitude, double longitude) async {
    final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $googleMapsUrl')),
      );
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Helmet ${device!.name.toString().substring(8)}...",
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.map,
              color: Colors.amberAccent,
            ),
            onPressed: () => openMap(37.7749, -122.4194),
          ),
          SizedBox(
            width: 8,
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'Refresh':
                  _listenData();
                case 'Tips':
                  // Handle Tips
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TipsPage()));
                  break;
                case 'AboutUs':
                  // Handle About Us
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AboutUsPage()));
                  break;
                case 'disconnect':
                  // Handle Disconnect
                  _disconnectFromDevice();
                  Navigator.of(context).pop();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Refresh',
                child: Text(
                  'Refresh',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Tips',
                child: Text('Tips'),
              ),
              const PopupMenuItem<String>(
                value: 'AboutUs',
                child: Text('About Us'),
              ),
              const PopupMenuItem<String>(
                value: 'disconnect',
                child: Text(
                  'Disconnect',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: Text(
                  "°C",
                  style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                title: Text("Temperature: $temperature °C"),
                subtitle: Text("Normal range: 36.5 - 37.5 °C"),
              ),
            ),
            Card(
              child: ListTile(
                leading: Text(
                  "Gas",
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                title: Text("Gas Level: $gasLevel"),
                subtitle: Text("Normal range: 0 - 50"),
              ),
            ),
            Card(
              child: ListTile(
                leading: Text(
                  "BPM",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                title: Text("Heartbeat: $heartbeat BPM"),
                subtitle: Text("Normal range: 60 - 100 BPM"),
              ),
            ),
            AlertBlinkScreen(alertMessage: alertMessage),
          ],
        ),
      ),
    );
  }
}
