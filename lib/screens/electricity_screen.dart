import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_genie/config/theme.dart';
import 'package:green_genie/data/electricity/country_type.dart';
import 'package:green_genie/data/electricity/electricity_unit.dart';
import 'package:green_genie/providers/request/electricity/electricity_request_provider.dart';
import 'package:green_genie/providers/response/electricity/electricity_response_provider.dart';
import 'package:green_genie/widgets/calculate_button.dart';
import 'package:green_genie/widgets/custom_dropdown.dart';
import 'package:green_genie/widgets/emission_card.dart';
import 'package:green_genie/widgets/emission_card_skeleton.dart';
import 'package:green_genie/widgets/expanded_text_field.dart';

class ElectricityScreen extends ConsumerStatefulWidget {
  const ElectricityScreen({super.key});

  @override
  ConsumerState<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends ConsumerState<ElectricityScreen> {
  late TextEditingController electricityValueController;

  @override
  void initState() {
    electricityValueController = TextEditingController(text: "0");
    super.initState();
  }

  @override
  void dispose() {
    electricityValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final electricityRequestState = ref.watch(electricityRequestStateProvider);
    final electricityRequestNotifier =
        ref.read(electricityRequestStateProvider.notifier);
    final electricityResponseState = ref.watch(electricityResponseProvider);
    final electricityResponseNotifier =
        ref.read(electricityResponseProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text("Electricity Emissions"),
        backgroundColor: primaryYellow,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: height * 0.5 - kToolbarHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  electricityResponseState.when(
                    data: (response) => emissionCard(
                      height: height,
                      width: width,
                      co2eGm: response?.co2eGm ?? 0,
                      co2eKg: response?.co2eKg ?? 0,
                      co2eLb: response?.co2eLb ?? 0,
                      co2eMt: response?.co2eMt ?? 0,
                      icon: Icons.bolt,
                      iconColor: secondaryYellow,
                    ),
                    error: (errorText, stackTrace) => Text(
                      "Error: ${errorText.toString()}",
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
                        labelText: "Electricity Value",
                        textController: electricityValueController,
                        onChanged: (value) {
                          electricityRequestNotifier.updateElectricityValue(
                            double.parse(value),
                          );
                        },
                      ),
                      customDropdown(
                        labelText: "Electricity Unit",
                        items: ElectricityUnit.values,
                        value: electricityRequestState.electricityUnit,
                        onChanged: (value) => electricityRequestNotifier
                            .updateElectricityUnit(value as ElectricityUnit),
                        width: width,
                        height: height,
                      ),
                    ],
                  ),
                  customDropdown(
                    labelText: "Country Name",
                    items: Country.values,
                    value: electricityRequestState.countryName,
                    onChanged: (value) => electricityRequestNotifier
                        .updateCountryName(value as Country),
                    width: width,
                    height: height,
                  ),
                  calculateButton(
                    width: width,
                    height: height,
                    btnColor: secondaryYellow,
                    onTap: () => electricityResponseNotifier
                        .calculateElectricityEmission(electricityRequestState),
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
