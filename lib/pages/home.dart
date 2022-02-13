import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            //child: Icon(Icons.check_circle, color: Colors.blue[300],),
            child: (socketService.serverStatus == ServerStatus.OffLine)
                ? Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  )
                : Icon(
                    Icons.check_circle,
                    color: Colors.blue[300],
                  ),
          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => bandTile(bands[i]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1.0,
        onPressed: addNewBand,
      ),
    );
  }

  Widget bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
        key: Key(band.id),
        direction: DismissDirection.startToEnd,
        onDismissed: (_) => socketService.emit('delete-band', {'id': band.id}),
        background: Container(
          padding: EdgeInsets.only(left: 8.0),
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Delete Band',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name.substring(0, 2)),
            backgroundColor: Colors.blue[100],
          ),
          title: Text(band.name),
          trailing: Text(
            '${band.votes}',
            style: TextStyle(fontSize: 20.0),
          ),
          onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
        ));
  }

  addNewBand() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('New band name'),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                  child: Text('Add'),
                  elevation: 5.0,
                  textColor: Colors.blue,
                  onPressed: () => addBandToList(textController.text),
                )
              ],
            );
          });
    }
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('New band name'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Add'),
                onPressed: () => addBandToList(textController.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Dimiss'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Widget _showGraph(){
    Map<String, double> dataMap = new Map();
    bands.forEach((band) {
      dataMap.putIfAbsent( band.name, () => band.votes.toDouble() );
    });

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      width: double.infinity,
      height: 200,
      child: PieChart(dataMap: dataMap,),
    );

  }


}
