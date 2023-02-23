import 'dart:convert';
import 'dart:typed_data';
import 'package:coffee_api/src/models/coffee.dart';
import 'package:coffee_api/src/models/coffee_data.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

/// {@template coffee_api}
/// The Interface and models for an API providing access to coffee images.
/// {@endtemplate}
class CoffeeApi {
  /// {@macro coffee_api}
  CoffeeApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  ///Requests a random coffee url from coffee.alexflipnote.dev.
  ///Note: This is simply a url for a random coffee image, not the image itself.
  ///The actual image data is returned by the getCoffeeImageAsData() method.
  Future<Coffee> _generateRandomCoffee() async {
    final url = Uri.https(
      'coffee.alexflipnote.dev',
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

  ///Exposes a public method that returns an instance of coffee data that
  ///contains the image data as [Uint8List] and a uid [String]
  Future<CoffeeData> getCoffeeData() async {
    final coffee = await _generateRandomCoffee();
    final data = await getCoffeeImageAsData(coffee);
    final uid = extractUID(coffee.file);
    return CoffeeData(uid: uid, imageData: data);
  }

  ///Given a url [String] extract the uid provided by the
  ///coffee.alexflipnote.dev API
  @visibleForTesting
  String extractUID(String url) {
    ///If url doesn't match expected pattern, return the entire url as the uid.
    if (!url.contains('https://coffee.alexflipnote.dev/') ||
        !url.contains('_coffee')) {
      return url;
    }
    final dropMainURL = url.replaceAll('https://coffee.alexflipnote.dev/', '');
    final cleanUID = dropMainURL.substring(0, dropMainURL.indexOf('_coffee'));
    return cleanUID;
  }

  ///Given an instance of coffee, returns image data as bytes.
  @visibleForTesting
  Future<Uint8List> getCoffeeImageAsData(Coffee coffee) async {
    final coffeeImageRequest = await _httpClient.get(coffee.url);
    if (coffeeImageRequest.statusCode != 200) {
      throw CoffeeRequestFailure();
    }

    return coffeeImageRequest.bodyBytes;
  }
}

///Exception thrown when there is a network error.
class CoffeeRequestFailure implements Exception {}

///Exception thrown if the JSON from the API doesn't match naming conventions
class CoffeeNotFoundFailure implements Exception {}
