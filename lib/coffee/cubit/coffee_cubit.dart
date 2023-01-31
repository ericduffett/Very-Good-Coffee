
import 'package:coffee_repository/coffee_repository.dart' show CoffeeRepository;
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_coffee/coffee/models/models.dart';

part 'coffee_cubit.g.dart';
part '../../coffee/cubit/coffee_state.dart';

class CoffeeCubit extends HydratedCubit<CoffeeState> {
  CoffeeCubit(this._coffeeRepository) : super(const CoffeeState());

  final CoffeeRepository _coffeeRepository;

  void deleteCoffee() {
    var currentCoffee = state.currentCoffee;

    if (currentCoffee.uid == state.selectedCoffee.uid) {
      currentCoffee = state.currentCoffee.copyWith(
        isLiked: state.currentCoffee != state.selectedCoffee,
      );
    }


    final savedCoffees = state.savedCoffees.map((c) => c).toList()
      ..removeWhere((coffee) => coffee.uid == state.selectedCoffee.uid);

    emit(
      state.copyWith(
        coffee: currentCoffee,
        savedCoffees: savedCoffees,
        selectedCoffee: Coffee.empty,
      ),
    );
  }

  Future<void> fetchCoffeeImage() async {
    emit(state.copyWith(status: CoffeeStatus.loading));
    try {
      final coffee = Coffee.fromRepository(
        await _coffeeRepository.getRandomCoffee(),
      );

      emit(state.copyWith(
        status: CoffeeStatus.success,
        coffee: coffee,
      ),
      );

    } on Exception {
      emit(state.copyWith(status: CoffeeStatus.failure));
    }
  }

  Future<void> saveCurrentCoffee() async {

    final savedCoffees = state.savedCoffees.map((c) => c).toList();
    final currentCoffee = state.currentCoffee.copyWith(
      isLiked: true,
    );

    if (!savedCoffees.contains(state.currentCoffee)) {
      savedCoffees.add(currentCoffee);
    }

    emit(
      state.copyWith(
        savedCoffees: savedCoffees,
        coffee: currentCoffee,
      ),
    );
  }

  void selectCoffee(int index) {
    final selection = state.savedCoffees[index];
    emit(
      state.copyWith(
        selectedCoffee: selection,
      ),
    );
  }

  @override
  CoffeeState fromJson(Map<String, dynamic> json) =>
      CoffeeState.fromJson(json);

  @override
  Map<String, dynamic> toJson(CoffeeState state) => state.toJson();
}
