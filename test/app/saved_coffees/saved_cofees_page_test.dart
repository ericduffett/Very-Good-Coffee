//ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart' hide Coffee;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
//import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/coffee/coffee.dart';
import 'package:very_good_coffee/home/home.dart';
import 'package:very_good_coffee/l10n/l10n.dart';
import 'package:very_good_coffee/saved_coffees/saved_coffees.dart';
import 'package:very_good_coffee/saved_coffees/view/saved_coffees_page.dart';

import '../../helpers/hydrated_bloc.dart';


class MockCoffeeCubit extends MockCubit<CoffeeState> implements CoffeeCubit {}

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}


void main() {
  initHydratedStorage();

  group('Saved Coffees Page', () {
    late CoffeeCubit coffeeCubit;
    //late HomeCubit homeCubit;
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

    final coffee = Coffee(
      uid: 'test123',
      imageData: kTransparentImage,
      isLiked: true,
    );

    setUp(() {
      coffeeCubit = MockCoffeeCubit();
      //homeCubit = MockHomeCubit();
    });

    testWidgets('renders text when no saved images', (tester) async {
      //when(() => homeCubit.state).thenReturn(HomeState(tab: HomeTab.saved));
      when(() => coffeeCubit.state).thenReturn(CoffeeState(
        status: CoffeeStatus.success,
        coffee: coffee,
        savedCoffees: Coffee.noFavorites,
      ),);

      await tester.pumpWidget(
        BlocProvider<CoffeeCubit>.value(
          value: coffeeCubit,
          child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              locale: Locale('en'),
              home: Scaffold(body: SavedCoffeesPage())),
        ),
      );

      expect(find.text("You don't have any saved coffees."), findsOneWidget);
    });


    testWidgets('renders as many inkwell as saved coffees', (tester) async {
      //when(() => homeCubit.state).thenReturn(HomeState(tab: HomeTab.saved));
      when(() => coffeeCubit.state).thenReturn(CoffeeState(
        status: CoffeeStatus.success,
        coffee: coffee,
        savedCoffees: [coffee],
      ),);

      await tester.pumpWidget(
        BlocProvider<CoffeeCubit>.value(
          value: coffeeCubit,
          child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              locale: Locale('en'),
              home: Scaffold(body: SavedCoffeesPage())),
        ),
      );

      expect(find.byType(InkWell),
        findsNWidgets(coffeeCubit.state.savedCoffees.length),);
    });

    test('route to Single Coffee Page is a MaterialPageRoute', () {
      expect(SingleSavedCoffeePage.route(coffeeCubit),
          isA<MaterialPageRoute<void>>(),);
    });


    testWidgets('InkWell calls navigation to view single coffee.', (tester)
    async {
      //when(() => homeCubit.state).thenReturn(HomeState(tab: HomeTab.saved));
      when(() => coffeeCubit.state).thenReturn(CoffeeState(
        status: CoffeeStatus.success,
        coffee: coffee,
        savedCoffees: [coffee],
        selectedCoffee: coffee,
      ),);

      await tester.pumpWidget(
        BlocProvider<CoffeeCubit>.value(
          value: coffeeCubit,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: Locale('en'),
            home: Scaffold(body: SavedCoffeesPage()),),
        ),
      );


      expect(find.byType(InkWell),
        findsNWidgets(coffeeCubit.state.savedCoffees.length),);

      await tester.tap(find.byType(InkWell).first);
      verify(() => coffeeCubit.selectCoffee(0)).called(1);
      await tester.pumpAndSettle();
      expect(find.byType(SingleSavedCoffeeView), findsOneWidget);


    });
  });
}
