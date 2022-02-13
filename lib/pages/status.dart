import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_names/services/socket_service.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('ServerStatus: ${socketService.serverStatus}')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //todo
          print('emitiendo');
          //{ nombre : 'Flutter', mensaje : 'Hello from Flutter'}
          socketService.emit('emitir-mensaje',
              {'nombre': 'Flutter', 'mensaje': 'Hello from Flutter'});
        },
      ),
    );
  }
}
