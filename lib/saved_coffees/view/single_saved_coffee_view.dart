import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/coffee/cubit/coffee_cubit.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class SingleSavedCoffeePage extends StatelessWidget {
  const SingleSavedCoffeePage({super.key});

  static Route<void> route(CoffeeCubit cubit) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/singleCoffee'),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const SingleSavedCoffeeView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SingleSavedCoffeeView();
  }
}



class SingleSavedCoffeeView extends StatelessWidget {
  const SingleSavedCoffeeView({super.key});

  // static Route<void> route() {
  //   return MaterialPageRoute(
  //     builder: (_) => const SingleSavedCoffeeView(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final selectedCoffee = context.read<CoffeeCubit>().state.selectedCoffee;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
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
      ),
    );
  }
}

class DeleteSavedCoffeeButton extends StatelessWidget {
  const DeleteSavedCoffeeButton({super.key});

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

