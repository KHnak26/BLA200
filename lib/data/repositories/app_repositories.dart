import 'package:blabla/data/repositories/location/location_repository.dart';
import 'package:blabla/data/repositories/ride/ride_repository.dart';
import 'package:blabla/data/repositories/ride_preference/ride_preference_repository.dart';

class AppRepositories {
  final LocationRepository locationRepository;
  final RideRepository rideRepository;
  final RidePreferenceRepository ridePreferenceRepository;

  const AppRepositories({
    required this.locationRepository,
    required this.rideRepository,
    required this.ridePreferenceRepository,
  });
}