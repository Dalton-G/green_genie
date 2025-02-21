import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_genie/config/theme.dart';
import 'package:green_genie/data/distance_unit.dart';
import 'package:green_genie/data/fuel_type.dart';
import 'package:green_genie/data/vehicle_type.dart';
import 'package:green_genie/providers/carbonsutra_api_response/carbon_api_response_provider.dart';
import 'package:green_genie/providers/transportation_request/transportation_request_provider.dart';
import 'package:green_genie/widgets/calculate_button.dart';
import 'package:green_genie/widgets/custom_dropdown.dart';
import 'package:green_genie/widgets/emission_card.dart';
import 'package:green_genie/widgets/emission_card_skeleton.dart';
import 'package:green_genie/widgets/expanded_text_field.dart';

class TransportationScreen extends ConsumerStatefulWidget {
  const TransportationScreen({super.key});

  @override
  ConsumerState<TransportationScreen> createState() =>
      _TransportationScreenState();
}

class _TransportationScreenState extends ConsumerState<TransportationScreen> {
  late TextEditingController distanceValue;

  @override
  void initState() {
    super.initState();
    distanceValue = TextEditingController(text: "0");
  }

  @override
  void dispose() {
    distanceValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final transportationRequest = ref.watch(transportationRequestStateProvider);
    final transportationRequestNotifier =
        ref.read(transportationRequestStateProvider.notifier);
    final carbonApi = ref.watch(carbonApiStateProvider);
    final carbonApiNotifier = ref.read(carbonApiStateProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Transportation Emissions"),
        backgroundColor: primaryBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: height * 0.5 - kToolbarHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  carbonApi.when(
                    data: (response) => emissionCard(
                      icon: CupertinoIcons.car,
                      iconColor: secondaryBlue,
                      height: height,
                      width: width,
                      co2eGm: response?.co2eGm ?? 0,
                      co2eKg: response?.co2eKg ?? 0,
                      co2eLb: response?.co2eLb ?? 0,
                      co2eMt: response?.co2eMt ?? 0,
                    ),
                    error: (errorText, stack) => Text(
                      'Error: ${errorText.toString()}',
                      style: normal(color: error),
                    ),
                    loading: () =>
                        emissionCardSkeleton(height: height, width: width),
                  ),
                  Text("Please enter your data:", style: normal(bold: true)),
                  Row(
                    spacing: 16,
                    children: [
                      expandedTextField(
                          width: width,
                          height: height,
                          labelText: "Distance Traveled",
                          textController: distanceValue,
                          onChanged: (value) {
                            transportationRequestNotifier.updateDistanceValue(
                              double.parse(value) ?? 0.0,
                            );
                          }),
                      customDropdown(
                        labelText: "Distance Unit",
                        items: DistanceUnit.values,
                        value: transportationRequest.distanceUnit,
                        onChanged: (value) => transportationRequestNotifier
                            .updateDistanceUnit(value as DistanceUnit),
                        width: width,
                        height: height,
                      )
                    ],
                  ),
                  customDropdown(
                    labelText: "Vehicle Type",
                    items: VehicleType.values,
                    value: transportationRequest.vehicleType,
                    onChanged: (value) => transportationRequestNotifier
                        .updateVehicleType(value as VehicleType),
                    width: width,
                    height: height,
                  ),
                  customDropdown(
                    labelText: "Fuel Type",
                    items: FuelType.values,
                    value: transportationRequest.fuelType,
                    onChanged: (value) => transportationRequestNotifier
                        .updateFuelType(value as FuelType),
                    width: width,
                    height: height,
                  ),
                  calculateButton(
                    width: width,
                    height: height,
                    btnColor: secondaryBlue,
                    onTap: () => carbonApiNotifier
                        .calculateTransportationEmission(transportationRequest),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
