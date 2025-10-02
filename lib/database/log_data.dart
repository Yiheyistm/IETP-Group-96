import 'package:flutter/material.dart';
import 'package:smart_helmet/database/data_helper.dart';
import 'package:smart_helmet/global/constant.dart';

class LogsPage extends StatelessWidget {
  final String userId;

  LogsPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Logs for $userId")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().fetchLogs(userId),
        builder: (context, snapshot) {
          // print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No logs available"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final log = snapshot.data![index];
              return Card(
                child: ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    backgroundColor: bgColor,
                    child: Text(index.toString()),
                  ),
                  title: Text("Temperature: ${log['temperature']} °C"),
                  subtitle: Text(
                    "Gas: ${log['gasLevel']}, Heartbeat: ${log['heartbeat']} BPM\n${log['timestamp']}",
                  ),
                  trailing: Text("GPS: ${log['gps']}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
