import 'constants.dart';

extension StringExtension on String {
  String capFirst() {
    if (isEmpty) return this;

    return this[0].toUpperCase() + substring(1);
  }

  String first7() {
    if (length < 7) return this;

    return substring(0, 7);
  }

  bool isMarkdown() {
    return endsWith('.md');
  }

  bool isPicture() {
    return endsWith('.jpg') || endsWith('.png');
  }

  bool isEmail() {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  String formatSdDateTime() {
    if (length != 14) return this;

    final yyyy = substring(0, 4);
    final mm = substring(4, 6);
    final dd = substring(6, 8);

    final hh = substring(8, 10);
    final nn = substring(10, 12);
    final ss = substring(12, 14);

    return '$yyyy-$mm-$dd $hh:$nn:$ss';
  }
}

extension DateTimeExtension on DateTime {
  /// Returns a string in the format of "yyyy MMM dd"
  /// e.g. "2023 Jan 01"
  String toYYYYMMMDD() {
    final yyyy = year.toString();
    final mmm = toMMM();
    final dd = toDD();

    return '$yyyy $mmm $dd';
  }

  /// Returns a string in the format of "MMM dd"
  /// e.g. "Jan 01"
  String toMMMDD() {
    return '${toMMM()} ${day.toString().padLeft(2, '0')}';
  }

  /// Returns a string in the format of "MMM"
  /// e.g. "Jan"
  String toMMM() {
    return Month.values[month - 1].short;
  }

  String toDD() {
    return day.toString().padLeft(2, '0');
  }
}
