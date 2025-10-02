// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:smart_helmet/aboutUs/about_us.dart';
import 'package:smart_helmet/aboutUs/tips.dart';
import 'package:smart_helmet/database/log_data.dart';
import 'package:smart_helmet/us/meet_our_team.dart';

class UserDrawer extends StatefulWidget {
  BluetoothConnection? connection;
  UserDrawer({
    Key? key,
    required this.connection,
  }) : super(key: key);
  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      image: AssetImage('assets/icon.png'), fit: BoxFit.cover)),
              child: SizedBox()),
          ListTile(
            leading: Icon(Icons.refresh, color: Colors.amber),
            title: Text('Refresh'),
            onTap: () {
              // Call refresh functionality
              _listenData();
              Navigator.of(context).pop(); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.people, color: Colors.amber),
            title: Text('Meet our teams'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MeetOurTeamPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lightbulb_outline),
            title: Text('Tips'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TipsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About Us'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.link_off, color: Colors.red),
            title: Text('Disconnect'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              // Handle disconnect
              _disconnectFromDevice();
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: Colors.white),
            title: Text('Logs'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => LogsPage(userId: "User")),
              );
            },
          ),
        ],
      ),
    );
  }

  void _listenData() {
    setState(() {});
    print("Refreshed");
  }

  Future<void> _disconnectFromDevice() async {
    await widget.connection?.finish();
    setState(() {
      widget.connection = null;
    });
  }
}
