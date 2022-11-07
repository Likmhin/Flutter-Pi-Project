// ignore_for_file: unused_import, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wake_on_lan/wake_on_lan.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Pi App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Pi Project App'),
          ),
          body: TabBarView(
            children: <Widget>[HomeBody()],
          ),
          bottomNavigationBar: TabBar(tabs: const <Widget>[
            Tab(text: 'Home', icon: Icon(Icons.home),),
            Tab(text: 'Profile', icon: Icon(Icons.person_outline),),
          ],),
        ));
  }
}

class HomeBody extends StatelessWidget {
  TextStyle titleTextStyle =
      TextStyle(fontSize: 36, color: Colors.green, fontFamily: 'Times');
  TextStyle standardTextStyle =
      TextStyle(fontSize: 18, color: Colors.deepOrange, fontFamily: 'Times');
  List<String> info = [
    'Name Here',
    'Address Here',
    'Town Here',
  ];
  Image myImage = Image.asset('images/noob.jpg',
      height: 200, width: 200, fit: BoxFit.fitWidth);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    list.add(Text(
      info[0],
      style: titleTextStyle,
    ));
    list.add(myImage);
    for (int i = 1; i < info.length; i++) {
      list.add(Text(
        info[i],
        style: standardTextStyle,
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: list,
        )
      ],
    );
  }
}