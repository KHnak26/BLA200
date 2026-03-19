import 'package:flutter/material.dart';
import '../../../data/repositories/app_repositories.dart';
import '../../../model/ride/ride.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../../../utils/animations_util.dart' show AnimationUtils;
import '../../theme/theme.dart';
import '../../widgets/pickers/location/bla_ride_preference_modal.dart';
import 'widgets/rides_selection_header.dart';
import 'widgets/rides_selection_tile.dart';

///
///  The Ride Selection screen allows user to select a ride, once ride preferences have been defined.
///  The screen also allow user to:
///   -  re-define the ride preferences
///   -  activate some filters.
///
class RidesSelectionScreen extends StatefulWidget {
  const RidesSelectionScreen({super.key, required this.appRepositories});

  final AppRepositories appRepositories;

  @override
  State<RidesSelectionScreen> createState() => _RidesSelectionScreenState();
}

class _RidesSelectionScreenState extends State<RidesSelectionScreen> {
  void onBackTap() {
    Navigator.pop(context);
  }

  RidePreference get selectedRidePreference =>
      widget
          .appRepositories
          .ridePreferenceRepository
          .selectedPreference!;

  List<Ride> get matchingRides =>
      widget.appRepositories.rideRepository.getRidesFor(selectedRidePreference);

  void onPreferencePressed() async {
    RidePreference? newPreference = await Navigator.of(context).push<RidePreference>(
          AnimationUtils.createRightToLeftRoute(
            RidePreferenceModal(
              initialPreference: selectedRidePreference,
              appRepositories: widget.appRepositories,
            ),
          ),
        );

    if (newPreference != null) {
      widget.appRepositories.ridePreferenceRepository.selectPreference(
        newPreference,
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            RideSelectionHeader(
              ridePreference: selectedRidePreference,
              onBackPressed: onBackTap,
              onFilterPressed: () {},
              onPreferencePressed: onPreferencePressed,
            ),

            const SizedBox(height: 100),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) => RideSelectionTile(
                  ride: matchingRides[index],
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
