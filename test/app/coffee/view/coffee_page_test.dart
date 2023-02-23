
// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart' hide Coffee;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/coffee/coffee.dart';
import 'package:very_good_coffee/home/home.dart';
import 'package:very_good_coffee/l10n/l10n.dart';
import 'package:very_good_coffee/saved_coffees/view/saved_coffees_page.dart';

import '../../../helpers/hydrated_bloc.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

class MockCoffeeCubit extends MockCubit<CoffeeState> implements CoffeeCubit {}


void main () {
  initHydratedStorage();

  group('CoffeeView', () {
    late CoffeeCubit coffeeCubit;
    late HomeCubit homeCubit;
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

    const coffee = Coffee(
      uid:'test123',
      imageData: kTransparentImage,
    );

    setUp(() {
      coffeeCubit = MockCoffeeCubit();
      homeCubit = HomeCubit();
    });

    testWidgets('renders welcome text during initial state',
            (tester) async {

          when(() => coffeeCubit.state).thenReturn(const CoffeeState());
          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: coffeeCubit),
                BlocProvider.value(value: homeCubit),
              ],
              child: const MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                locale: Locale('en'),
                home: HomeView(),
              ),
            ),
          );

          expect(find.text('Welcome to Very Good Coffee'), findsOneWidget);

        });

    testWidgets('renders circular progress indicator when loading',
            (tester) async {

          when(() => coffeeCubit.state).thenReturn(
            const CoffeeState(status: CoffeeStatus.loading),);
          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: coffeeCubit),
                BlocProvider.value(value: homeCubit),
              ],
              child: const MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                locale: Locale('en'),
                home: HomeView(),
              ),
            ),
          );

          expect(find.byType(CircularProgressIndicator), findsOneWidget);

        });

    testWidgets('renders image after successfully loading from API',
            (tester) async {

          when(() => coffeeCubit.state).thenReturn(
            const CoffeeState(
              status: CoffeeStatus.success,
              coffee: coffee,
            ),);
          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: coffeeCubit,),
                BlocProvider.value(value: homeCubit),
              ],
              child: const MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                locale: Locale('en'),
                home: HomeView(),
              ),
            ),
          );

          expect(find.byType(Image), findsOneWidget);

        });

    testWidgets('renders failure text on failure state',
            (tester) async {

          when(() => coffeeCubit.state).thenReturn(const CoffeeState(
            status: CoffeeStatus.failure,
          ),);
          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: coffeeCubit),
                BlocProvider.value(value: homeCubit),
              ],
              child: const MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                locale: Locale('en'),
                home: HomeView(),
              ),
            ),
          );

          expect(find.text('Failed to load image.\n'
              'Please check your internet connection and try again.'),
            findsOneWidget,);

        });

    testWidgets('navigates to Saved page when save is tapped', (tester) async {
      when(() => coffeeCubit.state).thenReturn(const CoffeeState());
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: coffeeCubit),
            BlocProvider.value(value: homeCubit),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: Locale('en'),
            home: HomeView(),
          ),
        ),
      );
      await tester.tap(find.byTooltip('Saved Tab'));
      await tester.pumpAndSettle();
      expect(find.byType(SavedCoffeesPage), findsOneWidget);
    });

    testWidgets('navigates to Home page when home is tapped', (tester) async {
      when(() => coffeeCubit.state).thenReturn(const CoffeeState());
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: coffeeCubit),
            BlocProvider.value(value: homeCubit),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: Locale('en'),
            home: HomeView(),
          ),
        ),
      );
      await tester.tap(find.byTooltip('Home Tab'));
      await tester.pumpAndSettle();
      expect(find.byType(CoffeePage), findsOneWidget);
    });


    testWidgets('calls fetch new coffee on reload tap', (tester) async {
      when(() => coffeeCubit.state).thenReturn(const CoffeeState(
        status: CoffeeStatus.success,
        coffee: coffee,
      ),);
      when(() => coffeeCubit.fetchCoffeeImage()).thenAnswer((_) async {});
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: coffeeCubit),
            BlocProvider.value(value: homeCubit),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: Locale('en'),
            home: HomeView(),
          ),
        ),
      );

      await tester.ensureVisible(find.byType(LoadNewCoffeeButton));
      await tester.tap(find.byType(LoadNewCoffeeButton));
      await tester.pumpAndSettle();
      verify(() => coffeeCubit.fetchCoffeeImage()).called(1);
    });

    testWidgets('shows snackbar when coffee is saved', (tester) async {

      final initialState = CoffeeState(
        status: CoffeeStatus.success,
        coffee: coffee,
        savedCoffees: const <Coffee>[],
        selectedCoffee: Coffee.empty,
      );
      when(() => coffeeCubit.state).thenReturn(initialState,);
      when(() => coffeeCubit.saveCurrentCoffee()).thenAnswer((_) async {});
      whenListen(coffeeCubit, Stream<CoffeeState>.fromIterable([
        initialState,
        initialState.copyWith(
          savedCoffees: [coffee],
          coffee: coffee.copyWith(
            isLiked: true,
          ),
        )
      ]),);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: coffeeCubit),
            BlocProvider.value(value: homeCubit),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: Locale('en'),
            home: HomeView(),
          ),
        ),
      );

      await tester.ensureVisible(find.byType(SaveCoffeeButton));
      await tester.tap(find.byType(SaveCoffeeButton));
      await tester.pumpAndSettle();
      expect(find.byType(ScaffoldMessenger), findsOneWidget);

    });


  });
}
