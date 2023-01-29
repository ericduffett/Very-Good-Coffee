import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/home/cubit/coffee_cubit.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class ViewSavedCoffeePage extends StatelessWidget {
  const ViewSavedCoffeePage({super.key});

  //  static Route<void> route(CoffeeCubit blocValue) {
  //   return MaterialPageRoute<ViewSavedCoffeePage>(
  //     builder: (context2) {
  //       return BlocProvider<CoffeeCubit>.value(
  //         value: blocValue,
  //         child: const ViewSavedCoffeePage(),
  //       );
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return const SavedCoffeeView();
  }
}

class SavedCoffeeView extends StatelessWidget {
  const SavedCoffeeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedCoffee = context.read<CoffeeCubit>().state.selectedCoffee;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Image.memory(
              selectedCoffee.imageData,
            height: width,
            width: width,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 16,
          ),
          const DeleteSavedCoffeeButton(),
        ],
      ),
    );
  }
}

class DeleteSavedCoffeeButton extends StatelessWidget {
  const DeleteSavedCoffeeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton.icon(
      label: Text(l10n.viewSavedCoffeeRemoveCoffeeButtonText),
      onPressed: () {
        context.read<CoffeeCubit>().deleteCoffee();
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.delete_rounded),
    );
  }
}


