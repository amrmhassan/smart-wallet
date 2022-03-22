String doubleToString(double amount) {
  try {
    String string = amount.toStringAsFixed(2);
    return string.replaceFirst('.00', '');
  } catch (error) {
    return 'error converting double to string';
  }
}
