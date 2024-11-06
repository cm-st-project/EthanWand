import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import 'package:speech_to_text/speech_to_text.dart';

class DevicePage2 extends StatefulWidget{


  const DevicePage2({super.key});

  @override
  State createState() => _State();

}

class _State extends State<DevicePage2>{

  final asciiEncoder = AsciiEncoder();

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';


  @override
  void initState() {
    super.initState();
  }


  Widget bluetoothBody(){
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){}, child: const Text("Red")),
            ElevatedButton(onPressed: (){}, child: const Text("Green")),
            ElevatedButton(onPressed: (){}, child: const Text("Blue")),
            ElevatedButton(onPressed: (){}, child: const Text("Purple")),
            ElevatedButton(onPressed: (){}, child: const Text("Off")),


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
                onPressed: _speechToText.isNotListening ? (){} : (){},
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
    String deviceName = "GoldenSnitch";
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