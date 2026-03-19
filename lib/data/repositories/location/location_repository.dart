import 'package:blabla/model/ride/locations.dart';

abstract class LocationRepository {
  List<Location> get availableLocations;
}