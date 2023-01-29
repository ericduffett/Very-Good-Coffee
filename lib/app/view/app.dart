import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:very_good_coffee/home/cubit/coffee_cubit.dart';
import 'package:very_good_coffee/home/cubit/home_cubit.dart';
import 'package:very_good_coffee/home/view/coffee_page.dart';
import 'package:very_good_coffee/l10n/l10n.dart';



class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key, required CoffeeRepository coffeeRepository})
      : _coffeeRepository = coffeeRepository;

  final CoffeeRepository _coffeeRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _coffeeRepository,
      child: const CoffeeAppView(),
    );
  }
}

class CoffeeAppView extends StatelessWidget {
  const CoffeeAppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF4a120d),
         fontFamily: GoogleFonts.kalam().fontFamily,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}

