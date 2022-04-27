import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:smart_wallet/constants/errors_types.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/models/logger_model.dart';
import 'package:smart_wallet/utils/general_utils.dart';

//! you can learn about loggin from youtube https://www.youtube.com/watch?v=GUi0n9c33os
class CustomError implements Exception {
  Object error;

  CustomError(
    this.error,
  ) {
    var log = logger;
    log.e(error);
  }

  static void log(
    Object error, [
    bool rethrowError = false,
  ]) {
    var log = logger;
    log.e(error.toString());
    if (rethrowError) {
      throw CustomError(error);
    }
  }

  @override
  String toString() {
    return error.toString();
  }

  static String beautifyError(Object error) {
    String stringError = error.toString();
    String beautifiedError = 'Unknown Error Occurred';
    errorsTypes.forEach((key, value) {
      if (stringError.contains(key)) {
        beautifiedError = value;
      }
    });
    return beautifiedError;
  }
}
