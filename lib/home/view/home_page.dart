import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/coffee/coffee.dart';
import 'package:very_good_coffee/home/cubit/home_cubit.dart';
import 'package:very_good_coffee/l10n/l10n.dart';
import 'package:very_good_coffee/saved_coffees/view/saved_coffees_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(),
        ),
        BlocProvider<CoffeeCubit>(
          create: (_) =>
          CoffeeCubit(context.read<CoffeeRepository>())
            ..fetchCoffeeImage(),),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appBarTitle),),
      body: IndexedStack(
        index: selectedTab.index,
        children: const [CoffeePage(), SavedCoffeesPage()],),
      bottomNavigationBar: BottomAppBar(
        padding:  EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <_HomeTabButton>[
            _HomeTabButton(
              tooltip: l10n.homeTabToolTip,
              groupValue: selectedTab,
              value: HomeTab.home,
              icon: Icon(selectedTab == HomeTab.home ?
              Icons.coffee : Icons.coffee_outlined,),
            ),
            _HomeTabButton(
              tooltip: l10n.savedTabToolTip,
              groupValue: selectedTab,
              value: HomeTab.saved,
              icon: Icon(selectedTab == HomeTab.saved ?
              Icons.favorite : Icons.favorite_border_outlined,),
            ),

          ],
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
    required this.tooltip,
  });


  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: () => context.read<HomeCubit>().setTab(value),
      iconSize: 32,
      color:
      groupValue != value ? null : Theme
          .of(context)
          .colorScheme
          .secondary,
      icon: icon,
    );
  }
}
