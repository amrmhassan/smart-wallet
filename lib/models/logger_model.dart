import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/helpers/custom_error.dart';

var logger = Logger(
  output: FileOutPut(),
  printer: CustomPrinter(),
);

class CustomPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    // final color = PrettyPrinter.levelColors[event.level];
    // final emoji = PrettyPrinter.levelEmojis[event.level];
    final levelString = event.level.name.toUpperCase();
    final message = event.message;
    final stack = event.stackTrace;

    String separator = '\n----------\n';
    return ['[$levelString] - $message == $stack $separator'];
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
    } catch (error) {
      CustomError.log(error);
    }
  }
}
