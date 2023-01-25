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
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
        );
        return val;
      },
      fieldKeyMap: const {'imageData': 'image_data'},
    );

Map<String, dynamic> _$CoffeeToJson(Coffee instance) => <String, dynamic>{
      'uid': instance.uid,
      'image_data': instance._imageData,
    };
