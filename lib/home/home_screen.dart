// ignore_for_file: unused_field, deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:ietp_g96/bluetooth/bluetooth_off_screen.dart';
import 'package:ietp_g96/bluetooth/check_connection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<BluetoothState> _bluetoothStateSubscription;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  void _getCurrentBluetoothState() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    print('HomeScreen initState');
    _getCurrentBluetoothState();
    _bluetoothStateSubscription = FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      print('Bluetooth state changed: $state');
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  @override
  void dispose() {
    _bluetoothStateSubscription.cancel();
    super.dispose();
  }

  _updateState(state) {
    setState(() {
      _bluetoothState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_bluetoothState);
    Widget screen = _bluetoothState == BluetoothState.STATE_ON
        ? const CheckConnection()
        : BluetoothOffScreen(
            onStateUpdate: _updateState,
          );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notification Example',
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(primaryColor: Colors.blue),
      home: screen,
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

// This observer listens for Bluetooth Off and dismisses the DeviceScreen
//
class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _adapterStateSubscription ??= FlutterBluetoothSerial.instance
          .onStateChanged()
          .listen((BluetoothState state) {
        if (state != BluetoothState.STATE_ON) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}
