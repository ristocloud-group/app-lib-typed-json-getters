part of '../typed_json_getters.dart';

/// Extension providing type-safe getters for Map<String, dynamic>
extension TypedJsonGettersExtension on Map<String, dynamic> {
  /// Retrieves a value of type [T] for the given [key].
  ///
  /// - **Returns**: The value associated with [key] converted to type [T].
  /// - **Default Value**: If [key] is not found or conversion fails, returns [defaultValue].
  T get<T>(String key, {required T defaultValue}) {
    final value = _extractValue(key);
    if (value == null) {
      return defaultValue;
    }
    final converted = _convertValue<T>(value);
    return converted ?? defaultValue;
  }

  /// Retrieves a nullable value of type [T] for the given [key].
  ///
  /// - **Returns**: The value associated with [key] converted to type [T].
  /// - **Null Handling**: If [key] is not found or conversion fails, returns `null`.
  T? getNullable<T>(String key) {
    final value = _extractValue(key);
    if (value == null) {
      return null;
    }
    return _convertValue<T>(value);
  }

  /// Retrieves a list of type [E] for the given [key].
  ///
  /// - **Returns**: A `List<E>` containing all items converted to type [E].
  /// - **Default Value**: If [key] is not found or any item cannot be converted to type [E], returns [defaultValue].
  List<E> getList<E>(String key, {required List<E> defaultValue}) {
    final value = _extractValue(key);
    if (value == null || value is! List) {
      return defaultValue;
    }
    final result = <E>[];
    for (var item in value) {
      final converted = _convertValue<E>(item);
      if (converted == null) {
        // If any item fails, return defaultValue
        return defaultValue;
      }
      result.add(converted);
    }
    return result;
  }

  /// Retrieves a nullable list of type [E] for the given [key].
  ///
  /// - **Returns**: A `List<E>` containing all items converted to type [E].
  /// - **Null Handling**: If [key] is not found or any item cannot be converted to type [E], returns `null`.
  List<E>? getNullableList<E>(String key) {
    final value = _extractValue(key);
    if (value == null || value is! List) {
      return null;
    }
    final result = <E>[];
    for (var item in value) {
      final converted = _convertValue<E>(item);
      if (converted == null) {
        // If any item fails, return null
        return null;
      }
      result.add(converted);
    }
    return result;
  }

  /// Retrieves a map of type [K, V] for the given [key].
  ///
  /// - **Returns**: A `Map<K, V>` with all keys and values converted to types [K] and [V].
  /// - **Default Value**: If [key] is not found or any key/value cannot be converted to type [K], [V], returns [defaultValue].
  Map<K, V> getMap<K, V>(String key, {required Map<K, V> defaultValue}) {
    final value = _extractValue(key);
    if (value == null || value is! Map) {
      return defaultValue;
    }
    final result = <K, V>{};
    for (var entry in value.entries) {
      final keyConverted = _convertValue<K>(entry.key);
      final valueConverted = _convertValue<V>(entry.value);

      if (keyConverted == null) {
        return defaultValue;
      }

      // If conversion resulted in null, we must check if that's valid.
      // It is INVALID if:
      // 1. The original value was NOT null (meaning conversion failed), OR
      // 2. The original value WAS null, but type V is not nullable (e.g., int).
      if (valueConverted == null && (entry.value != null || null is! V)) {
        return defaultValue;
      }

      // Safe cast because we verified nullability above
      result[keyConverted] = valueConverted as V;
    }
    return result;
  }

  /// Retrieves a nullable map of type [K, V] for the given [key].
  ///
  /// - **Returns**: A `Map<K, V>` with all keys and values converted to types [K] and [V].
  /// - **Null Handling**: If [key] is not found or any key/value cannot be converted to type [K], [V], returns `null`.
  Map<K, V>? getNullableMap<K, V>(String key) {
    final value = _extractValue(key);
    if (value == null || value is! Map) {
      return null;
    }
    final result = <K, V>{};
    for (var entry in value.entries) {
      final keyConverted = _convertValue<K>(entry.key);
      final valueConverted = _convertValue<V>(entry.value);

      if (keyConverted == null) {
        return null;
      }

      // Validation logic same as getMap
      if (valueConverted == null && (entry.value != null || null is! V)) {
        return null;
      }

      result[keyConverted] = valueConverted as V;
    }
    return result;
  }

  /// Extracts the value for the given [key], supporting nested keys using dot notation.
  dynamic _extractValue(String key) {
    final parts = key.split('.');
    dynamic value = this;
    for (final part in parts) {
      if (value is Map && value.containsKey(part)) {
        value = value[part];
      } else {
        return null;
      }
    }
    return value;
  }

  /// Converts [value] to type [T]. Returns null if conversion is not possible.
  static T? _convertValue<T>(dynamic value) {
    if (value == null) {
      return null;
    }

    if (T == bool) {
      return _convertToBool(value) as T?;
    } else if (T == String) {
      return _convertToString(value) as T?;
    } else if (T == int) {
      return _convertToInt(value) as T?;
    } else if (T == double) {
      return _convertToDouble(value) as T?;
    } else if (T == num) {
      return _convertToNum(value) as T?;
    } else if (T == List || T == Map) {
      try {
        return value as T;
      } catch (e) {
        return null;
      }
    } else {
      try {
        return value as T;
      } catch (e) {
        return null;
      }
    }
  }

  static bool? _convertToBool(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is String) {
      final lowerValue = value.toLowerCase();
      if (lowerValue == 'true') return true;
      if (lowerValue == 'false') return false;
    }
    return null;
  }

  static String? _convertToString(dynamic value) {
    if (value is String) {
      return value;
    } else if (value != null) {
      return value.toString();
    }
    return null;
  }

  static int? _convertToInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is num) {
      return value.toInt();
    } else if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static double? _convertToDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is num) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static num? _convertToNum(dynamic value) {
    if (value is num) {
      return value;
    } else if (value is String) {
      return num.tryParse(value);
    }
    return null;
  }
}
