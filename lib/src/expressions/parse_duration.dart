import 'package:template_expressions/src/expressions/parse_int.dart';

/// Parses a duration from milliseconds.  The [value] may be an [int],
/// [double], or number encoded [String].
Duration? maybeParseDurationFromMillis(dynamic value) {
  final millis =
      value is Duration ? value.inMilliseconds : maybeParseInt(value);

  return millis == null ? null : Duration(milliseconds: millis);
}
