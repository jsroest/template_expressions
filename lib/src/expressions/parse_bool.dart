import 'package:template_expressions/src/expressions/parse_int.dart';

/// Parses the dynamic [value] into a [bool].  This will return [true] if and
/// only if the value is...
/// * [true]
/// * `"true"` (case insensitive)
/// * `"yes"` (case insensitive)
/// * `1`
///
/// When [value] is null, this will return [whenNull].
bool parseBool(dynamic value, {bool whenNull = false}) {
  final result = maybeParseBool(value) ?? whenNull;

  return result;
}

/// Parses the dynamic [value] into a [bool].  This will return [true] if and
/// only if the value is...
/// * [true]
/// * `"true"` (case insensitive)
/// * `"yes"` (case insensitive)
/// * `1`
///
/// When [value] is null, this will return null.
bool? maybeParseBool(dynamic value) {
  bool? result;

  if (value != null) {
    if (value is bool) {
      result = value;
    } else if (value is String) {
      final lower = value.toLowerCase();
      result = lower == 'true' || lower == 'yes';
    } else {
      result = maybeParseInt(value) == 1;
    }
  }

  return result;
}
