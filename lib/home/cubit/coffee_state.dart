part of 'coffee_cubit.dart';

enum CoffeeStatus {initial, loading, success, failure}

extension CoffeeStatusX on CoffeeStatus {
  bool get isInitial => this == CoffeeStatus.initial;
  bool get isLoading => this == CoffeeStatus.loading;
  bool get isSuccess => this == CoffeeStatus.success;
  bool get isFailure => this == CoffeeStatus.failure;
}

@JsonSerializable()
class CoffeeState extends Equatable {
  const CoffeeState({
    this.status = CoffeeStatus.initial,
    Coffee? coffee,
    List<Coffee>? savedCoffees,
    Coffee? selectedCoffee,
  }) : currentCoffee = coffee ?? Coffee.empty,
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
   // print('you have $savedCoffees saved coffeees');
    return CoffeeState(
      status: status ?? this.status,
      coffee: coffee ?? currentCoffee,
      savedCoffees: savedCoffees ?? this.savedCoffees,
      selectedCoffee: selectedCoffee ?? this.selectedCoffee,
    );
  }

  Map<String, dynamic> toJson() => _$CoffeeStateToJson(this);

  @override
  List<Object?> get props => [
    status, currentCoffee, savedCoffees, selectedCoffee
  ];
}
