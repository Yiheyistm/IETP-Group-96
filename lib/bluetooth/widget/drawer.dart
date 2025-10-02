import 'package:flutter/material.dart';
import 'package:smart_helmet/aboutUs/about_us.dart';
import 'package:smart_helmet/aboutUs/tips.dart';
import 'package:smart_helmet/us/meet_our_team.dart';

class BluetoothDrawer extends StatefulWidget {
  const BluetoothDrawer({super.key});

  @override
  State<BluetoothDrawer> createState() => _BluetoothDrawerState();
}

class _BluetoothDrawerState extends State<BluetoothDrawer> {
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
        ],
      ),
    );
  }
}
