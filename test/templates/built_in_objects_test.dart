import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:template_expressions/template_expressions.dart';
import 'package:test/test.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      // ignore: avoid_print
      print('${record.error}');
    }
    if (record.stackTrace != null) {
      // ignore: avoid_print
      print('${record.stackTrace}');
    }
  });

  //Initialize the locale date to prevent this exception:
  //LocaleDataException: Locale data has not been initialized, call initializeDateFormatting(<locale>).
  setUp(initializeDateFormatting);

  group('DateTime', () {
    final context = <String, dynamic>{};
    context['year'] = 2022;

    test('Map', () {
      var template = Template(
        value: r'${DateTime({"year": year, "month": 2, "day": 07\})}',
      );
      expect(
        template.process(context: context),
        DateTime(2022, 2, 7).toString(),
      );

      template = Template(
        syntax: [const MustacheExpressionSyntax()],
        value:
            '{{DateTime({"year": year, "month": 2, "day": 07, "hour": 12, "minute": 30, "second": 10, "milliseconds": 20})}}',
      );
      expect(
        template.process(context: context),
        DateTime(2022, 2, 7, 12, 30, 10, 20).toString(),
      );
    });

    test('List', () {
      final template = Template(
        syntax: [const MustacheExpressionSyntax()],
        value: '{{DateTime([year, 2, 07, 12, 30, 10, 20])}}',
      );
      expect(
        template.process(context: context),
        DateTime(2022, 2, 7, 12, 30, 10, 20).toString(),
      );
    });

    test('params', () {
      var template = Template(
        syntax: [const MustacheExpressionSyntax()],
        value: '{{DateTime(year, 02)}}',
      );
      expect(
        template.process(context: context),
        DateTime(2022, 02).toString(),
      );

      template = Template(
        syntax: [const MustacheExpressionSyntax()],
        value: '{{DateTime(year, 2, 07, 12, 30, 10, 20)}}',
      );
      expect(
        template.process(context: context),
        DateTime(2022, 2, 7, 12, 30, 10, 20).toString(),
      );
    });

    test('epoch millis', () {
      final template = Template(
        value: r'${DateTime(1645412678503)}',
      );
      expect(
        template.process(context: context),
        DateTime.fromMillisecondsSinceEpoch(1645412678503).toString(),
      );
    });

    test('formatting', () {
      var template = Template(
        value: r'${DateFormat("yyyy-MM-dd").parse("2022-02-07").add(days(1))}',
      );
      expect(
        template.process(context: context),
        DateTime(2022, 2, 8).toString(),
      );

      template = Template(
        value:
            r'${DateFormat("yyyy-MM-dd").format(DateTime([2022, 02, 07]).toLocal())}',
      );
      expect(
        template.process(context: context),
        '2022-02-07',
      );

      //DateFormat called with no parameters
      //Zone's Locale set to en_US
      Intl.withLocale('en_US', () {
        template = Template(
          value:
              r'${DateFormat().format(DateTime([2024, 03, 15, 14, 18, 58, 99, 98]))}',
        );
        expect(
          template.process(context: context),
          'March 15, 2024 2:18:58 PM',
        );
      });

      //DateFormat called with no parameters
      //Zone's locale set to nl_NL
      Intl.withLocale('nl_NL', () {
        template = Template(
          value:
              r'${DateFormat().format(DateTime([2024, 03, 15, 14, 18, 58, 99, 98]))}',
        );
        expect(
          template.process(context: context),
          '15 maart 2024 14:18:58',
        );
      });

      //DateFormat called with a pattern and no locale parameter
      //Zone's locale set to en_US
      Intl.withLocale('en_US', () {
        template = Template(
          value:
              r'${DateFormat("yyyy-MM-dd hh:mm:ss:ms a").format(DateTime([2024, 03, 15, 14, 18, 58, 99, 98]))}',
        );
        expect(
          template.process(context: context),
          '2024-03-15 02:18:58:1858 PM',
        );
      });

      //DateFormat called with a pattern and no locale parameter
      //Zone's locale set to nl_NL
      Intl.withLocale('nl_NL', () {
        template = Template(
          value:
              r'${DateFormat("yyyy-MM-dd hh:mm:ss:ms a").format(DateTime([2024, 03, 15, 14, 18, 58, 99, 98]))}',
        );
        expect(
          template.process(context: context),
          '2024-03-15 02:18:58:1858 p.m.',
        );
      });
    });

    test('now', () {
      final now = DateTime.now();
      final customContext = <String, dynamic>{};
      customContext['now'] = () => now;
      var template = Template(
        value: r'${now().subtract(Duration({"days": 1\})).toUtc()}',
      );
      expect(
        template.process(context: customContext),
        now.subtract(const Duration(days: 1)).toUtc().toString(),
      );

      template = Template(
        value: r'${now().subtract(days(1)).toUtc()}',
      );
      expect(
        template.process(context: customContext),
        now.subtract(const Duration(days: 1)).toUtc().toString(),
      );
    });
  });

  group('Duration', () {
    test('Map', () {
      final context = <String, dynamic>{};

      final template = Template(
        value:
            r'${Duration({"days": 1, "hours": 2, "minutes": 3, "seconds": 4, "milliseconds": 5\})}',
      );
      expect(
        template.process(context: context),
        const Duration(
          days: 1,
          hours: 2,
          minutes: 3,
          seconds: 4,
          milliseconds: 5,
        ).toString(),
      );
    });

    test('List', () {
      final context = <String, dynamic>{};

      final template = Template(
        value: r'${Duration([1, 2, 3, 4, 5])}',
      );
      expect(
        template.process(context: context),
        const Duration(
          days: 1,
          hours: 2,
          minutes: 3,
          seconds: 4,
          milliseconds: 5,
        ).toString(),
      );
    });

    test('Params', () {
      final context = <String, dynamic>{};

      final template = Template(
        value: r'${Duration(1, 2, 3, 4, 5)}',
      );
      expect(
        template.process(context: context),
        const Duration(
          days: 1,
          hours: 2,
          minutes: 3,
          seconds: 4,
          milliseconds: 5,
        ).toString(),
      );
    });

    test('millis', () {
      final context = <String, dynamic>{};

      final template = Template(
        value: r'${Duration(1001)}',
      );
      expect(
        template.process(context: context),
        const Duration(
          seconds: 1,
          milliseconds: 1,
        ).toString(),
      );
    });
  });

  group('List<int>', () {
    const input = 'Hello, World!';

    test('toBase64', () {
      expect(
        Template(value: r'${input.toBase64()}').process(
          context: {'input': utf8.encode(input)},
        ),
        base64.encode(utf8.encode(input)),
      );
    });

    test('toHex', () {
      expect(
        Template(value: r'${input.toHex()}').process(
          context: {'input': utf8.encode(input)},
        ),
        hex.encode(utf8.encode(input)),
      );
    });

    test('toString', () {
      expect(
        Template(value: r'${input.toString()}').process(
          context: {'input': utf8.encode(input)},
        ),
        input,
      );
    });
  });

  group('NumberFormat', () {
    final context = <String, dynamic>{};
    context['number'] = 0.999;

    test('formatting', () {
      //Dutch uses a comma as the decimal separator
      var template = Template(
        value: r'${NumberFormat("0.00","nl_NL").format(number)}',
      );

      expect(
        template.process(context: context),
        '1,00',
      );

      //US english uses a period as the decimal separator
      template = Template(
        value: r'${NumberFormat("0.00","en_US").format(number)}',
      );

      expect(
        template.process(context: context),
        '1.00',
      );

      //When no locale specified the zone's locale will be used
      //Zone's locale set to nl_NL
      Intl.withLocale('nl_NL', () {
        template = Template(
          value: r'${NumberFormat("0.00").format(number)}',
        );

        expect(
          template.process(context: context),
          '1,00',
        );
      });

      //When no locale specified the zone's locale will be used
      //Zone's locale set to en_US
      Intl.withLocale('en_US', () {
        template = Template(
          value: r'${NumberFormat("0.00").format(number)}',
        );

        expect(
          template.process(context: context),
          '1.00',
        );
      });

      //When no locale specified the zone's locale will be used
      //Zone's locale set to nl_NL
      //Pattern parameter is not specified
      Intl.withLocale('nl_NL', () {
        template = Template(
          value: r'${NumberFormat().format(number)}',
        );

        expect(
          template.process(context: context),
          '0,999',
        );
      });

      //When no locale and no pattern is specified
      //Zone's locale set to en_US
      //Pattern parameter is not specified
      Intl.withLocale('en_US', () {
        template = Template(
          value: r'${NumberFormat().format(number)}',
        );

        expect(
          template.process(context: context),
          '0.999',
        );
      });
    });
  });

  group('random', () {
    test('int', () {
      final template = Template(
        value: r'${random(100)}',
      );

      final processed = int.parse(template.process());

      expect(processed >= 0 && processed < 100, true);
    });

    test('double', () {
      final template = Template(
        value: r'${random()}',
      );

      final processed = double.parse(template.process());

      expect(processed >= 0.0 && processed < 1.0, true);
    });
  });
}
