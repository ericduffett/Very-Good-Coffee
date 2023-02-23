part of '../../coffee/cubit/coffee_cubit.dart';

enum CoffeeStatus { initial, loading, success, failure }

@JsonSerializable()
class CoffeeState extends Equatable {
  const CoffeeState({
    this.status = CoffeeStatus.initial,
    Coffee? coffee,
    List<Coffee>? savedCoffees,
    Coffee? selectedCoffee,
  })  : currentCoffee = coffee ?? Coffee.empty,
        savedCoffees = savedCoffees ?? Coffee.noFavorites,
        selectedCoffee = selectedCoffee ?? Coffee.empty;

  factory CoffeeState.fromJson(Map<String, dynamic> json) =>
      _$CoffeeStateFromJson(json);

  final CoffeeStatus status;
  final Coffee currentCoffee;
  final List<Coffee> savedCoffees;
  final Coffee selectedCoffee;

  CoffeeState copyWith({
    CoffeeStatus? status,
    Coffee? coffee,
    List<Coffee>? savedCoffees,
    Coffee? selectedCoffee,
  }) {
    return CoffeeState(
      status: status ?? this.status,
      coffee: coffee ?? currentCoffee,
      savedCoffees: savedCoffees ?? this.savedCoffees,
      selectedCoffee: selectedCoffee ?? this.selectedCoffee,
    );
  }

  Map<String, dynamic> toJson() => _$CoffeeStateToJson(this);

  @override
  List<Object?> get props =>
      [status, currentCoffee, savedCoffees, selectedCoffee];
}
