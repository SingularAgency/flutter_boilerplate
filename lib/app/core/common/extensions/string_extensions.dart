/// Extension methods for String class
extension StringExtensions on String {
  /// Checks if the string is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Checks if the string is not null and not empty
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Capitalizes the first letter of the string
  String get capitalize => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  /// Trims the string and removes extra spaces
  String get trimAll => trim().replaceAll(RegExp(r'\s+'), ' ');

  /// Checks if the string is a valid email
  bool get isEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  /// Checks if the string is a valid phone number
  bool get isPhoneNumber => RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(this);

  /// Checks if the string is a valid URL
  bool get isUrl => RegExp(r'^https?:\/\/[\w\-\.]+(:\d+)?(\/[\w\-\.\/]*)?$').hasMatch(this);

  /// Returns the string with the first letter of each word capitalized
  String get toTitleCase => split(' ').map((word) => word.capitalize).join(' ');

  /// Returns a truncated string with ellipsis if it exceeds the given length
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
} 