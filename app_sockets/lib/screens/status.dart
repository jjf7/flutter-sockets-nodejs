import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_sockets/services/band_socket.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ServerStatus serverStatus =
        Provider.of<BandSocketService>(context).serverStatus;
    return Scaffold(
      body: Center(
        child: Text('$serverStatus', style: const TextStyle(fontSize: 30)),
      ),
    );
  }
}
