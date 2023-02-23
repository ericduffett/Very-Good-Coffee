// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coffee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coffee _$CoffeeFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Coffee',
      json,
      ($checkedConvert) {
        final val = Coffee(
          uid: $checkedConvert('uid', (v) => v as String),
          imageData: $checkedConvert('image_data',
              (v) => (v as List<dynamic>).map((e) => e as int).toList(),),
          isLiked: $checkedConvert('is_liked', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {'imageData': 'image_data', 'isLiked': 'is_liked'},
    );

Map<String, dynamic> _$CoffeeToJson(Coffee instance) => <String, dynamic>{
      'uid': instance.uid,
      'is_liked': instance.isLiked,
      'image_data': instance.imageData,
    };
