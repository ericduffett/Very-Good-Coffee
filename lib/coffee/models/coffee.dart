
import 'dart:typed_data';

import 'package:coffee_repository/coffee_repository.dart' hide Coffee;
import 'package:coffee_repository/coffee_repository.dart' as coffee_repository;
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coffee.g.dart';

@JsonSerializable()
class Coffee extends Equatable {
  const Coffee({
    required this.uid,
    required List<int> imageData,
  }) : _imageData = imageData;

  factory Coffee.fromJson(Map<String, dynamic> json) =>
    _$CoffeeFromJson(json);

  factory Coffee.fromRepository(coffee_repository.Coffee coffee) {
    return Coffee(
      uid: coffee.uid,
      imageData: coffee.imageData,
    );
  }

  static const empty = Coffee(
    uid: 'empty',
    imageData: [0],
  );


  final String uid;

  ///Stores image data as JSONSerializable List<int>
  final List<int> _imageData;

  ///Getter that converts List<int> to [Uint8List] that can be used with
  ///Image.memory widget in Flutter
  Uint8List get imageData => Uint8List.fromList(_imageData);

  Coffee copyWith({
    String? uid,
    List<int>? imageData,
  }) {
    return Coffee(
      uid: uid ?? this.uid,
      imageData: imageData ?? _imageData,
    );
  }

  @override
  List<Object?> get props => [uid, _imageData];

  Map<String, dynamic> toJSon() => _$CoffeeToJson(this);

}