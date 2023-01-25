
import 'package:json_annotation/json_annotation.dart';

part 'coffee.g.dart';

///Data model for API endpoint response of the Coffee API
@JsonSerializable()
class Coffee {
  ///New instance of coffee
  const Coffee({required this.file});

  ///Construct new coffee instance from JSON
  factory Coffee.fromJson(Map<String, dynamic> json) =>
      _$CoffeeFromJson(json);

  ///String representing the url where the coffee image is stored online.
  final String file;
}