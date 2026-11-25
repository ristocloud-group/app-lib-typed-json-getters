import 'package:typed_json_getters/typed_json_getters.dart';
import 'package:test/test.dart';

Matcher _formatError(String message) => throwsA(
      isA<FormatException>().having((e) => e.message, 'message', message),
    );

void main() {
  group('getRequiredWholeNumber', () {
    final json = <String, dynamic>{
      'id': 7,
      'whole': 42.0,
      'text': '12',
      'fraction': 42.5,
      'null': null,
      'MealType': {'ID': 3},
    };

    test('reads a whole number as getWholeNumber does', () {
      expect(json.getRequiredWholeNumber('id'), 7);
      expect(json.getRequiredWholeNumber('whole'), 42);
      expect(json.getRequiredWholeNumber('text'), 12);
      expect(json.getRequiredWholeNumber('MealType.ID'), 3);
    });

    test('throws when missing, null or not a whole number', () {
      expect(
        () => json.getRequiredWholeNumber('missing'),
        _formatError('missing is not a whole number'),
      );
      expect(
        () => json.getRequiredWholeNumber('null'),
        _formatError('null is not a whole number'),
      );
      expect(
        () => json.getRequiredWholeNumber('fraction'),
        _formatError('fraction is not a whole number'),
      );
      expect(
        () => json.getRequiredWholeNumber('MealType.Name'),
        _formatError('MealType.Name is not a whole number'),
      );
    });
  });

  group('getRequiredString', () {
    final json = <String, dynamic>{
      'name': 'Pranzo',
      'empty': '',
      'number': 42,
      'null': null,
      'Totem': {'Code': 'T1'},
    };

    test('reads a String as getStrictString does', () {
      expect(json.getRequiredString('name'), 'Pranzo');
      expect(json.getRequiredString('empty'), '');
      expect(json.getRequiredString('Totem.Code'), 'T1');
    });

    test('throws when missing, null or not a string', () {
      expect(
        () => json.getRequiredString('missing'),
        _formatError('missing is not a string'),
      );
      expect(
        () => json.getRequiredString('null'),
        _formatError('null is not a string'),
      );
      expect(
        () => json.getRequiredString('number'),
        _formatError('number is not a string'),
      );
      expect(
        () => json.getRequiredString('Totem.Name'),
        _formatError('Totem.Name is not a string'),
      );
    });
  });

  group('getRequiredFlag', () {
    final json = <String, dynamic>{
      'active': true,
      'one': 1,
      'zero': '0',
      'two': 2,
      'null': null,
      'Totem': {'Enabled': 'true'},
    };

    test('reads a flag as getFlag does', () {
      expect(json.getRequiredFlag('active'), isTrue);
      expect(json.getRequiredFlag('one'), isTrue);
      expect(json.getRequiredFlag('zero'), isFalse);
      expect(json.getRequiredFlag('Totem.Enabled'), isTrue);
    });

    test('throws when missing, null or not a flag', () {
      expect(
        () => json.getRequiredFlag('missing'),
        _formatError('missing is not a flag'),
      );
      expect(
        () => json.getRequiredFlag('null'),
        _formatError('null is not a flag'),
      );
      expect(
        () => json.getRequiredFlag('two'),
        _formatError('two is not a flag'),
      );
      expect(
        () => json.getRequiredFlag('Totem.Visible'),
        _formatError('Totem.Visible is not a flag'),
      );
    });
  });

  group('getRequiredObject', () {
    final json = <String, dynamic>{
      'MealType': {'ID': 3, 'Name': null},
      'numericKeys': {1: 'a', 2: 'b'},
      'list': [1, 2],
      'text': 'x',
      'null': null,
      'Reservation': {
        'MealType': {'ID': 4},
      },
    };

    test('reads an object, converting non-String keys', () {
      expect(json.getRequiredObject('MealType'), {'ID': 3, 'Name': null});
      expect(json.getRequiredObject('numericKeys'), {'1': 'a', '2': 'b'});
      expect(json.getRequiredObject('Reservation.MealType'), {'ID': 4});
    });

    test('throws when missing, null or not an object', () {
      expect(
        () => json.getRequiredObject('missing'),
        _formatError('missing is not an object'),
      );
      expect(
        () => json.getRequiredObject('null'),
        _formatError('null is not an object'),
      );
      expect(
        () => json.getRequiredObject('list'),
        _formatError('list is not an object'),
      );
      expect(
        () => json.getRequiredObject('text'),
        _formatError('text is not an object'),
      );
      expect(
        () => json.getRequiredObject('Reservation.Totem'),
        _formatError('Reservation.Totem is not an object'),
      );
    });
  });

  group('getDateTime', () {
    final json = <String, dynamic>{
      'day': '2026-11-24',
      'utc': '2026-11-24T12:30:00Z',
      'number': 20261124,
      'object': {'date': '2026-11-24'},
      'text': 'domani',
      'null': null,
      'Reservation': {'Date': '2026-11-25T08:00:00'},
    };

    test('parses a String with DateTime.tryParse', () {
      expect(json.getDateTime('day'), DateTime(2026, 11, 24));
      expect(json.getDateTime('utc'), DateTime.utc(2026, 11, 24, 12, 30));
      expect(
        json.getDateTime('Reservation.Date'),
        DateTime(2026, 11, 25, 8),
      );
    });

    test('keeps the time zone of the text', () {
      expect(json.getDateTime('utc')!.isUtc, isTrue);
      expect(json.getDateTime('day')!.isUtc, isFalse);
    });

    test('is null for a number, an object, a non-date text or null', () {
      expect(json.getDateTime('number'), isNull);
      expect(json.getDateTime('object'), isNull);
      expect(json.getDateTime('text'), isNull);
      expect(json.getDateTime('null'), isNull);
      expect(json.getDateTime('missing'), isNull);
      expect(json.getDateTime('Reservation.Missing'), isNull);
    });
  });

  group('getRequiredDateTime', () {
    final json = <String, dynamic>{
      'day': '2026-11-24',
      'number': 20261124,
      'text': 'domani',
      'null': null,
      'Reservation': {'Date': '2026-11-25'},
    };

    test('reads a date as getDateTime does', () {
      expect(json.getRequiredDateTime('day'), DateTime(2026, 11, 24));
      expect(
        json.getRequiredDateTime('Reservation.Date'),
        DateTime(2026, 11, 25),
      );
    });

    test('throws when missing, null or not a date', () {
      expect(
        () => json.getRequiredDateTime('missing'),
        _formatError('missing is not a date'),
      );
      expect(
        () => json.getRequiredDateTime('null'),
        _formatError('null is not a date'),
      );
      expect(
        () => json.getRequiredDateTime('number'),
        _formatError('number is not a date'),
      );
      expect(
        () => json.getRequiredDateTime('text'),
        _formatError('text is not a date'),
      );
      expect(
        () => json.getRequiredDateTime('Reservation.Time'),
        _formatError('Reservation.Time is not a date'),
      );
    });
  });
}
