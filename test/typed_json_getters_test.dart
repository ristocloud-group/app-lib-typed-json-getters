import 'package:test/test.dart';
import 'package:typed_json_getters/typed_json_getters.dart';

void main() {
  group('TypedJsonGettersExtension', () {
    late Map<String, dynamic> json;

    setUp(() {
      json = {
        'boolTrue': true,
        'boolFalse': false,
        'stringValue': 'Hello, World!',
        'doubleValue': 3.14,
        'intValue': 42,
        'nullValue': null,
        'invalidBool': 'not a bool',
        'invalidInt': 'invalid',
        'invalidDouble': 'invalid',
        'mapValue': {
          'key1': 'value1',
          'key2': 'value2',
        },
        'listValue': [1, 2, 3],
        'listString': ['one', 'two', 'three'],
        'listMixed': [1, 'two', 3.0],
        'invalidList': 'not a list',
        'invalidMap': 'not a map',
        'mapStringInt': {
          'one': '1',
          'two': '2',
        },
        'nestedMap': {
          'outerKey1': {
            'innerKey': 'innerValue1',
          },
          'outerKey2': {
            'innerKey': 'innerValue2',
          },
          'invalidKey': 'not a map',
        },
        'emptyMap': {},
        'emptyList': [],
        'nullMap': null,
        'nullList': null,
      };
    });

    // Tests for get<T>

    test('get<T> returns defaultValue if key not found', () {
      expect(json.get<bool>('nonExistentKey', defaultValue: true), true);
      expect(json.get<String>('nonExistentKey', defaultValue: 'default'),
          'default');
      expect(json.get<int>('nonExistentKey', defaultValue: 0), 0);
      expect(json.get<double>('nonExistentKey', defaultValue: 0.0), 0.0);
    });

    test('get<T> returns value if conversion succeeds', () {
      expect(json.get<bool>('boolTrue', defaultValue: false), true);
      expect(
          json.get<String>('stringValue', defaultValue: ''), 'Hello, World!');
      expect(json.get<int>('intValue', defaultValue: 0), 42);
      expect(json.get<double>('doubleValue', defaultValue: 0.0), 3.14);
    });

    test('get<T> returns defaultValue if conversion fails', () {
      expect(json.get<bool>('invalidBool', defaultValue: false), false);
      expect(json.get<int>('invalidInt', defaultValue: -1), -1);
      expect(json.get<double>('invalidDouble', defaultValue: -1.0), -1.0);
    });

    // Tests for getNullable<T>

    test('getNullable<T> returns null if key not found', () {
      expect(json.getNullable<bool>('nonExistentKey'), null);
      expect(json.getNullable<String>('nonExistentKey'), null);
      expect(json.getNullable<int>('nonExistentKey'), null);
      expect(json.getNullable<double>('nonExistentKey'), null);
    });

    test('getNullable<T> returns value if conversion succeeds', () {
      expect(json.getNullable<bool>('boolTrue'), true);
      expect(json.getNullable<String>('stringValue'), 'Hello, World!');
      expect(json.getNullable<int>('intValue'), 42);
      expect(json.getNullable<double>('doubleValue'), 3.14);
    });

    test('getNullable<T> returns null if conversion fails', () {
      expect(json.getNullable<bool>('invalidBool'), null);
      expect(json.getNullable<int>('invalidInt'), null);
      expect(json.getNullable<double>('invalidDouble'), null);
    });

    // Tests for getList<E>

    test('getList<E> returns defaultValue if key not found', () {
      expect(json.getList<int>('nonExistentKey', defaultValue: []), []);
      expect(json.getList<String>('nonExistentKey', defaultValue: []), []);
    });

    test('getList<E> returns list if conversion succeeds', () {
      expect(json.getList<int>('listValue', defaultValue: []), [1, 2, 3]);
      expect(json.getList<String>('listString', defaultValue: []),
          ['one', 'two', 'three']);
    });

    test('getList<E> returns defaultValue if conversion fails', () {
      expect(json.getList<int>('listMixed', defaultValue: []), []);
      expect(json.getList<int>('invalidList', defaultValue: []), []);
    });

    test('getList<E> returns list if conversion succeeds for String', () {
      // Assuming listMixed can be converted to List<String>
      expect(json.getList<String>('listMixed', defaultValue: []),
          ['1', 'two', '3.0']);
    });

    // Tests for getNullableList<E>

    test('getNullableList<E> returns null if key not found', () {
      expect(json.getNullableList<int>('nonExistentKey'), null);
      expect(json.getNullableList<String>('nonExistentKey'), null);
    });

    test('getNullableList<E> returns list if conversion succeeds', () {
      expect(json.getNullableList<int>('listValue'), [1, 2, 3]);
      expect(
          json.getNullableList<String>('listString'), ['one', 'two', 'three']);
    });

    test('getNullableList<E> returns null if conversion fails', () {
      expect(json.getNullableList<int>('listMixed'), null);
      expect(json.getNullableList<int>('invalidList'), null);
    });

    // Tests for getMap<K, V>

    test('getMap<K, V> returns defaultValue if key not found', () {
      expect(
          json.getMap<String, String>('nonExistentKey', defaultValue: {}), {});
      expect(json.getMap<String, int>('nonExistentKey', defaultValue: {}), {});
    });

    test('getMap<K, V> returns map if conversion succeeds', () {
      expect(
        json.getMap<String, String>('mapValue', defaultValue: {}),
        {'key1': 'value1', 'key2': 'value2'},
      );
      expect(
        json.getMap<String, int>('mapStringInt', defaultValue: {}),
        {'one': 1, 'two': 2},
      );
    });

    test('getMap<K, V> returns defaultValue if conversion fails', () {
      expect(json.getMap<String, int>('mapValue', defaultValue: {}),
          {}); // 'value1' cannot be converted to int
      expect(json.getMap<String, String>('invalidMap', defaultValue: {}),
          {}); // 'invalidMap' is not a map
    });

    // Tests for getNullableMap<K, V>

    test('getNullableMap<K, V> returns null if key not found', () {
      expect(json.getNullableMap<String, String>('nonExistentKey'), null);
      expect(json.getNullableMap<String, int>('nonExistentKey'), null);
    });

    test('getNullableMap<K, V> returns map if conversion succeeds', () {
      expect(
        json.getNullableMap<String, String>('mapValue'),
        {'key1': 'value1', 'key2': 'value2'},
      );
      expect(
        json.getNullableMap<String, int>('mapStringInt'),
        {'one': 1, 'two': 2},
      );
    });

    test('getNullableMap<K, V> returns null if conversion fails', () {
      expect(json.getNullableMap<String, int>('mapValue'), null);
      expect(json.getNullableMap<String, String>('invalidMap'), null);
    });

    // Tests for empty and null values

    test('getList handles empty and null lists', () {
      expect(json.getList<int>('emptyList', defaultValue: []), []);
      expect(json.getList<int>('nullList', defaultValue: []), []);
    });

    test('getNullableList handles empty and null lists', () {
      expect(json.getNullableList<int>('emptyList'), []);
      expect(json.getNullableList<int>('nullList'), null);
    });

    test('getMap handles empty and null maps', () {
      expect(json.getMap<String, String>('emptyMap', defaultValue: {}), {});
      expect(json.getMap<String, String>('nullMap', defaultValue: {}), {});
    });

    test('getNullableMap handles empty and null maps', () {
      expect(json.getNullableMap<String, String>('emptyMap'), {});
      expect(json.getNullableMap<String, String>('nullMap'), null);
    });

    // Test for nested keys using dot notation

    test('get with nested keys retrieves values using dot notation', () {
      expect(json.get<String>('nestedMap.outerKey1.innerKey', defaultValue: ''),
          'innerValue1');
      expect(json.get<String>('nestedMap.outerKey2.innerKey', defaultValue: ''),
          'innerValue2');
      expect(json.get<String>('nestedMap.invalidKey', defaultValue: ''),
          'not a map');
    });

    // Tests for invalid types

    test('get with invalid types returns default value', () {
      expect(json.get<String>('boolTrue', defaultValue: 'default'), 'true');
      expect(json.get<bool>('stringValue', defaultValue: false), false);
    });
  });
}
