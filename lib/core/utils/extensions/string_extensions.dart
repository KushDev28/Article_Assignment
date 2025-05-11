import 'package:flutter/foundation.dart';

extension StringExtension on String? {
  /// Returns `true` if the string is `null` or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns `true` if the string is not `null` and not empty.
  bool get isNotNullNorEmpty => !isNullOrEmpty;

  /// Converts the string to a `double`, or returns `0` if invalid or null.
  double get toDouble {
    if (isNullOrEmpty) return 0;
    try {
      return double.tryParse(this!) ?? 0;
    } catch (e) {
      debugPrint("Failed to convert to double: $this");
      return 0;
    }
  }

  /// Converts the string to a `num`, or returns `0` if invalid or null.
  num get toNum {
    if (isNullOrEmpty) return 0;
    try {
      return num.tryParse(this!) ?? 0;
    } catch (e) {
      debugPrint("Failed to convert to num: $this");
      return 0;
    }
  }
}
