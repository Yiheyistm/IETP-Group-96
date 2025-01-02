import 'package:flutter/material.dart';
import 'package:smart_helmet/global/constant.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Smart Helmet",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 12),
            decoration: BoxDecoration(
                color: secondaryColor, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Us',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Welcome to Smart Helmet Solutions! We specialize in innovative safety gear that combines technology and practicality to provide a comprehensive safety solution. Our smart helmet is designed to ensure the safety of individuals in hazardous environments by integrating sensors for temperature, gas, gps and heartbeat monitoring.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Key Features of Our Smart Helmet:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '1. Temperature monitoring to prevent heat-related incidents.\n'
                  '2. Gas detection to alert users of hazardous gases.\n'
                  '3. Heartbeat monitoring for real-time health tracking.\n'
                  '4. Bluetooth connectivity for seamless data transmission.\n'
                  '5. GPS location tracker using real time location data.\n'
                  '6. Alerts and notifications when thresholds are exceeded.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Our Mission:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'To enhance personal safety through technology and provide reliable solutions for monitoring health and environmental hazards.',
                  style: TextStyle(fontSize: 16),
                ),
                // meet our teams
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
