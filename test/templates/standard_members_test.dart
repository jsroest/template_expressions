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

    test('subtract', () {
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
