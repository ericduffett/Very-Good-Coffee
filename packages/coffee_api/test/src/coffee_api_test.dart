// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_api/src/models/coffee_data.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCoffeeClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('CoffeeApi', () {
    late http.Client httpClient;
    late CoffeeApi apiClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockCoffeeClient();
      apiClient = CoffeeApi(httpClient: httpClient);
    });

    group('constructor', () {
      test('does not require an httpClient', () {
        expect(CoffeeApi(), isNotNull);
      });
    });

    group('coffeeRequest', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await apiClient.getCoffeeData();
        } catch (_) {}
        verify(
          () => httpClient.get(
            Uri.https(
              'coffee.alexflipnote.dev',
              '/random.json',
            ),
          ),
        ).called(1);
      });

      test('throws CoffeeRequestFailure on non-200 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          () async => apiClient.getCoffeeData(),
          throwsA(isA<CoffeeRequestFailure>()),
        );
      });

      test(
          'throws a CoffeeRequestFailure if file url provided fails to connect',
          () async {
        final response = MockResponse();
        final mockCoffee = Coffee(
          file: 'https://coffee.alexflipnote.dev/_QSYrowFdg0_coffee.png',
        );
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          () async => apiClient.getCoffeeImageAsData(mockCoffee),
          throwsA(isA<CoffeeRequestFailure>()),
        );
      });
    });

    test('throws a CoffeeNotFound failure on error response', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('{}');
      when(() => httpClient.get(any())).thenAnswer((_) async => response);
      await expectLater(
        apiClient.getCoffeeData(),
        throwsA(isA<CoffeeNotFoundFailure>()),
      );
    });

    test(
        'throws a CoffeeNotFound failure when API does not have '
        'a file parameter', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('{"url": ""}');
      when(() => httpClient.get(any())).thenAnswer((_) async => response);
      await expectLater(
        apiClient.getCoffeeData(),
        throwsA(isA<CoffeeNotFoundFailure>()),
      );
    });

    test('returns valid Coffee response', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('''
      {
        "file": "https://coffee.alexflipnote.dev/_QSYrowFdg0_coffee.png"
      }
      ''');
      when(() => response.bodyBytes).thenReturn(Uint8List.fromList([100]));
      when(() => httpClient.get(any())).thenAnswer((_) async => response);
      final actual = await apiClient.getCoffeeData();
      expect(
        actual,
        isA<CoffeeData>()
            .having((c) => c.uid, 'uid', '_QSYrowFdg0')
            .having((c) => c.imageData, 'imageData', Uint8List.fromList([100])),
      );
    });

    test("extracts UID when pattern doesn't match expectation", () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('''
      {
        "file": "https://cofee.alexflipnote.dev/_QSYrowFdg0.jpg"
      }
      ''');
      when(() => response.bodyBytes).thenReturn(Uint8List.fromList([100]));
      when(() => httpClient.get(any())).thenAnswer((_) async => response);
      final actual = await apiClient.getCoffeeData();
      expect(
        actual,
        isA<CoffeeData>()
            .having((c) => c.uid, 'uid',
                'https://cofee.alexflipnote.dev/_QSYrowFdg0.jpg')
            .having((c) => c.imageData, 'imageData', Uint8List.fromList([100])),
      );
    });
  });
}
