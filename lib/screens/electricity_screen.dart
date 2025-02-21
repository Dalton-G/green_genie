import 'package:flutter/material.dart';
import 'package:green_genie/config/theme.dart';

class ElectricityScreen extends StatefulWidget {
  const ElectricityScreen({super.key});

  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Electricity Emissions"),
        backgroundColor: primaryYellow,
      ),
    );
  }
}
