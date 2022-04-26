// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_wallet/constants/globals.dart';

class LoggingScreen extends StatefulWidget {
  static const String routeName = 'logging-screen';
  const LoggingScreen({Key? key}) : super(key: key);

  @override
  State<LoggingScreen> createState() => _LoggingScreenState();
}

class _LoggingScreenState extends State<LoggingScreen> {
  bool _loading = false;
  String logs = '';
  String error = '';
  @override
  void initState() {
    setState(() {
      _loading = true;
    });
    Future.delayed(Duration.zero).then((value) async {
      //? here read the log file then
      try {
        String path = (await getApplicationDocumentsDirectory()).path;
        String fullPath = '$path/$loggingFileName';

        File logFile = File(fullPath);
        if (!logFile.existsSync()) {
          await logFile.create();
        }
        String content = await logFile.readAsString(
            encoding: Encoding.getByName('utf-8') as Encoding);

        setState(() {
          logs = content;
        });
      } catch (err) {
        setState(() {
          error = err.toString();
        });
      }

      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logs')),
      body: _loading
          ? Text('Loading')
          : error.isNotEmpty
              ? Text(error)
              : SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Text(logs),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
