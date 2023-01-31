import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/coffee/cubit/coffee_cubit.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class CoffeePage extends StatelessWidget {
  const CoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CoffeeView();
  }
}


class CoffeeView extends StatelessWidget {
  const CoffeeView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Center(
      child: BlocBuilder<CoffeeCubit, CoffeeState>(
        buildWhen: (previous, current) {
          if (previous.savedCoffees.length != current.savedCoffees.length) {
            return false;
          } else {
            return true;
          }
        },
        builder: (context, state) {
          if (state.status == CoffeeStatus.initial) {
            return const Text('Welcome to Very Good Coffee');
          } else if (state.status == CoffeeStatus.loading) {
            return const CircularProgressIndicator();
          }
          else if (state.status == CoffeeStatus.failure) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Failed to load image.\n'
                    'Please check your internet connection and try again.',
                  textAlign: TextAlign.center,),
                SizedBox(height: 16,),
                LoadNewCoffeeButton(),
              ],
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.memory(state.currentCoffee.imageData,
                height: width,
                width: width,
                fit: BoxFit.cover,
                //fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const[
                  LoadNewCoffeeButton(),
                  SizedBox(
                    width: 16,
                  ),
                  SaveCoffeeButton(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class SaveCoffeeButton extends StatelessWidget {
  const SaveCoffeeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CoffeeCubit>();
    final l10n = context.l10n;
    return BlocListener<CoffeeCubit, CoffeeState>(
      listenWhen: (previous, current) =>
      previous.savedCoffees.length < current.savedCoffees.length,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(l10n.coffeeSavedSnackBarText),
            ),
          );
      },
      child: ElevatedButton(
        onPressed: cubit.saveCurrentCoffee,
        child: const LikeButton(),
      ),
    );
  }
}

class LoadNewCoffeeButton extends StatelessWidget {
  const LoadNewCoffeeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton.icon(
      label: Text(l10n.newCoffeeButtonText),
      onPressed: () =>
          context.read<CoffeeCubit>().fetchCoffeeImage(),
      icon: const Icon(Icons.refresh),
    );
  }
}


class LikeButton extends StatelessWidget {
  const LikeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoffeeCubit, CoffeeState>(
      builder: (context, state) {
        final buttonIcon = state.currentCoffee.isLiked
            ? Icons.favorite : Icons.favorite_border_outlined;
        return Icon(buttonIcon);
      },
    );
  }
}
