import 'package:smart_wallet/constants/errors_types.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/models/logger_model.dart';

//! you can learn about loggin from youtube https://www.youtube.com/watch?v=GUi0n9c33os
class CustomError implements Exception {
  Object error;
  StackTrace? stackTrace;

  CustomError(this.error, this.stackTrace) {
    var log = logger(stackTrace);
    log.e(error);
  }

  static void log({
    Object? error,
    ErrorTypes? errorType,
    StackTrace? stackTrace,
    bool rethrowError = false,
    LogTypes? logType,
  }) {
    if (error == null && errorType == null) {
      throw CustomError(
          'You must provide error or errorType or both', stackTrace);
    }
    //? if the error type presets then i will use the beatified error , else Use the actual error or the 'Unknown error' word
    var log = logger(stackTrace, logType);
    String beautifiedError = error.toString();
    if (errorType != null) {
      beautifiedError = CustomError.beautifyError(errorType).toString();
    }
    log.e(error.toString());

    if (rethrowError) {
      throw CustomError(beautifiedError, stackTrace);
    }
  }

  @override
  String toString() {
    return error.toString();
  }

  static String beautifyError(ErrorTypes error) {
    String msg = 'Unknown Error';
    return errorsTypes[error] ?? msg;
  }
}
