import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import '../services/band_socket.dart';
import 'package:app_sockets/models/band_names.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [];

  @override
  void initState() {
    final BandSocketService bandSocketService =
        Provider.of<BandSocketService>(context, listen: false);

    bandSocketService.socket.on('list-bands', _handleListBands);
    super.initState();
  }

  _handleListBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final BandSocketService bandSocketService =
        Provider.of<BandSocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BandNames Pool'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: bandSocketService.serverStatus == ServerStatus.online
                ? const Icon(Icons.check_box_rounded)
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          _pieChart(),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (_, i) {
                return listTileBand(bands[i]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget listTileBand(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => _removeBand(band.id),
      background: Container(
          padding: const EdgeInsets.only(left: 10),
          alignment: Alignment.centerLeft,
          color: Colors.red,
          child: const Text('Delete',
              style: TextStyle(color: Colors.white, fontSize: 20))),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo[300],
          child: Text(band.name.substring(0, 2),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        title: Text(band.name, style: const TextStyle(fontSize: 18)),
        trailing: Text(band.votes, style: const TextStyle(fontSize: 17)),
        onTap: () {
          final BandSocketService bandSocketService =
              Provider.of<BandSocketService>(context, listen: false);

          bandSocketService.emit('vote-band', {'id': band.id});
        },
      ),
    );
  }

  // Method for Add new Band
  void addNewBand() {
    final textController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add new band'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                color: Colors.indigo,
                elevation: 5,
                onPressed: () => addBandToList(textController.text),
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        });
  }

  void addBandToList(String name) {
    if (name.isNotEmpty) {
      final bandSocketService =
          Provider.of<BandSocketService>(context, listen: false);
      bandSocketService.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  void _removeBand(String id) {
    final bandSocketService =
        Provider.of<BandSocketService>(context, listen: false);
    bandSocketService.emit('delete-band', {'id': id});
  }

  Widget _pieChart() {
    if (bands.isNotEmpty) {
      Map<String, double> dataMap = {};
      //dataMap.putIfAbsent('Flutter', () => 5);

      for (var band in bands) {
        dataMap.addEntries({band.name: double.parse(band.votes)}.entries);
      }
      return SizedBox(
          width: double.infinity,
          height: 250,
          child: PieChart(dataMap: dataMap));
    }

    return Container();
  }
}
