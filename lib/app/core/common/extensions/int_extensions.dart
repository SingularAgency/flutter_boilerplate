/// Extension methods for int class
extension IntExtensions on int {
  /// Returns a Duration in milliseconds
  Duration get milliseconds => Duration(milliseconds: this);

  /// Returns a Duration in seconds
  Duration get seconds => Duration(seconds: this);

  /// Returns a Duration in minutes
  Duration get minutes => Duration(minutes: this);

  /// Returns a Duration in hours
  Duration get hours => Duration(hours: this);

  /// Returns a Duration in days
  Duration get days => Duration(days: this);

  /// Returns true if the number is even
  bool get isEven => this % 2 == 0;

  /// Returns true if the number is odd
  bool get isOdd => this % 2 != 0;

  /// Returns true if the number is positive
  bool get isPositive => this > 0;

  /// Returns true if the number is negative
  bool get isNegative => this < 0;

  /// Returns true if the number is zero
  bool get isZero => this == 0;

  /// Returns the number as a double
  double get toDoubleValue => toDouble();

  /// Returns the number as a string with the specified number of digits
  String toFixed(int digits) => toStringAsFixed(digits);

  /// Returns the number as a string with commas as thousand separators
  String get withCommas => toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
} 