import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_genie/providers/bottom_nav_bar/bottom_nav_bar_provider.dart';
import 'package:green_genie/screens/electricity_screen.dart';
import 'package:green_genie/screens/home_screen.dart';
import 'package:green_genie/screens/transportation_screen.dart';
import 'package:green_genie/widgets/bottom_nav_bar.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  final List<Widget> _pages = [
    HomeScreen(),
    TransportationScreen(),
    ElectricityScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavBarIndexProvider);
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: bottomNavigationBar(
        index: ref.watch(bottomNavBarIndexProvider),
        onTap: (int index) =>
            ref.read(bottomNavBarIndexProvider.notifier).updateIndex(index),
      ),
    );
  }
}
