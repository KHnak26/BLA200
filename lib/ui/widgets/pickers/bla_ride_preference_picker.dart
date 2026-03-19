import 'package:blabla/ui/widgets/buttons/bla_button.dart';
import 'package:blabla/ui/widgets/display/bla_divider.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/app_repositories.dart';
import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../../../utils/animations_util.dart';
import '../../../utils/date_time_utils.dart';
import '../../theme/theme.dart';
import '../buttons/bla_icon_button.dart';
import 'bla_location_picker.dart';
import 'bla_seat_picker.dart';

///
/// A  RidePreference Picker is a view to pick a RidePreference:
///   - A depcarture location
///   - An arrival location
///   - A date
///   - A number of seats
///
class BlaRidePreferencePicker extends StatefulWidget {
  final RidePreference? initRidePreference; // optional initial preference.

  const BlaRidePreferencePicker({
    super.key,
    this.initRidePreference,
    required this.appRepositories,
    required this.onRidePreferenceSelected,
  });

  final ValueChanged<RidePreference> onRidePreferenceSelected;
  final AppRepositories appRepositories;

  @override
  State<BlaRidePreferencePicker> createState() =>
      _BlaRidePreferencePickerState();
}

class _BlaRidePreferencePickerState extends State<BlaRidePreferencePicker> {
  Location? departure;
  late DateTime departureDate;
  Location? arrival;
  late int requestedSeats;

  // ----------------------------------
  // Initialize the Form attributes
  // ----------------------------------
  @override
  void initState() {
    super.initState();
    _initForm();
  }

  @override
  void didUpdateWidget(covariant BlaRidePreferencePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initRidePreference != widget.initRidePreference) {
      _initForm();
    }
  }

  void _initForm() {
    if (widget.initRidePreference != null) {
      departure = widget.initRidePreference!.departure;
      arrival = widget.initRidePreference!.arrival;
      departureDate = widget.initRidePreference!.departureDate;
      requestedSeats = widget.initRidePreference!.requestedSeats;
    } else {
      departure = null;
      departureDate = DateTime.now();
      arrival = null;
      requestedSeats = 1;
    }
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------

  void onDeparturePressed() async {
    Location? selectedLocation = await Navigator.of(context).push<Location>(
      AnimationUtils.createBottomToTopRoute(
        BlaLocationPicker(
          initLocation: departure,
          locations: widget.appRepositories.locationRepository.availableLocations,
        ),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        departure = selectedLocation;
      });
    }
  }

  void onArrivalPressed() async {
    Location? selectedLocation = await Navigator.of(context).push<Location>(
      AnimationUtils.createBottomToTopRoute(
        BlaLocationPicker(
          initLocation: arrival,
          locations: widget.appRepositories.locationRepository.availableLocations,
        ),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        arrival = selectedLocation;
      });
    }
  }

  void onSeatNumberPressed() async {
    int? selectedSeatNumber = await Navigator.of(context).push<int>(
      AnimationUtils.createRightToLeftRoute(
        BlaSeatPicker(
          initSeats: requestedSeats,
          maxSeat: widget
              .appRepositories
              .ridePreferenceRepository
              .maxAllowedSeats,
        ),
      ),
    );

    if (selectedSeatNumber != null && selectedSeatNumber != requestedSeats) {
      setState(() {
        requestedSeats = selectedSeatNumber;
      });
    }
  }

  void onSearch() async {
    bool hasDeparture = departure != null;
    bool hasArrival = arrival != null;

    bool preferenceIsValid = hasArrival && hasDeparture;
    if (!preferenceIsValid) return;

    RidePreference newPreference = RidePreference(
      departure: departure!,
      departureDate: departureDate,
      arrival: arrival!,
      requestedSeats: requestedSeats,
    );

    widget.onRidePreferenceSelected(newPreference);
  }

  void onSwappingLocationPressed() {
    setState(() {
      if (departure != null || arrival != null) {
        Location? temp = departure;
        departure = arrival != null ? Location.copy(arrival!) : null;
        arrival = temp != null ? Location.copy(temp) : null;
      }
    });
  }

  // ----------------------------------
  // Compute the widgets rendering
  // ----------------------------------
  String get departureLabel =>
      departure != null ? departure!.name : "Leaving from";
  String get arrivalLabel => arrival != null ? arrival!.name : "Going to";

  bool get showDeparturePlaceholder => departure == null;
  bool get showArrivalPlaceholder => arrival == null;

  String get dateLabel => DateTimeUtils.formatDateTime(departureDate);
  String get numberLabel => "$requestedSeats";

  bool get switchVisible => arrival != null || departure != null;

  // ----------------------------------
  // Build the widgets
  // ----------------------------------
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: BlaSpacings.m),
          child: Column(
            children: [
              RidePrefInput(
                isPlaceHolder: showDeparturePlaceholder,
                title: departureLabel,
                leftIcon: Icons.location_on,
                onPressed: onDeparturePressed,
                rightIcon: switchVisible ? Icons.swap_vert : null,
                onRightIconPressed: switchVisible
                    ? onSwappingLocationPressed
                    : null,
              ),
              const BlaDivider(),

              RidePrefInput(
                isPlaceHolder: showArrivalPlaceholder,
                title: arrivalLabel,
                leftIcon: Icons.location_on,
                onPressed: onArrivalPressed,
              ),
              const BlaDivider(),

              RidePrefInput(
                title: dateLabel,
                leftIcon: Icons.calendar_month,
                onPressed: () => {},
              ),
              const BlaDivider(),

              RidePrefInput(
                title: numberLabel,
                leftIcon: Icons.person_2_outlined,
                onPressed: onSeatNumberPressed,
              ),
            ],
          ),
        ),

        BlaButton(text: 'Search', onPressed: onSearch),
      ],
    );
  }
}

class RidePrefInput extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData leftIcon;

  // If true the text is displayed ligher
  final bool isPlaceHolder;

  // A right button can be optionally provided
  final IconData? rightIcon;
  final VoidCallback? onRightIconPressed;

  const RidePrefInput({
    super.key,
    required this.title,
    required this.onPressed,
    required this.leftIcon,
    this.rightIcon, //   optional
    this.onRightIconPressed, //   optional
    this.isPlaceHolder = false,
  });

  Color get textColor =>
      isPlaceHolder ? BlaColors.textLight : BlaColors.textNormal;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      title: Text(
        title,
        style: BlaTextStyles.button.copyWith(fontSize: 14, color: textColor),
      ),
      leading: Icon(leftIcon, size: BlaSize.icon, color: BlaColors.iconLight),
      trailing: rightIcon != null
          ? BlaIconButton(icon: rightIcon, onPressed: onRightIconPressed)
          : null,
    );
  }
}
