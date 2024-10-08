// Copyright 2024, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of firebase_data_connect;

/// Keeps track of whether the value has been set or not
enum OptionalState { unset, set }

/// Optional Class that allows users to pass in null or undefined for properties on a class.
/// If the state value is set, then we make sure to include it in the request over the wire.
/// If it's unset, then the value is ignored when sending over the wire.
class Optional<T> {
  /// Instantiates deserializer.
  Optional(this.deserializer);

  /// Instantiates deserializer and serializer.
  Optional.optional(this.deserializer, this.serializer);

  /// State of the value. Is unset by default.
  OptionalState state = OptionalState.unset;

  /// Serializer for value.
  Serializer<T>? serializer;

  /// Deserializer for value.
  Deserializer<T> deserializer;

  /// Current value.
  T? _value;

  /// Sets the value for the variable, and the state to `Set`.
  set value(T? val) {
    _value = val;
    state = OptionalState.set;
  }

  /// Gets the current value of the object.
  T? get value {
    return _value;
  }

  /// Converts json to the value.
  void fromJson(dynamic json) {
    if (json is List) {
      value = json.map((e) => deserializer(e)) as T;
    } else {
      value = deserializer(json as String);
    }
  }

  /// Converts the value to String.
  String toJson() {
    if (_value != null) {
      if (serializer != null) {
        if (_value is List) {
          return (_value! as List).map((e) => serializer!(e)).toString();
        }
        return serializer!(_value as T);
      } else {
        return _value.toString();
      }
    }
    return '';
  }
}

String nativeToJson<T>(T type) {
  if (type is bool || type is int || type is double || type is num) {
    return type.toString();
  } else if (type is String) {
    return type;
  } else {
    throw UnimplementedError('This type is unimplemented: ${type.runtimeType}');
  }
}

T nativeFromJson<T>(String json) {
  if (T == bool) return (json.toLowerCase() == 'true') as T;
  if (T == int) return int.parse(json) as T;
  if (T == double) return double.parse(json) as T;
  if (T == num) return num.parse(json) as T;
  if (T == String) return json as T;

  throw UnimplementedError('This type is unimplemented: ${T.runtimeType}');
}
