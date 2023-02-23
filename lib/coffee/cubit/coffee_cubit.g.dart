// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coffee_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoffeeState _$CoffeeStateFromJson(Map<String, dynamic> json) => $checkedCreate(
      'CoffeeState',
      json,
      ($checkedConvert) {
        final val = CoffeeState(
          status: $checkedConvert(
            'status',
            (v) =>
                $enumDecodeNullable(_$CoffeeStatusEnumMap, v) ??
                CoffeeStatus.initial,
          ),
          savedCoffees: $checkedConvert(
            'saved_coffees',
            (v) => (v as List<dynamic>?)
                ?.map((e) => Coffee.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          selectedCoffee: $checkedConvert(
            'selected_coffee',
            (v) =>
                v == null ? null : Coffee.fromJson(v as Map<String, dynamic>),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'savedCoffees': 'saved_coffees',
        'selectedCoffee': 'selected_coffee'
      },
    );

Map<String, dynamic> _$CoffeeStateToJson(CoffeeState instance) =>
    <String, dynamic>{
      'status': _$CoffeeStatusEnumMap[instance.status],
      'saved_coffees': instance.savedCoffees.map((e) => e.toJson()).toList(),
      'selected_coffee': instance.selectedCoffee.toJson(),
    };

const _$CoffeeStatusEnumMap = {
  CoffeeStatus.initial: 'initial',
  CoffeeStatus.loading: 'loading',
  CoffeeStatus.success: 'success',
  CoffeeStatus.failure: 'failure',
};
