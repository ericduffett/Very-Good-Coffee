//ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart' hide Coffee;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/coffee/coffee.dart';
import 'package:very_good_coffee/home/home.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

import '../../helpers/hydrated_bloc.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

class MockCoffeeCubit extends MockCubit<CoffeeState> implements CoffeeCubit {}

void main() {
  initHydratedStorage();

  group('CoffeeApp', () {
    late CoffeeRepository coffeeRepository;

    setUp(() {
      coffeeRepository = CoffeeRepository();
    });

    testWidgets('renders App', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: coffeeRepository,
          child: CoffeeApp(
            coffeeRepository: coffeeRepository,
          ),
        ),
      );
      expect(find.byType(CoffeeAppView), findsOneWidget);
    });
  });

  group('HomePage', () {
    late CoffeeRepository coffeeRepository;

    setUp(() {
      coffeeRepository = CoffeeRepository();
    });

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: coffeeRepository,
          child: const MaterialApp(
            home: HomePage(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: Locale('en'),
          ),
        ),
      );
      expect(find.byType(HomeView), findsOneWidget);
    });
  });
}
