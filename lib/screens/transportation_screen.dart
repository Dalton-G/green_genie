import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_genie/config/theme.dart';
import 'package:green_genie/data/transportation/distance_unit.dart';
import 'package:green_genie/data/transportation/fuel_type.dart';
import 'package:green_genie/data/transportation/vehicle_type.dart';
import 'package:green_genie/providers/request/transportation/transportation_request_provider.dart';
import 'package:green_genie/providers/response/transportation/transportation_response_provider.dart';
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
  late TextEditingController distanceValueController;

  @override
  void initState() {
    super.initState();
    distanceValueController = TextEditingController(text: "0");
  }

  @override
  void dispose() {
    distanceValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final transportationRequestState =
        ref.watch(transportationRequestStateProvider);
    final transportationRequestNotifier =
        ref.read(transportationRequestStateProvider.notifier);
    final transportationResponseState =
        ref.watch(transportationResponseProvider);
    final transportationResponseNotifier =
        ref.read(transportationResponseProvider.notifier);

    return Scaffold(
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
                  transportationResponseState.when(
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
                          height: height,
                          labelText: "Distance Traveled",
                          textController: distanceValueController,
                          onChanged: (value) {
                            transportationRequestNotifier.updateDistanceValue(
                              double.parse(value),
                            );
                          }),
                      customDropdown(
                        labelText: "Distance Unit",
                        items: DistanceUnit.values,
                        value: transportationRequestState.distanceUnit,
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
                    value: transportationRequestState.vehicleType,
                    onChanged: (value) => transportationRequestNotifier
                        .updateVehicleType(value as VehicleType),
                    width: width,
                    height: height,
                  ),
                  customDropdown(
                    labelText: "Fuel Type",
                    items: FuelType.values,
                    value: transportationRequestState.fuelType,
                    onChanged: (value) => transportationRequestNotifier
                        .updateFuelType(value as FuelType),
                    width: width,
                    height: height,
                  ),
                  calculateButton(
                    width: width,
                    height: height,
                    btnColor: secondaryBlue,
                    onTap: () => transportationResponseNotifier
                        .calculateTransportationEmission(
                            transportationRequestState),
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
