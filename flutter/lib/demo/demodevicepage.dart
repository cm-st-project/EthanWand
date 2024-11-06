import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DemoDevicePage extends StatefulWidget{

  @override
  State createState() => _State();

}

class _State extends State<DemoDevicePage>{

  ValueNotifier<int> co2_value = ValueNotifier(400);


  Widget infoDisplay(){
    String info = "";
    int value = 400;
    if (value < 450){
      info = 'The air quality is excellent. The CO2 level is healthy';
    }
    else if (value < 1000){
      info = 'The air quality is acceptable. The CO2 level is moderate and may affect sensitive groups.';
    }
    else if (value < 2000){
      info = "Air quality is unhealthy. CO2 level is high and may cause health effects in individuals. Consider moving outside or opening a window if you're indoors.";
    }
    else{
      info = "Air quality is very unhealthy. CO2 level is extremely high and risk of severe health effects is increased. Please consider air ventilation/purification.";
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${value} ppm',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Divider(
            color: Colors.black54,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Text(
            info,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );

  }

  Widget bodyView(){

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ValueListenableBuilder<int>(
              valueListenable: co2_value,
              builder: (context, value, child){
                Color cardColor = Color(0xFFCCCCCC);
                if (value < 0){
                  cardColor = Color(0xFFCCCCCC);
                }
                else if (value < 450){
                  cardColor = Color(0xFF99FF99);
                }
                else if (value < 1000){
                  cardColor = Color(0xFFFFFF99);
                }
                else if (value < 2000){
                  cardColor = Color(0xFFFFB266);
                }
                else{
                  cardColor = Color(0xFFFF6666);
                }


                return Card(
                  color: cardColor,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Column(
                      children: [
                        Row(),
                        Text(
                          "CO2 Reading",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),



                        co2_value.value > 0 ?
                        infoDisplay() :
                        Text('LOADING...'),

                        // ValueListenableBuilder<int>(
                        //     valueListenable: co2_value,
                        //     builder: (context, value, child){
                        //       return co2_value.value > 0 ?
                        //       infoDisplay() :
                        //       Text('LOADING...');
                        //
                        //     }
                        //   ),


                        //
                        // Text(
                        //   co2_value.value > 0 ? Text('$co2_value') : Text('LOADING...'),
                        //   style: Theme.of(context).textTheme.titleLarge,
                        // )


                      ],
                    ),
                  ),
                );
              }
          )
        ],
      ),
    );
  }


  @override
  Widget build(context){
    String deviceName = "CO2 Necklace - Unicorn";
    return Scaffold(
      appBar: AppBar(
          title: Text(deviceName)
      ),
      body: Column(
        children: [


          bodyView(),
        ],
      ),
    );
  }


}