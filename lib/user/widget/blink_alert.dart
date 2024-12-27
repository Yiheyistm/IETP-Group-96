// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';

class AlertBlinkScreen extends StatefulWidget {
  final String alertMessage;
  AlertBlinkScreen({required this.alertMessage});
  @override
  _AlertBlinkScreenState createState() =>
      _AlertBlinkScreenState(alertMessage: alertMessage);
}

class _AlertBlinkScreenState extends State<AlertBlinkScreen> {
  _AlertBlinkScreenState({required this.alertMessage});
  bool _isVisible = true; // Controls the visibility of the widget
  Timer? _blinkTimer;
  String alertMessage = "";

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  @override
  void dispose() {
    _blinkTimer?.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  void _startBlinking() {
    // Only start blinking if there is an alert message
    if (alertMessage.isNotEmpty) {
      _blinkTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
        setState(() {
          _isVisible = !_isVisible; // Toggle visibility
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return alertMessage.isNotEmpty && _isVisible
        ? Card(
            color: Colors.red[500],
            child: ListTile(
              title: Text(
                "Alerts:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                alertMessage,
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        : SizedBox();
  }
}
