// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/utils/general_utils.dart';

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
  int timesDeleteClicked = 0;

  Future<String> logsFilePath() async {
    String path = (await getApplicationDocumentsDirectory()).path;
    String fullPath = '$path/$loggingFileName';
    return fullPath;
  }

  Future<void> loadLogs() async {
    setState(() {
      _loading = true;
    });
    //? here read the log file then
    String fullPath = await logsFilePath();
    try {
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
  }

  @override
  void initState() {
    loadLogs();
    super.initState();
  }

  Future<void> deleteLogs() async {
    //? the user needs to click the delete button 3 times before actually deleting the logs file
    if (timesDeleteClicked < 2) {
      timesDeleteClicked++;
      showSnackBar(
          context,
          'Remaining ${3 - timesDeleteClicked} Clicks to delete!',
          SnackBarType.info);
      return;
    }
    String fullPath = await logsFilePath();
    File logsFile = File(fullPath);
    if (logsFile.existsSync()) {
      setState(() {
        _loading = true;
      });
      await logsFile.delete();
      setState(() {
        _loading = false;
        logs = '';
      });
    }
    timesDeleteClicked = 0;
    showSnackBar(context, 'Logs deleted successfully', SnackBarType.info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Logs'),
        actions: [
          IconButton(
            onPressed: deleteLogs,
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () {
              showSnackBar(context, 'Exporting the logs (coming soon)',
                  SnackBarType.info);
            },
            icon: Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _loading
          ? Text('Loading')
          : error.isNotEmpty
              ? Text(error)
              : logs.isEmpty
                  ? Center(
                      child: Text('Logs are empty '),
                    )
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
