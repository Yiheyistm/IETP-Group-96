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
    if (widget.alertMessage.isNotEmpty) {
      _blinkTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
        setState(() {
          _isVisible = !_isVisible; // Toggle visibility
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return widget.alertMessage.isNotEmpty && _isVisible
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Alert",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Icon(
                      Icons.warning,
                      color: Colors.white,
                      size: 40,
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "${widget.alertMessage}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ],
            ),
          )
        : SizedBox();
  }
}
