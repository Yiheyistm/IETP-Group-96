import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothOffScreen extends StatelessWidget {
  // final BluetoothState state;
  final Function(BluetoothState) onStateUpdate;

  const BluetoothOffScreen({Key? key, required this.onStateUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Smart Helmet', style: TextStyle(color: Colors.amber)),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.bluetooth_disabled,
                size: 100.0,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                'Bluetooth is currently turned off.',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GestureDetector(
                  onTap: () async {
                    if ((await FlutterBluetoothSerial.instance
                            .requestEnable()) ??
                        false) {
                      if (await FlutterBluetoothSerial.instance.state ==
                          BluetoothState.STATE_ON) {
                        onStateUpdate(BluetoothState.STATE_ON);
                      }
                    }
                    
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bluetooth,
                        size: 40.0,
                        color: Colors.white,
                      ),
                      Text(
                        "Turn On Bluetooth",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
