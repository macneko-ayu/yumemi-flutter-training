// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of '../weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeatherImpl _$$WeatherImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$WeatherImpl',
      json,
      ($checkedConvert) {
        final val = _$WeatherImpl(
          weatherCondition: $checkedConvert('weather_condition',
              (v) => $enumDecode(_$WeatherConditionEnumMap, v)),
          maxTemperature:
              $checkedConvert('max_temperature', (v) => (v as num).toInt()),
          minTemperature:
              $checkedConvert('min_temperature', (v) => (v as num).toInt()),
          date: $checkedConvert(
              'date', (v) => const DateTimeConverter().fromJson(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'weatherCondition': 'weather_condition',
        'maxTemperature': 'max_temperature',
        'minTemperature': 'min_temperature'
      },
    );

Map<String, dynamic> _$$WeatherImplToJson(_$WeatherImpl instance) =>
    <String, dynamic>{
      'weather_condition':
          _$WeatherConditionEnumMap[instance.weatherCondition]!,
      'max_temperature': instance.maxTemperature,
      'min_temperature': instance.minTemperature,
      'date': const DateTimeConverter().toJson(instance.date),
    };

const _$WeatherConditionEnumMap = {
  WeatherCondition.sunny: 'sunny',
  WeatherCondition.cloudy: 'cloudy',
  WeatherCondition.rainy: 'rainy',
};
