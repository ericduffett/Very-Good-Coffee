import 'dart:convert';
import 'dart:typed_data';

import 'package:coffee_api/src/models/coffee.dart';

import 'package:http/http.dart' as http;

/// {@template coffee_api}
/// The Interface and models for an API providing access to coffee images.
/// {@endtemplate}
class CoffeeApi {
  /// {@macro coffee_api}
  CoffeeApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();


  final http.Client _httpClient;

  ///Requests a random coffee url from coffee.alexflipnote.dev.
  Future<Coffee> _generateRandomCoffee() async {
    final url = Uri.https(
        'https://coffee.alexflipnote.dev',
        '/random.json',
    );
    final coffeeRequest = await _httpClient.get(url);

    if (coffeeRequest.statusCode != 200) {
      throw CoffeeRequestFailure();
    }

    final coffeeJson = jsonDecode(coffeeRequest.body) as Map;

    if (!coffeeJson.containsKey('file')) throw CoffeeNotFoundFailure();

    return Coffee.fromJson(coffeeJson as Map<String, dynamic>);

  }

  ///Given an instance of coffee, returns image data as bytes.
  Future<Uint8List> getCoffee(Coffee coffee) async {
    final randomCoffee = await _generateRandomCoffee();
    final uri = Uri.https(randomCoffee.file);
    final coffeeImageRequest = await http.get(uri);

    if (coffeeImageRequest.statusCode != 200) {
      throw CoffeeRequestFailure();
    }

    return coffeeImageRequest.bodyBytes;
  }

}

///Exception thrown when getCoffee Fails
class CoffeeRequestFailure implements Exception {}

///Exception thrown if the JSON from the API doesn't match naming conventions
class CoffeeNotFoundFailure implements Exception {}
