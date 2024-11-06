import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class TennisNotifications extends StatefulWidget{

  final BluetoothCharacteristic? notifyCharacteristic;
  const TennisNotifications({super.key, required this.notifyCharacteristic});

  @override
  State<TennisNotifications> createState() => _State();

}


class _State extends State<TennisNotifications>{
  static const String notify_uuid  = "0000fff1-0000-1000-8000-00805f9b34fb";

  List<String> messages = ["notify"];


  @override
  void initState() {
    super.initState();
    if (widget.notifyCharacteristic == null) {
      messages = ["Notify Characteristic is null"];
    }
    else {
      print("Notify Characteristic is not null");
      widget.notifyCharacteristic!.onValueReceived.listen(
        (value) {
          print("Received ${value}");
          setState(() {
            messages.add("$value");
          });
        }
      );
    }
  }




  @override
  Widget build(context){
    return ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index){
          return Card(child: ListTile(title: Text("${messages[index]}")));
        }
    );
  }

}