import 'dart:convert';

import 'package:template_expressions/template_expressions.dart';
import 'package:test/test.dart';

void main() {
  group('DateTime', () {
    final start = DateTime(2022, 2, 7);
    test('add', () {
      final context = {
        'start': start,
      };
      final template = Template(
        syntax: [const MustacheExpressionSyntax()],
        value: '{{start.add(minutes(5).add(seconds(30)))}}',
      );

      expect(
        template.process(context: context),
        DateTime.fromMillisecondsSinceEpoch(
          start.millisecondsSinceEpoch +
              const Duration(
                minutes: 5,
                seconds: 30,
              ).inMilliseconds,
        ).toString(),
      );
    });

    test('compareTo', () {
      final context = {
        'start': start,
      };
      final template = Template(
        syntax: [const MustacheExpressionSyntax()],
        value: '{{start.compareTo(DateTime(2022, 2, 6))}}',
      );

      expect(
        template.process(context: context),
        1,
      );
    });

    test('isAfter', () {
      final context = {
        'start': start,
      };
      final template = Template(
        syntax: [const MustacheExpressionSyntax()],
        value: '{{start.isAfter(DateTime(2021))}}',
      );

      expect(
        template.process(context: context),
        'true',
      );
    });

    test('isBefore', () {
      final context = {
        'start': start,
      };
      final template = Template(
        syntax: [const MustacheExpressionSyntax()],
        value: '{{start.isBefore(DateTime(2021))}}',
      );

      expect(
        template.process(context: context),
        'false',
      );
    });

    test('subtract duration', () {
      final context = {
        'start': start,
      };
      final template = Template(
        syntax: [const MustacheExpressionSyntax()],
        value: '{{start.subtract(minutes(5).subtract(seconds(30)))}}',
      );

      expect(
        template.process(context: context),
        DateTime.fromMillisecondsSinceEpoch(
          start.millisecondsSinceEpoch -
              const Duration(
                minutes: 4,
                seconds: 30,
              ).inMilliseconds,
        ).toString(),
      );
    });

    test('subtract milliseconds', () {
      final context = {
        'start': start,
      };
      final template = Template(
        syntax: [const MustacheExpressionSyntax()],
        value: '{{start.subtract(30000)}}',
      );

      expect(
        template.process(context: context),
        DateTime.fromMillisecondsSinceEpoch(
          start.millisecondsSinceEpoch -
              const Duration(milliseconds: 30000).inMilliseconds,
        ).toString(),
      );
    });

    test(
      'toIso8601String',
      () {
        final context = {
          'start': start,
        };
        final template = Template(
          syntax: [const MustacheExpressionSyntax()],
          value: '{{start.toIso8601String()}}',
        );

        expect(template.process(context: context), '2022-02-07T00:00:00.000');
      },
    );

    test(
      'toLocal',
      () {
        final context = {
          'start': start,
        };
        final template = Template(
          syntax: [const MustacheExpressionSyntax()],
          value: '{{start.toLocal()}}',
        );

        expect(template.process(context: context), '2022-02-07 00:00:00.000');
      },
    );

    test(
      'toUtc',
      () {
        final context = {
          'start': start,
        };
        final template = Template(
          syntax: [const MustacheExpressionSyntax()],
          value: '{{start.toUtc()}}',
        );

        expect(template.process(context: context), '2022-02-06 23:00:00.000Z');
      },
    );
  });

  group('List', () {
    test('toJson', () {
      final context = {
        'input': [
          'John',
          'Smith',
        ]
      };

      expect(
        Template(value: r'${input.toJson(2)}').process(context: context),
        const JsonEncoder.withIndent('  ').convert(context['input']),
      );

      expect(
        Template(value: r'${input.toJson()}').process(context: context),
        json.encode(context['input']),
      );
    });
  });

  group('Logger', () {});

  group('Map', () {
    test('entries', () {
      final context = {
        'input': {
          'name': {
            'first': 'John',
            'last': 'Smith',
          },
        },
      };
      expect(
        Template(value: r'${input.entries}').evaluate(context: context)
            is Iterable,
        true,
      );
    });

    test('toJson', () {
      final context = {
        'input': {
          'name': {
            'first': 'John',
            'last': 'Smith',
          },
        },
      };

      expect(
        Template(value: r'${input.toJson(2)}').process(context: context),
        const JsonEncoder.withIndent('  ').convert(context['input']),
      );

      expect(
        Template(value: r'${input.toJson()}').process(context: context),
        json.encode(context['input']),
      );
    });
  });

  group('MapEntry', () {
    test('key / value', () {
      final context = {
        'input': const MapEntry('KEY', 'VALUE'),
      };

      expect(
        Template(value: r'${input.key}').process(context: context),
        'KEY',
      );

      expect(
        Template(value: r'${input.value}').process(context: context),
        'VALUE',
      );
    });
  });

  group('String', () {
    test('replaceAll', () {
      final template = Template(value: r'${input.replaceAll("\n", "\\n")}');

      expect(
        template.process(
          context: {
            'input': 'a\nb\nc\n',
          },
        ),
        'a\\nb\\nc\\n',
      );
    });

    test('toLowerCase', () {
      final template = Template(
        value: r'${input.toLowerCase()}',
      );

      expect(
        template.process(context: {
          'input': 'Hello World!',
        }),
        'hello world!',
      );
    });

    test('toUpperCase', () {
      final template = Template(
        value: r'${input.toUpperCase()}',
      );

      expect(
        template.process(context: {
          'input': 'Hello World!',
        }),
        'HELLO WORLD!',
      );
    });

    test('trim', () {
      final template = Template(
        value: r'${input.trim()}',
      );

      expect(
        template.process(context: {
          'input': '  Hello World!  ',
        }),
        'Hello World!',
      );
    });
  });
}
