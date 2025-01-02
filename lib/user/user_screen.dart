// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smart_helmet/database/data_helper.dart';
import 'package:smart_helmet/global/constant.dart';
import 'package:smart_helmet/global/global.dart';
import 'package:smart_helmet/notification/notification_service.dart';
import 'package:smart_helmet/user/widget/blink_alert.dart';
import 'package:smart_helmet/user/widget/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class UserMonitorPage extends StatefulWidget {
  final BluetoothConnection connection;
  final BluetoothDevice device;

  const UserMonitorPage({
    super.key,
    required this.connection,
    required this.device,
  });

  @override
  _UserMonitorPageState createState() => _UserMonitorPageState();
}

class _UserMonitorPageState extends State<UserMonitorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BluetoothDevice? device;
  BluetoothConnection? _connection;
  double temperature = 37.0;
  double gasLevel = 200;
  double heartbeat = 72;
  List<double> gps = [8.8852, 38.8098];
  String alertMessage = "";
  double tempTemperature = 37;
  double tempHeartbeat = 65;
  double tempGas = 2000;
//   String givenData = '''
//   Heartbeat: 200
//   Temperature: 73
//   Gas: 400
//   GPS: [8.8852, 38.8098]
// ''';

  Map<String, dynamic> sensorData = {};
  final String phoneNumber = "0928930401";
  String get message =>
      '''Hello, I need help!\n My location is: ${"https://www.google.com/maps/search/?api=1&query=${gps[0]},${gps[1]}"}.''';
  @override
  void initState() {
    _connection = widget.connection;
    device = widget.device;
    _listenData();

    super.initState();
    // sensorData = parseArduinoData(givenData);
  }

  Future<void> _listenData() async {
    Future.delayed(Duration(seconds: 0)).then((value) {
      if (_connection != null) {
        _connection!.input?.listen((Uint8List data) {
          final rawData = String.fromCharCodes(data);
          // print(rawData);
          try {
            sensorData = parseArduinoData(rawData);

            // print(data);
            setState(() {
              temperature = sensorData['Temperature'] ?? tempTemperature;
              gasLevel = sensorData['Gas'] ?? tempGas;
              heartbeat = sensorData['Heartbeat'] ?? tempHeartbeat;
              gps = sensorData['GPS'] ?? [8.8852, 38.8098];
              if (sensorData['Heartbeat'] != null) {
                tempHeartbeat = sensorData['Heartbeat'];
              }
              if (sensorData['Temperature'] != null) {
                tempTemperature = sensorData['Temperature'];
              }
              if (sensorData['Gas'] != null) {
                tempGas = sensorData['Gas'];
              }
            });

            checkThresholds();
            logData();
          } catch (e) {
            print("Error parsing data: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red[200],
                content: Text('Something went wrong!'),
              ),
            );
          }
        }, onError: (error) {
          print('Error: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[200],
              content: Text('Something went wrong!'),
            ),
          );
        });
      }
    });
  }

  Future<void> _sendData(int value) async {
    if (_connection != null) {
      Uint8List bytes = Uint8List.fromList(utf8.encode(value.toString()));
      _connection!.output.add(bytes);
      await _connection!.output.allSent;
    }
  }

  Map<String, dynamic> parseArduinoData(String givenData) {
    // Regular expressions
    final tempRegex = RegExp(r'Temperature \(Â°C\): ([\d.]+)');
    final gpsRegex =
        RegExp(r'GPS Data: \[Latitude: ([\d.-]+), Longitude: *([\d.-]+)\]');
    final gasRegex = RegExp(r'Gas Sensor Value: (\d+)');
    final heartRateRegex = RegExp(r'Heart Rate \(BPM\): (\d+)');

    // Initialize a result map
    Map<String, dynamic> sensorData = {};

    // Extract data
    final tempMatch = tempRegex.firstMatch(givenData);
    final gpsMatch = gpsRegex.firstMatch(givenData);
    final gasMatch = gasRegex.firstMatch(givenData);
    final heartRateMatch = heartRateRegex.firstMatch(givenData);

    // Display results
    if (tempMatch != null) {
      sensorData['Temperature'] = double.parse(tempMatch.group(1)!);
    }
    if (gpsMatch != null) {
      print(
          'GPS Data: Latitude: ${gpsMatch.group(1)}, Longitude: ${gpsMatch.group(2)}');
      sensorData['GPS'] = [
        double.parse(gpsMatch.group(1)!),
        double.parse(gpsMatch.group(2)!)
      ];
    }
    if (gasMatch != null) {
      // print('Gas Sensor Value: ${gasMatch.group(1)}');
      sensorData['Gas'] = double.parse(gasMatch.group(1)!);
    }
    if (heartRateMatch != null) {
      // print('Heart Rate (BPM): ${heartRateMatch.group(1)}');
      sensorData['Heartbeat'] = double.parse(heartRateMatch.group(1)!);
    }

    // // Match and extract Heartbeat data
    // final heartbeatMatch = heartbeatRegExp.firstMatch(data);
    // if (heartbeatMatch != null) {
    //   sensorData['Heartbeat'] = double.parse(heartbeatMatch.group(1)!);
    // }

    // // Match and extract Temperature data
    // final temperatureMatch = temperatureRegExp.firstMatch(data);
    // if (temperatureMatch != null) {
    //   sensorData['Temperature'] = double.parse(temperatureMatch.group(1)!);
    // }

    // // Match and extract Gas data
    // final gasMatch = gasRegExp.firstMatch(data);
    // if (gasMatch != null) {
    //   sensorData['Gas'] = double.parse(gasMatch.group(1)!);
    // }

    // // Match and extract GPS data
    // final gpsMatch = gpsRegExp.firstMatch(data);
    // if (gpsMatch != null) {
    //   sensorData['GPS'] = [
    //     double.parse(gpsMatch.group(1)!),
    //     double.parse(gpsMatch.group(2)!)
    //   ];
    // }

    return sensorData;
  }

  void checkThresholds() {
    alertMessage = "";

    // if three conditions are met
    if (temperature > tempThresholdHigh &&
        gasLevel > gasThreshold &&
        heartbeat > heartbeatThresholdHigh) {
      alertMessage += '''
    All Thresholds Reached!\n
    High Temperature!\n
    Hazardous Gas!\n
    Abnormal Heartbeat!\n''';
      NotificationService().showNotification(
          title: "Alert: All Thresholds Reached",
          body:
              "The temperature, gas level, and heartbeat values have exceeded the safe thresholds.",
          payload: "All Thresholds",
          intesities: "High");
    } else if (temperature > tempThresholdHigh) {
      alertMessage += "High Temperature!\n";
      NotificationService().showNotification(
          title: "Alert: Temperature Threshold Reached",
          body:
              "The temperature value is $temperature, which exceeds the safe threshold.",
          payload: "Temperature Threshold",
          intesities: "High");
    } else if (temperature < tempThresholdLow) {
      alertMessage += "Low Temperature!\n";
      NotificationService().showNotification(
          title: "Alert: Temperature Threshold Reached",
          body:
              "The temperature value is $temperature, which is below the safe threshold.",
          payload: "Temperature Threshold",
          intesities: "Low");
    } else if (gasLevel > gasThreshold) {
      alertMessage += "Hazardous Gas!\n";
      NotificationService().showNotification(
          title: "Alert: Gas Threshold Reached",
          body: "The gas level is $gasLevel, which exceeds the safe threshold.",
          payload: "Gas Threshold",
          intesities: "Normal");
    } else if (heartbeat < heartbeatThresholdLow ||
        heartbeat > heartbeatThresholdHigh) {
      alertMessage += "Abnormal Heartbeat!\n";
      NotificationService().showNotification(
          title: "Alert: Heartbeat Threshold Reached",
          body:
              "The heartbeat value is $heartbeat, which is outside the safe threshold.",
          intesities: "Normal");
    }
    // setState(() {});
  }

  void logData() async {
    await DatabaseHelper().insertLog({
      'temperature': temperature,
      'gasLevel': gasLevel,
      'heartbeat': heartbeat,
      'gps': gps.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<void> openMap(double latitude, double longitude) async {
    final Uri googleMapsUrl = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");
    try {
      await launchUrl(googleMapsUrl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $googleMapsUrl')),
      );
      throw 'Could not launch $googleMapsUrl';
    }
  }

  void sendSMS() async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message},
    );
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Could not send SMS';
    }
  }

  void makeCall() async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not make the call';
    }
  }

  @override
  void dispose() {
    _connection?.finish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(sensorData);
    print(alertMessage);

    return Scaffold(
      key: _scaffoldKey,
      drawer: UserDrawer(
        connection: _connection,
      ),
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 1,
        title: Text(
          "Smart Helmet ${device?.name.toString().substring(0, 8)}...",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Tooltip(
            message: 'Show on the map',
            child: IconButton(
              icon: Icon(
                Icons.map,
                color: Colors.blueAccent,
              ),
              onPressed: () => openMap(gps[0].toDouble(), gps[1].toDouble()),
            ),
          ),
          SizedBox(
            width: 8,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: secondaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Heart Rate",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Icon(
                        Icons.monitor_heart_outlined,
                        color: Colors.lightGreenAccent,
                        size: 40,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "$heartbeat BPM",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: heartbeat > heartbeatThresholdHigh
                            ? Colors.red
                            : Colors.green),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Heartbeat: 75 BPM",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: secondaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Temprature",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Icon(
                        Icons.device_thermostat,
                        color: Colors.blueAccent,
                        size: 40,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "$temperature °C",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: temperature > tempThresholdHigh
                            ? Colors.red
                            : Colors.green),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Normal range: 20 - 27 °C",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                ],
              ),
            ),

            SizedBox(
              height: 16,
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: secondaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Gas Level",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Icon(
                        Icons.air,
                        color: Colors.yellow,
                        size: 40,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "$gasLevel",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: gasLevel > gasThreshold
                            ? Colors.red
                            : Colors.green),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Normal range: 0 - 2800",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),
            AlertBlinkScreen(alertMessage: alertMessage),

            Spacer(),
            // SOS
            alertMessage.isNotEmpty
                ? GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent),
                        ),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("SOS"),
                                  content: Text(
                                      "Do you want to send an SOS message or Phone call?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          makeCall();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Phone",
                                          style: TextStyle(color: Colors.green),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          sendSMS();

                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "SMS",
                                          style: TextStyle(
                                              color: Colors.blueAccent),
                                        )),
                                  ],
                                );
                              });
                        },
                        icon: Icon(Icons.warning, color: Colors.red),
                        label: Text(
                          "SOS",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 26,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
