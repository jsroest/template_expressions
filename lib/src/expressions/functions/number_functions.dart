import 'package:intl/intl.dart';

/// Class containing functions related to number processing.
class NumberFunctions {
  /// The functions related to number processing.
  static final functions = {
    'NumberFormat': ([newPattern, locale]) => NumberFormat(newPattern, locale),
  };
}
