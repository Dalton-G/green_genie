import 'package:green_genie/data/electricity/country_type.dart';
import 'package:green_genie/data/electricity/electricity_unit.dart';
import 'package:green_genie/model/request/electricity_request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'electricity_request_provider.g.dart';

@riverpod
class ElectricityRequestState extends _$ElectricityRequestState {
  @override
  ElectricityRequest build() {
    return ElectricityRequest(
      countryName: Country.my,
      electricityValue: 0,
      electricityUnit: ElectricityUnit.kwh,
    );
  }

  void updateCountryName(Country country) {
    state = state.copyWith(countryName: country);
  }

  void updateElectricityValue(double value) {
    state = state.copyWith(electricityValue: value);
  }

  void updateElectricityUnit(ElectricityUnit unit) {
    state = state.copyWith(electricityUnit: unit);
  }
}
