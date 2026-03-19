import 'package:blabla/model/ride_pref/ride_pref.dart';
import 'package:blabla/data/repositories/app_repositories.dart';
import 'package:flutter/material.dart';
import '../../../utils/animations_util.dart';
import '../../theme/theme.dart';
import '../../widgets/pickers/ride_preference/bla_ride_preference_picker.dart';
import '../rides_selection/rides_selection_screen.dart';
import 'widgets/home_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.appRepositories});

  final AppRepositories appRepositories;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void onRidePrefSelected(RidePreference selectedPreference) async {
    widget.appRepositories.ridePreferenceRepository.selectPreference(
      selectedPreference,
    );

    await Navigator.of(context).push(
      AnimationUtils.createBottomToTopRoute(
        RidesSelectionScreen(appRepositories: widget.appRepositories),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_buildBackground(), _buildForeground()]);
  }

  Widget _buildForeground() {
    return Column(
      children: [
        SizedBox(height: 16),
        Align(
          alignment: AlignmentGeometry.center,
          child: Text(
            "Your pick of rides at low price",
            style: BlaTextStyles.heading.copyWith(color: Colors.white),
          ),
        ),
        SizedBox(height: 100),

        Container(
          margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
          decoration: BoxDecoration(
            color: Colors.white, // White background
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlaRidePreferencePicker(
                initRidePreference: widget
                    .appRepositories
                    .ridePreferenceRepository
                    .selectedPreference,
                appRepositories: widget.appRepositories,
                onRidePreferenceSelected: onRidePrefSelected,
              ),
              SizedBox(height: BlaSpacings.m),

              _buildHistory(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistory() {
    List<RidePreference> history = widget
        .appRepositories
        .ridePreferenceRepository
        .preferenceHistory
        .reversed
        .toList();
    return SizedBox(
      height: 200,
      child: ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: history.length,
        itemBuilder: (ctx, index) => HomeHistoryTile(
          ridePref: history[index],
          onPressed: () => onRidePrefSelected(history[index]),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
