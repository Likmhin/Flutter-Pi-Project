// ignore_for_file: unused_import

import 'dart:developer' as developer;
import 'dart:isolate';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wake_on_lan/wake_on_lan.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

late Future<List<EnvData>> envdata;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: MaterialApp(
        title: 'My Pi App',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 40,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/noob.jpg',
                  fit: BoxFit.contain,
                  height: 32,
                ),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('Flutter Pi Project App'))
              ],
            ),
          ),
          body: const TabBarView(
            children: <Widget>[
              HomeTab(),
              Sensor(),
              UriData(),
            ],
          ),
          bottomNavigationBar: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Home',
                icon: Icon(Icons.home),
              ),
              Tab(
                text: 'Sensors',
                icon: Icon(Icons.sensors),
              ),
              Tab(
                text: 'Data',
                icon: Icon(Icons.info_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 30),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    wakeLan();
                    Fluttertoast.showToast(
                        msg: "Request Sent",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                  child: const Text('Wake on Lan'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SfLinearGauge(
            minimum: 0,
            maximum: 255,
            orientation: LinearGaugeOrientation.vertical,
            barPointers: const [LinearBarPointer(value: 40)],
          ) // Light Sensor
        ],
      ),
    );
  }
}

class Sensor extends StatelessWidget {
  const Sensor({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 250,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: -10,
                maximum: 30,
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: -10,
                      endValue: 0,
                      color: Colors.lightBlueAccent,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: 0,
                      endValue: 10,
                      color: Colors.green,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: 10,
                      endValue: 20,
                      color: Colors.orange,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: 20,
                      endValue: 30,
                      color: Colors.red,
                      startWidth: 10,
                      endWidth: 10)
                ],
              ),
            ],
            title: const GaugeTitle(
                text: 'Temperature',
                textStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ), // Temp Sensor
        ),
        SizedBox(
          height: 250,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 100,
              ),
            ],
            title: const GaugeTitle(
                text: 'Humidity',
                textStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ), // Humidity Sensor
        ),
      ],
    );
  }
}

class UriData extends StatefulWidget {
  const UriData({super.key});

  @override
  State<UriData> createState() => _UriDataState();
}

class _UriDataState extends State<UriData> {
  @override
  void initState() {
    super.initState();
    envdata = fetchData();
  }

  // Uri uri = Uri.parse("https://jsonplaceholder.typicode.com/users");
  Uri uri = Uri.parse("http://pi@192.168.1.9/");

  Future<List<EnvData>> fetchData() async {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      //Success
      var parsedList = jsonDecode(response.body);
      return List<EnvData>.from(parsedList.map((i) => EnvData.fromJson(i)));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EnvData>>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Material(
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      tileColor: Colors.cyanAccent,
                      title: Text(snapshot.data![index].id.toString()),
                      subtitle: Text(snapshot.data![index].temp.toString()),
                    ),
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        },
        future: fetchData(),
      );
  }
}

class EnvData {
  final int id;
  final String date;
  final String time;
  final double temp;
  final double hum;
  final int light;

  EnvData({
    required this.id, 
    required this.date, 
    required this.time, 
    required this.temp, 
    required this.hum, 
    required this.light});

  factory EnvData.fromJson(Map<String, dynamic> json) {
    return EnvData(
      id: json['id'], 
      date: json['date'], 
      time: json['time'], 
      temp: json['temperature'], 
      hum: json['humidity'], 
      light: json['light']);
  }
}

void wakeLan() async {
  // Create the IPv4  broadcast address
  String ip = '192.168.1.255';
  String mac = '88:D7:F6:3E:A5:4D';

  // Validate that the two strings are formatted correctly
  if (!IPv4Address.validate(ip)) return;
  if (!MACAddress.validate(mac)) return;

  // Create the IPv4 and MAC objects
  IPv4Address ipv4Address = IPv4Address(ip);
  MACAddress macAddress = MACAddress(mac);

  // Send the WOL packet
  WakeOnLAN(ipv4Address, macAddress).wake();
}
