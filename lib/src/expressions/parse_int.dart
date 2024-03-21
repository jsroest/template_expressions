/// Parses the dynamic [value] into a int.  The value may be a [String], [int],
/// [double].  If the [value] cannot be successfully parsed into an [int] then
/// [the [defaultValue] will be returned.
int? maybeParseInt(dynamic value) => maybeParseDouble(value)?.toInt();

/// Parses the dynamic [value] into a double.  The [value] may be a [String],
/// [int], or [double].  If the [value] cannot be successfully parsed into a
/// [double] then the [defaultValue] will be returned.
///
/// A value of the string "infinity" will result in [double.infinity].
double? maybeParseDouble(
  dynamic value, [
  double? defaultValue,
]) {
  double? result;

  if (value is String) {
    if (value.toLowerCase() == 'infinity') {
      result = double.infinity;
    } else if (value.startsWith('0x') == true) {
      result = int.tryParse(value.substring(2), radix: 16)?.toDouble();
    } else {
      result = double.tryParse(value);
    }
  } else if (value is double) {
    result = value;
  } else if (value is int) {
    result = value.toDouble();
  }

  return result ?? defaultValue;
}
