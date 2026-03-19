
import 'package:flutter/material.dart';
import 'data/repositories/app_repositories.dart';
import 'data/repositories/location/location_repository_mock.dart';
import 'data/repositories/ride/ride_repository_mock.dart';
import 'data/repositories/ride_preference/ride_preference_repository_mock.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/theme/theme.dart';

void main() {
  final appRepositories = AppRepositories(
    locationRepository: LocationRepositoryMock(),
    rideRepository: RideRepositoryMock(),
    ridePreferenceRepository: RidePreferenceRepositoryMock(),
  );

  runApp(BlaBlaApp(appRepositories: appRepositories));
}

class BlaBlaApp extends StatelessWidget {
  const BlaBlaApp({super.key, required this.appRepositories});

  final AppRepositories appRepositories;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: blaTheme,
      home: Scaffold(body: HomeScreen(appRepositories: appRepositories)),
    );
  }
}
