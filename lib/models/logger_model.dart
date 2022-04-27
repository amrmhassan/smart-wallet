// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/helpers/custom_error.dart';

var logger = (StackTrace? sTrace) => Logger(
      output: FileOutPut(),
      printer: CustomPrinter(stackTrace: sTrace),
    );

class CustomPrinter extends LogPrinter {
  final StackTrace? stackTrace;

  CustomPrinter({
    this.stackTrace,
  });
  @override
  List<String> log(LogEvent event) {
    // final color = PrettyPrinter.levelColors[event.level];
    // final emoji = PrettyPrinter.levelEmojis[event.level];
    final levelString = event.level.name.toUpperCase();
    final message = event.message;

    String separator = '\n------------------\n';
    return ['[$levelString] - \n - $message \n $stackTrace \n $separator'];
  }
}

class FileOutPut extends LogOutput {
  @override
  void output(OutputEvent event) async {
    try {
      String path = (await getApplicationDocumentsDirectory()).path;
      String fullPath = '$path/$loggingFileName';

      File logFile = File(fullPath);
      if (!logFile.existsSync()) {
        await logFile.create();
      }

      for (var line in event.lines) {
        await logFile.writeAsString(line,
            mode: FileMode.append,
            encoding: Encoding.getByName('utf-8') as Encoding);
      }
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }
  }
}
