import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as i_o;

enum ServerStatus { online, offline, connecting }

class BandSocketService extends ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;

  late i_o.Socket _socket;

  i_o.Socket get socket => _socket;

  get emit => _socket.emit;

  BandSocketService() {
    _init();
  }

  get serverStatus => _serverStatus;

  _init() {
    _socket = i_o.io('http://10.0.2.2:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
}
