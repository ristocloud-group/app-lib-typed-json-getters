## 0.2.0 — 25/11/2026

- Required readers for the fields a model cannot do without: `getRequiredWholeNumber`,
  `getRequiredString`, `getRequiredFlag`, `getRequiredObject` and `getRequiredDateTime` return the
  value or throw `FormatException('<key> is not a ...')` with the key as passed, dots included.
- `getDateTime` parses a date only from a `String` (`DateTime.tryParse`), keeps its time zone and
  gives `null` for a number, a map or a text that is not a date.
- No existing method changes behaviour: nothing breaks for current users.

## 0.1.0

- Strict readers for data that must not be guessed: `hasValue`, `getStrictString`, `getDecimal`,
  `getDecimalList`, `getWholeNumber`, `getWholeNumberList`, `getFlag` and `getObjectList`
  (`lenient`, `skipNonObjects`). They support dot notation like the other getters.
- README: installation from the git tag, the conversion rules of the typed getters and the strict
  readers.

## 0.0.4

- Fix get map with null values

## 0.0.3

- Refactoring and update test

## 0.0.2

- Add example doc 

## 0.0.1

- Initial version.
