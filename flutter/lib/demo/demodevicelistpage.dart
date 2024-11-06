import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'demodevicepage.dart';
import 'demodevicepage2.dart';

class DemoListView extends StatefulWidget{

  @override
  State createState() => _State();

}

class _State extends State<DemoListView>{

  void NavigateToDevicePage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DevicePage2())
    );
  }


  Widget deviceListViewBuilder(){

    return ListView(
      children: [
        Card(child:
          ListTile(
            title: Text("GoldenSnitch"),
            trailing: const Icon(Icons.chevron_right),
            onTap: (){ NavigateToDevicePage(); },
            ),
          )
      ],
    );

    // return ListView.builder(
    //     shrinkWrap: true,
    //     itemCount: results.length,
    //     itemBuilder: (context, index){
    //       print('Name: ${results[index].rssi.toString()}');
    //       print('advertisementData: ${results[index].advertisementData}');
    //       var adv = results[index].advertisementData;
    //       BluetoothDevice device = results[index].device;
    //       return Card(child:
    //       ListTile(
    //         title: Text(adv.localName),
    //         trailing: const Icon(Icons.chevron_right),
    //         onTap: (){ onDevicePress(device); },
    //       ),
    //       );
    //     }
    // );
  }


  @override
  Widget build(context){
    return Column(
      children: [
        ElevatedButton(
            onPressed: (){},
            child: const Text('Refresh')
        ),
        Expanded(child: deviceListViewBuilder()),
      ],
    );
  }


}