// ignore_for_file: prefer_const_constructors
import 'dart:html';
import 'dart:typed_data';

import 'package:coffee_api/coffee_api.dart' as coffee_api;
import 'package:coffee_repository/coffee_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCoffeeClient extends Mock implements coffee_api.CoffeeApi {}

class MockCoffee extends Mock implements Coffee {}

class MockCoffeeData extends Mock implements coffee_api.CoffeeData {}



void main() {
  group('CoffeeRepository', () {

    late coffee_api.CoffeeApi coffeeApi;
    late CoffeeRepository coffeeRepository;

    setUp(() {
      coffeeApi = MockCoffeeClient();
      coffeeRepository = CoffeeRepository(
        coffeeApi: coffeeApi,
      );
    });

    test('can be instantiated', () {
      expect(CoffeeRepository(), isNotNull);
    });

    test('calls getRandomCoffee', () async {
      try {
        await coffeeRepository.getRandomCoffee();
      } catch (_) {
        verify(() => coffeeApi.getCoffeeData()).called(1);
      }
    });

    test('throws exception when getRandomCoffee fails', () async {
      final exception = Exception('could not get coffee');
      when(() => coffeeApi.getCoffeeData()).thenThrow(exception);
      expect(
          () async =>  coffeeRepository.getRandomCoffee(), throwsA(exception),
      );
    } );

    test('returns correct construction of Coffee on getRandomCoffee', () async {
      const uid = 'testUID';
      final imageData = Uint8List.fromList([0, 1, 2]);
      final coffeeData = MockCoffeeData();
      when(() => coffeeData.uid).thenReturn(uid);
      when(() => coffeeData.imageData).thenReturn(imageData);
      when(() => coffeeApi.getCoffeeData()).thenAnswer((_) async => coffeeData);
      final actual = await coffeeRepository.getRandomCoffee();
      expect(actual.uid, 'testUID');
      expect(actual.imageData, Uint8List.fromList([0, 1, 2]));
    });

  });
}
