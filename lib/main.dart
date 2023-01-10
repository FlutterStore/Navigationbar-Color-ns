// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  Color _randomNavigationColor = Colors.black;

  bool? _useWhiteStatusBarForeground;
  bool? _useWhiteNavigationBarForeground;

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_useWhiteStatusBarForeground != null) {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(
            _useWhiteStatusBarForeground!);
      }
      if (_useWhiteNavigationBarForeground != null) {
        FlutterStatusbarcolor.setNavigationBarWhiteForeground(
            _useWhiteNavigationBarForeground!);
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  changeNavigationColor(Color color) async {
    try {
      await FlutterStatusbarcolor.setNavigationBarColor(color, animate: true);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Navigationbar Color(android only)' ,style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal),),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => changeNavigationColor(Colors.transparent),
            child: const Text('Transparent'),
          ),
          const Padding(padding: EdgeInsets.all(10.0)),
          ElevatedButton(
            onPressed: () => changeNavigationColor(Colors.deepPurple[800]!),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color?>(Colors.deepPurple[800]),
            ),
            child: const Text('deepPurple'),
          ),
          const Padding(padding: EdgeInsets.all(10.0)),
          ElevatedButton(
            onPressed: () {
              Random rnd = Random();
              Color color = Color.fromARGB(
                255,
                rnd.nextInt(255),
                rnd.nextInt(255),
                rnd.nextInt(255),
              );
              setState(() => _randomNavigationColor = color);
              changeNavigationColor(color);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  _randomNavigationColor),
            ),
            child: Text(
              'Random color',
              style: TextStyle(
                color: useWhiteForeground(_randomNavigationColor)
                    ? Colors.white
                    : Colors.black,
                ),
              ),
            ),
          ],
        ),
    );
  }
}