class CustomError implements Exception {
  String message;
  CustomError(
    this.message,
  );

  @override
  String toString() {
    return message;
  }
}
