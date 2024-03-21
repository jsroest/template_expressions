import 'package:template_expressions/template_expressions.dart';
import 'package:test/test.dart';

void main() {
  group('evaluate', () {
    test('multiple expressions', () {
      final template = Template(value: r'${seconds(2)}${milliseconds(500)}');
      try {
        template.evaluate();
        fail('expected expression');
      } catch (_) {
        // pass
      }
    });

    test('no expression', () {
      final template = Template(value: '2');
      final result = template.evaluate();

      expect(result, '2');
    });

    test('sync', () {
      final template = Template(value: r'${seconds(2)}');
      final result = template.evaluate();

      expect(result, const Duration(seconds: 2));
    });
  });
}
