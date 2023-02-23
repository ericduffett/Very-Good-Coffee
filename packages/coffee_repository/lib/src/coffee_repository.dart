import 'package:coffee_api/coffee_api.dart' hide Coffee;
import 'package:coffee_repository/src/models/coffee.dart';

/// {@template coffee_repository}
/// A repository that handles coffee related requests.
/// {@endtemplate}
class CoffeeRepository {
  /// {@macro coffee_repository}
  CoffeeRepository({CoffeeApi? coffeeApi})
      : _coffeeApi = coffeeApi ?? CoffeeApi();

  final CoffeeApi _coffeeApi;

  ///Method for repository to request random coffee from the API.
  Future<Coffee> getRandomCoffee() async {
    final coffeeData = await _coffeeApi.getCoffeeData();
    return Coffee(uid: coffeeData.uid, imageData: coffeeData.imageData);
  }
}
