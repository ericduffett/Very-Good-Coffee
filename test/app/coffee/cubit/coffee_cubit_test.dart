// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart' as coffee_repository;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/coffee/coffee.dart';

import '../../../helpers/hydrated_bloc.dart';

const uid = 'test';
const kTransparentImage = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
];

class MockCoffeeRepository extends Mock
    implements coffee_repository.CoffeeRepository {}

class MockCoffee extends Mock implements coffee_repository.Coffee {}

void main() {
  initHydratedStorage();

  group('CoffeeCubit', () {
    late coffee_repository.Coffee coffee;
    late coffee_repository.CoffeeRepository coffeeRepository;
    late CoffeeCubit coffeeCubit;

    setUp(() async {
      coffee = MockCoffee();
      coffeeRepository = MockCoffeeRepository();
      when(() => coffee.uid).thenReturn(uid);
      when(() => coffee.imageData).thenReturn(
        Uint8List.fromList(kTransparentImage),
      );
      when(() => coffeeRepository.getRandomCoffee())
          .thenAnswer((_) async => coffee);
      coffeeCubit = CoffeeCubit(coffeeRepository);
    });

    test('initial state is correct', () {
      final coffeeCubit = CoffeeCubit(coffeeRepository);
      expect(coffeeCubit.state, CoffeeState());
    });

    group('toJSon/fromJson', () {
      test('work properly', () {
        final coffeeCubit = CoffeeCubit(coffeeRepository);
        expect(
          coffeeCubit.fromJson(coffeeCubit.toJson(coffeeCubit.state)),
          coffeeCubit.state,
        );
      });
    });

    group('fetch coffee', () {
      blocTest<CoffeeCubit, CoffeeState>(
        'calls fetchCoffeeImage',
        build: () => coffeeCubit,
        act: (cubit) => cubit.fetchCoffeeImage(),
        verify: (_) {
          verify(() => coffeeRepository.getRandomCoffee()).called(1);
        },
      );

      blocTest<CoffeeCubit, CoffeeState>(
        'emits [loading, failure] when fetchCoffeeImage throws',
        setUp: () {
          when(() => coffeeRepository.getRandomCoffee()).thenThrow(
            Exception('no coffee for you'),
          );
        },
        build: () => coffeeCubit,
        act: (cubit) => cubit.fetchCoffeeImage(),
        expect: () => <CoffeeState>[
          CoffeeState(status: CoffeeStatus.loading),
          CoffeeState(status: CoffeeStatus.failure),
        ],
      );

      blocTest<CoffeeCubit, CoffeeState>(
        'emits [loading, success] when fetchCoffeeImage returns image',
        build: () => coffeeCubit,
        act: (cubit) => cubit.fetchCoffeeImage(),
        expect: () => <dynamic>[
          CoffeeState(status: CoffeeStatus.loading),
          isA<CoffeeState>()
              .having((c) => c.status, 'status', CoffeeStatus.success)
              .having(
                (c) => c.currentCoffee,
                'currentCoffee',
                isA<Coffee>().having((c) => c.uid, 'uid', uid).having(
                      (c) => c.imageData,
                      'imageData',
                      Uint8List.fromList(kTransparentImage),
                    ),
              )
          //CoffeeState(status: CoffeeStatus.failure),
        ],
      );
    });

    group('delete coffee', () {
      final coffee = Coffee(
        uid: uid,
        imageData: kTransparentImage,
        isLiked: true,
      );
      final coffee2 = Coffee(
        uid: 'test2',
        imageData: kTransparentImage,
        isLiked: true,
      );
      final savedCoffees = [coffee, coffee2];
      blocTest<CoffeeCubit, CoffeeState>(
        'deletes coffee from saved list',
        build: () => coffeeCubit,
        seed: () => CoffeeState(
          status: CoffeeStatus.success,
          savedCoffees: savedCoffees,
          coffee: coffee,
          selectedCoffee: coffee,
        ),
        act: (cubit) => cubit.deleteCoffee(),
        expect: () => <dynamic>[
          isA<CoffeeState>()
              .having((c) => c.status, 'status', CoffeeStatus.success)
              .having((c) => c.selectedCoffee, 'selected coffee', Coffee.empty)
              .having(
                (c) => c.savedCoffees,
                'saved coffees',
                savedCoffees..removeWhere((cof) => cof.uid == coffee.uid),
              )
              .having(
                (c) => c.currentCoffee,
                'current coffee',
                coffee.copyWith(
                  isLiked: false,
                ),
              )
        ],
      );
    });

    group('save coffee', () {
      final coffee = Coffee(
        uid: uid,
        imageData: kTransparentImage,
        isLiked: false,
      );

      final state = CoffeeState(
        status: CoffeeStatus.success,
        savedCoffees: const <Coffee>[],
        coffee: coffee,
        selectedCoffee: Coffee.empty,
      );

      blocTest<CoffeeCubit, CoffeeState>(
        'saves coffee',
        build: () => coffeeCubit,
        seed: () => state,
        act: (cubit) => cubit.saveCurrentCoffee(),
        expect: () => <CoffeeState>[
          state.copyWith(
            savedCoffees: <Coffee>[
              coffee.copyWith(
                isLiked: true,
              )
            ],
            coffee: coffee.copyWith(
              isLiked: true,
            ),
          ),
        ],
      );
    });

    group('select coffee', () {
      final coffee = Coffee(
        uid: uid,
        imageData: kTransparentImage,
        isLiked: false,
      );

      final state = CoffeeState(
        status: CoffeeStatus.success,
        savedCoffees: <Coffee>[coffee],
        coffee: coffee,
        selectedCoffee: Coffee.empty,
      );

      blocTest<CoffeeCubit, CoffeeState>(
        'select coffee function',
        build: () => coffeeCubit,
        seed: () => state,
        act: (cubit) => cubit.selectCoffee(0),
        expect: () => <CoffeeState>[
          state.copyWith(
            selectedCoffee: state.savedCoffees[0],
          )
        ],
      );
    });
  });
}
