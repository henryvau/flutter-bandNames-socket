import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:io';

enum ServerStatus { OnLine, OffLine, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => this._socket;

  Function get emit  => this._socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    this._socket = IO.io('http://192.168.8.98:3000',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect()  // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build()
    );
    this._socket.connect();

    this._socket.onConnect((data) => print('connected'));

    this._socket.on('connect', (_) {
      _serverStatus = ServerStatus.OnLine;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.OffLine;
      print('disconnected');
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (payload) {
    //   print('nuevo mensaje:');
    //   print('nombre:' + payload['nombre']);
    //   print('mensaje:' + payload['mensaje']);
    //   print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'no hay' );
    // });

  }
}
