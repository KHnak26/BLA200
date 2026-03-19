import 'package:blabla/data/repositories/ride_preference/ride_preference_repository.dart';
import 'package:blabla/model/ride_pref/ride_pref.dart';

class RidePreferenceRepositoryMock implements RidePreferenceRepository {
  RidePreference? _selectedPreference;
  final List<RidePreference> _preferenceHistory = <RidePreference>[];

  @override
  int get maxAllowedSeats => 8;

  @override
  RidePreference? get selectedPreference => _selectedPreference;

  @override
  List<RidePreference> get preferenceHistory => _preferenceHistory;

  @override
  void selectPreference(RidePreference preference) {
    if (preference == _selectedPreference) {
      return;
    }

    _selectedPreference = preference;
    _preferenceHistory.add(preference);
  }
}