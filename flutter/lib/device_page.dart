import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import 'package:speech_to_text/speech_to_text.dart';

class DevicePage extends StatefulWidget{

  final BluetoothDevice device;

  const DevicePage({super.key, required this.device});

  @override
  State createState() => _State();

}

class _State extends State<DevicePage>{

  final asciiEncoder = AsciiEncoder();

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';



  BluetoothCharacteristic? writeCharacteristic;
  BluetoothCharacteristic? notifyCharacteristic;

  @override
  void initState() {
    super.initState();

    _initSpeech();

    print(widget.device);
    print(widget.device.servicesList);

    discoverServices();

    widget.device.connectionState.listen((BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.disconnected) {
        print("Disconnected: ${widget.device.disconnectReason}");
        // Navigator.pop(context);
      }
    });
  }


  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      // print(_lastWords);
      parseTextToCommand(_lastWords);
    });
  }

  void parseTextToCommand(String text){
    Map<String, String> legend = {
      "red": "a",
      "read": "a",
      "green": "b",
      "blue": "c",
      "off": "d",
      "purple": "e",
    };

    List<String> words  = text.split(' ');
    for(String word in words){
      if(legend.containsKey(word.toLowerCase())){
        String message = legend[word.toLowerCase()]!;
        sendMessageToSnitch(message);
        _lastWords = word.toLowerCase();
        _stopListening();
        break;
      }
    }
    print(words);
  }


  void discoverServices() async {

    print("discovering Services");

    List<BluetoothService> services = await widget.device.discoverServices();
    for(BluetoothService service in services){
      print(service);
    }

    print("done discovering Services");
    print(widget.device.servicesList);

    setState(() { });

  }

  int bytesToInteger(List<int> bytes) {
    print("bytes");
    String charValues = '';
    for(int i in bytes){
      charValues = charValues + String.fromCharCode(i) ;
    }
    return int.parse(charValues);
  }




  void sendMessageToSnitch(String message) async {
    for(BluetoothService services in widget.device.servicesList) {
      // print(services.includedServices);
      for (BluetoothCharacteristic characteristic in services.characteristics) {
        try {
          List<int> encodedMessage = asciiEncoder.convert(message);
          await characteristic.write(encodedMessage, withoutResponse: characteristic.properties.writeWithoutResponse);
          print("wrote something");
        } on Exception catch (_) {
          print("couldn't write");
        }
      }
    }

  }


  Widget bluetoothBody(){
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){sendMessageToSnitch("a");}, child: const Text("Red")),
            ElevatedButton(onPressed: (){sendMessageToSnitch("b");}, child: const Text("Green")),
            ElevatedButton(onPressed: (){sendMessageToSnitch("c");}, child: const Text("Blue")),
            ElevatedButton(onPressed: (){sendMessageToSnitch("e");}, child: const Text("Purple")),
            ElevatedButton(onPressed: (){sendMessageToSnitch("d");}, child: const Text("Off")),

            // const SizedBox( height: 30 ),

            // Text(
            //     _speechToText.isListening?
            //     '$_lastWords'
            //   : _speechEnabled
            //   ? 'Tap the microphone to start listening...'
            //   : 'Speech not available',
            // ),

            Spacer(),

            Text(
                _speechToText.isListening?
                    "Listening..."

              : _speechEnabled
              ? 'Tap the microphone to start listening...'
              : 'Speech not available',
            ),

            Padding(
              padding: const EdgeInsets.all(45.0),
              child: ElevatedButton(
                  onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
                  child: Icon(_speechToText.isNotListening ?  Icons.mic : Icons.mic_off),
              ),
            ),

          ],
        ),
      ),
    );
  }


  @override
  Widget build(context){
    String deviceName = widget.device.name;
    return Scaffold(
      appBar: AppBar(
        title: Text(deviceName)
      ),
      body: Column(
        children: [
          bluetoothBody(),
        ],
      ),
    );
  }


}