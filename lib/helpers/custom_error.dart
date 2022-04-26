import 'package:smart_wallet/constants/errors_types.dart';

//! you can learn about loggin from youtube https://www.youtube.com/watch?v=GUi0n9c33os
class CustomError implements Exception {
  Object error;
  CustomError(
    this.error,
  );

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
