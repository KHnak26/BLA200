import 'package:blabla/model/ride_pref/ride_pref.dart';

abstract class RidePreferenceRepository {
  int get maxAllowedSeats;

  RidePreference? get selectedPreference;

  List<RidePreference> get preferenceHistory;

  void selectPreference(RidePreference preference);
}