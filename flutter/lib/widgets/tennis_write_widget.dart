import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class TennisWrite extends StatefulWidget{

  final BluetoothCharacteristic? writeCharacteristic;
  const TennisWrite({super.key, required this.writeCharacteristic});

  @override
  State<TennisWrite> createState() => _State();

}


class _State extends State<TennisWrite>{
  static const String write_uuid  = "0000fff2-0000-1000-8000-00805f9b34fb";

  // Range of 80 - 180
  int velocity = 80;
  int min_velocity = 80;
  int max_velocity = 180;


  // Range of 80 - 180
  // int h_angle = 80;
  // int min_velocity = 80;
  // int max_velocity = 180;


  String debugMessage = "";


  @override
  void initState() {
    super.initState();
    if (widget.writeCharacteristic == null) {
    }
    else {
      // widget.writeCharacteristic!.onValueReceived.listen(
      //   (value) {
      //     print("Received ${value}");
      //     setState(() {
      //       messages.add("$value");
      //     });
      //   }
      // );
    }
  }

  void writeToTennisDevice() async {

    if(widget.writeCharacteristic == null){
      debugMessage = "Write Characteristic is Null";
      setState(() {});
      return;
    }

    debugMessage = "";
    List<int> message = [];

    // AA 67 00 00 00 00 00 00 00 A5
    // Battery SOC
    // message = [0xAA,0x67,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xA5];

    // Set Velocity
    // AA 63 XX 00 00 00 00 00 00 A5
    message = [0xAA,0x63, velocity, 0x00,0x00,0x00,0x00,0x00,0x00,0xA5];
    print("Set Velocity $message, ${message.length}");
    await widget.writeCharacteristic!.write(message);

    // Start Fixed Serve
    // AA 6A 01 00 00 00 00 00 00 A5
    message = [0xAA,0x6A, 01, 0x00,0x00,0x00,0x00,0x00,0x00,0xA5];
    print("Start Fixed Serve $message, ${message.length}");
    await widget.writeCharacteristic!.write(message);

    // Alarm
    // AA 66 00 00 00 00 00 00 00 A5
    message = [0xAA,0x66,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xA5];
    print("Alarm $message");
    await widget.writeCharacteristic!.write(message);

    setState(() {});
  }

  void stopCommand() async {
    if(widget.writeCharacteristic == null){
      debugMessage = "Write Characteristic is Null";
      setState(() {});
      return;
    }
    debugMessage = "Stopping";
    List<int> message = [];
    // Stop
    // AA 6B 00 00 00 00 00 00 00 A5
    message = [0xAA,0x6B,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xA5];
    print("Stop $message, ${message.length}");
    await widget.writeCharacteristic!.write(message);


    // Alarm
    // AA 66 00 00 00 00 00 00 00 A5
    // message = [0xAA,0x66,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xA5];
    // print("Alarm $message");
    // await widget.writeCharacteristic!.write(message);

    setState(() {});
  }


  @override
  Widget build(context){
    return Column(

      children: [
        Text("Velocity: $velocity"),
        Slider(
          value: velocity.toDouble(),
          min: min_velocity.toDouble(),
          max: max_velocity.toDouble(),
          onChanged: (double value) {
            setState(() {
              velocity = value.round();
            });
          },
          label: velocity.round().toString(),
        ),
        ElevatedButton(onPressed: writeToTennisDevice, child: Text("Start")),
        ElevatedButton(onPressed: stopCommand, child: Text("Stop")),
        Text("$debugMessage"),

      ],

    );
  }

}