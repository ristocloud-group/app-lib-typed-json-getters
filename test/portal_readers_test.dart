import 'package:typed_json_getters/typed_json_getters.dart';
import 'package:test/test.dart';

void main() {
  group('hasValue', () {
    test('true only when the key is found and its value is not null', () {
      final json = <String, dynamic>{
        'zero': 0,
        'false': false,
        'empty': '',
        'null': null,
        'nested': {'balance': 12},
      };
      expect(json.hasValue('zero'), isTrue);
      expect(json.hasValue('false'), isTrue);
      expect(json.hasValue('empty'), isTrue);
      expect(json.hasValue('null'), isFalse);
      expect(json.hasValue('missing'), isFalse);
      expect(json.hasValue('nested.balance'), isTrue);
      expect(json.hasValue('nested.missing'), isFalse);
    });
  });

  group('getStrictString', () {
    test('only a String counts, with no conversion', () {
      final json = <String, dynamic>{
        'name': 'Pranzo',
        'number': 42,
        'object': {'URL-SVG': 'a.svg'},
        'nested': {'host': '10.0.0.1'},
      };
      expect(json.getStrictString('name'), 'Pranzo');
      expect(json.getStrictString('number'), isNull);
      expect(json.getStrictString('object'), isNull);
      expect(json.getStrictString('missing'), isNull);
      expect(json.getStrictString('nested.host'), '10.0.0.1');
    });
  });

  group('getDecimal', () {
    test('reads a number or a numeric string with a comma decimal', () {
      final json = <String, dynamic>{
        'int': 3,
        'double': 155.1,
        'comma': '12,5',
        'text': 'q.b.',
        'bool': true,
        'cfp': {
          'values': {'final': '0,42'},
        },
      };
      expect(json.getDecimal('int'), 3.0);
      expect(json.getDecimal('double'), 155.1);
      expect(json.getDecimal('comma'), 12.5);
      expect(json.getDecimal('text'), isNull);
      expect(json.getDecimal('bool'), isNull);
      expect(json.getDecimal('missing'), isNull);
      expect(json.getDecimal('cfp.values.final'), 0.42);
    });
  });

  group('getDecimalList', () {
    test('keeps the numbers and the numeric strings, skips the rest', () {
      final json = <String, dynamic>{
        'ids': [3, '7', '1,5', 'x', null, true],
        'notAList': 3,
      };
      expect(json.getDecimalList('ids'), [3.0, 7.0, 1.5]);
      expect(json.getDecimalList('notAList'), isEmpty);
      expect(json.getDecimalList('missing'), isEmpty);
    });
  });

  group('getWholeNumber', () {
    test('accepts only the unambiguous encodings of a whole number', () {
      final json = <String, dynamic>{
        'int': 42,
        'double': 42.0,
        'string': ' 42 ',
        'negative': '-5',
        'fraction': 42.5,
        'fractionString': '42.5',
        'infinity': double.infinity,
        'nan': double.nan,
        'empty': '',
        'bool': true,
      };
      expect(json.getWholeNumber('int'), 42);
      expect(json.getWholeNumber('double'), 42);
      expect(json.getWholeNumber('string'), 42);
      expect(json.getWholeNumber('negative'), -5);
      expect(json.getWholeNumber('fraction'), isNull);
      expect(json.getWholeNumber('fractionString'), isNull);
      expect(json.getWholeNumber('infinity'), isNull);
      expect(json.getWholeNumber('nan'), isNull);
      expect(json.getWholeNumber('empty'), isNull);
      expect(json.getWholeNumber('bool'), isNull);
      expect(json.getWholeNumber('missing'), isNull);
    });
  });

  group('getWholeNumberList', () {
    test('keeps the whole numbers in order, drops the rest', () {
      final json = <String, dynamic>{
        'amounts': [500, '1000', 'x', null, 2000.0, 1250.5, '12.5'],
        'notAList': '500',
      };
      expect(json.getWholeNumberList('amounts'), [500, 1000, 2000]);
      expect(json.getWholeNumberList('notAList'), isEmpty);
      expect(json.getWholeNumberList('missing'), isEmpty);
    });
  });

  group('getFlag', () {
    test('reads true/false, 1/0, "1"/"0" and "true"/"false"', () {
      final json = <String, dynamic>{
        'bool': true,
        'one': 1,
        'zero': 0,
        'oneString': '1',
        'zeroString': ' 0 ',
        'trueString': 'TRUE',
        'falseString': 'false',
      };
      expect(json.getFlag('bool'), isTrue);
      expect(json.getFlag('one'), isTrue);
      expect(json.getFlag('zero'), isFalse);
      expect(json.getFlag('oneString'), isTrue);
      expect(json.getFlag('zeroString'), isFalse);
      expect(json.getFlag('trueString'), isTrue);
      expect(json.getFlag('falseString'), isFalse);
    });

    test('is null for anything else, never a default', () {
      final json = <String, dynamic>{
        'two': 2,
        'fraction': 1.5,
        'si': 'si',
        'yes': 'yes',
        'null': null,
      };
      expect(json.getFlag('two'), isNull);
      expect(json.getFlag('fraction'), isNull);
      expect(json.getFlag('si'), isNull);
      expect(json.getFlag('yes'), isNull);
      expect(json.getFlag('null'), isNull);
      expect(json.getFlag('missing'), isNull);
    });
  });

  group('getObjectList', () {
    final json = <String, dynamic>{
      'objects': [
        {'ID': 1},
        {'ID': 2},
      ],
      'mixed': [
        {'ID': 1},
        3,
        null,
        {'ID': 2},
      ],
      'notAList': {'ID': 7},
      'null': null,
    };

    test('absent or null is an empty list', () {
      expect(json.getObjectList('missing'), isEmpty);
      expect(json.getObjectList('null'), isEmpty);
    });

    test('reads the objects in order', () {
      expect(json.getObjectList('objects'), [
        {'ID': 1},
        {'ID': 2},
      ]);
    });

    test(
        'strict: a value that is not a list or an entry that is not an '
        'object throws FormatException', () {
      expect(() => json.getObjectList('notAList'), throwsFormatException);
      expect(() => json.getObjectList('mixed'), throwsFormatException);
    });

    test(
        'skipNonObjects: the entries that are not objects are skipped, a '
        'value that is not a list still throws', () {
      expect(json.getObjectList('mixed', skipNonObjects: true), [
        {'ID': 1},
        {'ID': 2},
      ]);
      expect(
        () => json.getObjectList('notAList', skipNonObjects: true),
        throwsFormatException,
      );
    });

    test(
        'lenient: a value that is not a list is empty, the entries that '
        'are not objects are skipped', () {
      expect(json.getObjectList('notAList', lenient: true), isEmpty);
      expect(json.getObjectList('mixed', lenient: true), [
        {'ID': 1},
        {'ID': 2},
      ]);
    });
  });
}
