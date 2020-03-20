int intParser(String value) {
  return int.tryParse(value);
}

double doubleParser(String value) {
  return double.tryParse(value);
}

bool validate0to100(num value) {
  return validateNumber(100, 0, value);
}

bool validate1000range(num value) {
  return validateNumber(1000, -1000, value);
}

bool validate100range(num value) {
  return validateNumber(100, -100, value);
}

bool validateNumber(num upper, num bottom, num value) {
  return bottom <= value && value <= upper;
}
