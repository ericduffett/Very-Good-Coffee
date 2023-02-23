import 'dart:typed_data';
import 'package:coffee_repository/coffee_repository.dart' as coffee_repository;
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_coffee/coffee/models/json_map.dart';

part 'coffee.g.dart';

@JsonSerializable()
class Coffee extends Equatable {
  const Coffee({
    required this.uid,
    required List<int> imageData,
    bool? isLiked,
  })  : _imageData = imageData,
        isLiked = isLiked ?? false;

  factory Coffee.fromRepository(coffee_repository.Coffee coffee) {
    return Coffee(
      uid: coffee.uid,
      imageData: coffee.imageData,
    );
  }

  static const empty = Coffee(
    uid: 'empty',
    imageData: [0],
    isLiked: false,
  );

  static const noFavorites = <Coffee>[];

  final String uid;

  ///Stores image data as JSONSerializable List<int>
  final List<int> _imageData;

  ///Stores whether the user has saved this image
  final bool isLiked;

  ///Getter that converts List<int> to [Uint8List] that can be used with
  ///Image.memory widget in Flutter
  Uint8List get imageData => Uint8List.fromList(_imageData);

  Coffee copyWith({
    String? uid,
    List<int>? imageData,
    bool? isLiked,
  }) {
    return Coffee(
      uid: uid ?? this.uid,
      imageData: imageData ?? _imageData,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [uid, _imageData, isLiked];

  /// Deserializes the given [JsonMap] into a [Coffee].
  static Coffee fromJson(JsonMap json) => _$CoffeeFromJson(json);

  /// Converts this [Coffee] into a [JsonMap].
  JsonMap toJson() => _$CoffeeToJson(this);
}
