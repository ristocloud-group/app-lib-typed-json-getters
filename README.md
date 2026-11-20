# Typed JSON Getters

[![pub package](https://img.shields.io/pub/v/typed_json_getters.svg)](https://pub.dev/packages/typed_json_getters)
[![Build Status](https://img.shields.io/github/actions/workflow/status/ristocloud-group/app-lib-typed-json-getters/dart.yml)](https://github.com/ristocloud-group/app-lib-typed-json-getters/actions/workflows/dart.yml)
[![Coverage Status](https://github.com/ristocloud-group/app-lib-typed-json-getters/raw/gh-pages/coverage-badge.svg)](https://ristocloud-group.github.io/app-lib-typed-json-getters/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A Dart library providing type-safe getters for JSON maps (`Map<String, dynamic>`) with robust error handling and support for nested keys using dot notation.

## Features

- **Type-Safe Access**: Retrieve values with explicit types.
- **Default Values**: Provide default values when keys are missing.
- **Tolerant Conversion**: A value that cannot be converted gives the default (or `null`), never an exception.
- **Nested Key Support**: Access nested JSON properties using dot notation (`user.details.age`).
- **Strict Readers**: For payloads where a converted value would be wrong (amounts, flags, ids), read only the unambiguous encodings and get `null` for the rest.

## Installation

Add `typed_json_getters` to your `pubspec.yaml`, pinned to a tag:

```yaml
dependencies:
  typed_json_getters:
    git:
      url: https://github.com/ristocloud-group/app-lib-typed-json-getters
      ref: v0.1.0
```

Then import it:

```dart
import 'package:typed_json_getters/typed_json_getters.dart';
```

## Usage

### Typed getters

| Method | Returns | When the key is missing or cannot be converted |
| --- | --- | --- |
| `get<T>(key, defaultValue:)` | `T` | `defaultValue` |
| `getNullable<T>(key)` | `T?` | `null` |
| `getList<E>(key, defaultValue:)` | `List<E>` | `defaultValue` (also when one item fails) |
| `getNullableList<E>(key)` | `List<E>?` | `null` (also when one item fails) |
| `getMap<K, V>(key, defaultValue:)` | `Map<K, V>` | `defaultValue` |
| `getNullableMap<K, V>(key)` | `Map<K, V>?` | `null` |

`T` is converted when possible: `String` from any value (`42` reads as `"42"`), `int` from a number (truncated: `42.9` is `42`) or a numeric string, `double` and `num` from a number or a numeric string, `bool` from `true`/`false` or `"true"`/`"false"`.

```dart
final json = <String, dynamic>{
  'user': {'id': 'u123', 'age': '30', 'isActive': 'true'},
};

final age = json.get<int>('user.age', defaultValue: 0); // 30
final active = json.get<bool>('user.isActive', defaultValue: false); // true
final nickname = json.getNullable<String>('user.nickname'); // null
```

### Strict readers

The conversions above are convenient for display data and wrong for data that must not be guessed: a truncated amount, a map read as text, a flag sent as `1`. These readers accept only the unambiguous encodings and give `null` (or skip the entry) for anything else. They support dot notation too.

| Method | Reads | Anything else |
| --- | --- | --- |
| `hasValue(key)` | `true` when the key is found and not `null` | `false` |
| `getStrictString(key)` | a `String`, with no conversion | `null` (a number or a map too) |
| `getDecimal(key)` | a number or a numeric string, comma decimal accepted (`"12,5"`) | `null` |
| `getDecimalList(key)` | the entries readable by `getDecimal` | skipped; not a list is empty |
| `getWholeNumber(key)` | `42`, `42.0`, `"42"` (blanks ignored) | `null`, a fraction included: never cut |
| `getWholeNumberList(key)` | the entries readable by `getWholeNumber` | dropped; not a list is empty |
| `getFlag(key)` | `true`/`false`, `1`/`0`, `"1"`/`"0"`, `"true"`/`"false"` (any case) | `null`, never a default |
| `getObjectList(key)` | the `Map<String, dynamic>` entries of a list | see below |

`getObjectList` returns an empty list when the key is missing or `null`. Otherwise it throws `FormatException` when the value is not a list or an entry is not an object; `skipNonObjects: true` skips those entries, `lenient: true` also reads a value that is not a list as empty.

```dart
final payload = <String, dynamic>{
  'recharge': {
    'enabled': '1',
    'amountsCents': [500, '1000', 1250.5, 'x'],
    'maxCents': 15000.0,
  },
  'dish': {'NetQuantityRaw': '155,1', 'Image': {'URL': 'a.jpg'}},
  'menus': [
    {'id': 1},
    null,
  ],
};

payload.getFlag('recharge.enabled'); // true
payload.getWholeNumberList('recharge.amountsCents'); // [500, 1000]
payload.getWholeNumber('recharge.maxCents'); // 15000
payload.getDecimal('dish.NetQuantityRaw'); // 155.1
payload.getStrictString('dish.Image'); // null (getNullable<String> gives "{URL: a.jpg}")
payload.getObjectList('menus', skipNonObjects: true); // [{id: 1}]

// A missing amount and a malformed one are told apart with hasValue.
final balance = payload.getWholeNumber('balanceCents');
if (balance == null && payload.hasValue('balanceCents')) {
  throw const FormatException('balanceCents is not an integer');
}
```

## Examples

Check out the [example](https://github.com/ristocloud-group/app-lib-typed-json-getters/blob/main/example/main.dart) for more uses.

## Contributing

We welcome contributions! Please see our [Contributing guide](https://github.com/ristocloud-group/app-lib-typed-json-getters/blob/main/.github/CONTRIBUTING.md) for more information.

## License

This project is licensed under the MIT License - see the [License](https://github.com/ristocloud-group/app-lib-typed-json-getters/blob/main/LICENSE) file for details.
