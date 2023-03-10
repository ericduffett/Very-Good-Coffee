import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/coffee/cubit/coffee_cubit.dart';
import 'package:very_good_coffee/l10n/l10n.dart';
import 'package:very_good_coffee/saved_coffees/view/single_saved_coffee_view.dart';

class SavedCoffeesPage extends StatelessWidget {
  const SavedCoffeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoffeeCubit, CoffeeState>(
      buildWhen: (previous, current) {
        if (previous.savedCoffees.length != current.savedCoffees.length) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state.savedCoffees.isEmpty) {
          return Center(
            child: Text(context.l10n.noSavedCoffeesText),
          );
        } else {
          return GridView.count(
            crossAxisCount: 3,
            children: List.generate(state.savedCoffees.length, (index) {
              return InkWell(
                onTap: () {
                  context.read<CoffeeCubit>().selectCoffee(index);
                  Navigator.of(context).push(
                    SingleSavedCoffeePage.route(context.read<CoffeeCubit>()),
                  );
                },
                child: Image.memory(
                  state.savedCoffees[index].imageData,
                  fit: BoxFit.cover,
                ),
              );
            }),
          );
        }
      },
    );
  }
}
