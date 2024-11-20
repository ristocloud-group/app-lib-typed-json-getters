# Typed JSON Getters

A Dart library providing type-safe getters for JSON maps (`Map<String, dynamic>`) with robust error handling and support for nested keys using dot notation.

## Features

- **Type-Safe Access**: Retrieve values with explicit types.
- **Default Values**: Provide default values when keys are missing.
- **Error Handling**: Throws `FormatException` when type conversion fails.
- **Nested Key Support**: Access nested JSON properties using dot notation.

## Installation

Add `typed_json_getters` to your `pubspec.yaml`:

```yaml
dependencies:
  typed_json_getters: ^1.0.0