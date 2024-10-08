// Copyright 2024, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: unused_local_variable

import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Serializer<T> = String Function(T value);
typedef Deserializer<T> = T Function(String json);

void main() {
  group('Optional', () {
    late Deserializer<String> stringDeserializer;
    late Serializer<String> stringSerializer;
    late Deserializer<int> intDeserializer;
    late Serializer<int> intSerializer;

    setUp(() {
      stringDeserializer = (json) => json;
      stringSerializer = (value) => value.toString();
      intDeserializer = (json) => int.parse(json);
      intSerializer = (value) => value.toString();
    });

    test('constructor initializes with deserializer', () {
      final optional = Optional<String>(stringDeserializer);
      expect(optional.deserializer, equals(stringDeserializer));
      expect(optional.state, equals(OptionalState.unset));
      expect(optional.value, isNull);
    });

    test('constructor initializes with deserializer and serializer', () {
      final optional = Optional.optional(stringDeserializer, stringSerializer);
      expect(optional.deserializer, equals(stringDeserializer));
      expect(optional.serializer, equals(stringSerializer));
    });

    test('value setter updates value and sets state', () {
      final optional = Optional<String>(stringDeserializer);

      optional.value = 'Test';
      expect(optional.value, equals('Test'));
      expect(optional.state, equals(OptionalState.set));
    });

    test('fromJson correctly deserializes and sets value', () {
      final optional = Optional<String>(stringDeserializer);

      optional.fromJson('Test');
      expect(optional.value, equals('Test'));
      expect(optional.state, equals(OptionalState.set));
    });

    test('toJson correctly serializes the value', () {
      final optional = Optional.optional(stringDeserializer, stringSerializer);

      optional.value = 'Test';
      expect(optional.toJson(), equals('Test'));
    });

    test('toJson returns empty string when value is null', () {
      final optional = Optional.optional(stringDeserializer, stringSerializer);

      optional.value = null;
      expect(optional.toJson(), equals(''));
    });

    test('nativeToJson correctly serializes primitive types', () {
      expect(nativeToJson(42), equals('42'));
      expect(nativeToJson(true), equals('true'));
      expect(nativeToJson('Test'), equals('Test'));
    });

    test('nativeFromJson correctly deserializes primitive types', () {
      expect(nativeFromJson<int>('42'), equals(42));
      expect(nativeFromJson<bool>('true'), equals(true));
      expect(nativeFromJson<String>('Test'), equals('Test'));
    });

    test('nativeToJson throws UnimplementedError for unsupported types', () {
      expect(() => nativeToJson(DateTime.now()), throwsUnimplementedError);
    });

    test('nativeFromJson throws UnimplementedError for unsupported types', () {
      expect(() => nativeFromJson<DateTime>('2024-01-01'),
          throwsUnimplementedError);
    });
  });
}
