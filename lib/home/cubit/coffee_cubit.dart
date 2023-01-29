
import 'package:coffee_repository/coffee_repository.dart' show CoffeeRepository;
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_coffee/home/models/models.dart';

part 'coffee_cubit.g.dart';
part 'coffee_state.dart';

class CoffeeCubit extends HydratedCubit<CoffeeState> {
  CoffeeCubit(this._coffeeRepository) : super(const CoffeeState());

  final CoffeeRepository _coffeeRepository;

  void deleteCoffee() {
    final savedCoffees = state.savedCoffees.map((c) => c).toList()
    ..removeWhere((coffee) => coffee.uid == state.selectedCoffee.uid);
    emit(
      state.copyWith(
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

    if (!savedCoffees.contains(state.currentCoffee)) {
      savedCoffees.add(state.currentCoffee);
    } else {
      print("did not add duplicate coffee");
    }

    emit(
      state.copyWith(
        savedCoffees: savedCoffees,
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
