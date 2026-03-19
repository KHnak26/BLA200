import 'package:blabla/data/repositories/app_repositories.dart';
import 'package:blabla/model/ride/locations.dart';
import 'package:blabla/model/ride_pref/ride_pref.dart';
import 'package:blabla/ui/theme/theme.dart';
import 'package:blabla/ui/widgets/buttons/bla_button.dart';
import 'package:blabla/ui/widgets/buttons/bla_icon_button.dart';
import 'package:blabla/ui/widgets/display/bla_divider.dart';
import 'package:blabla/ui/widgets/pickers/location/bla_location_picker.dart';
import 'package:blabla/ui/widgets/pickers/seat/bla_seat_picker.dart';
import 'package:blabla/utils/animations_util.dart';
import 'package:blabla/utils/date_time_utils.dart';
import 'package:flutter/material.dart';

class BlaRidePreferencePicker extends StatefulWidget {
  final RidePreference? initRidePreference;

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

  Future<Location?> _pickLocation(Location? initialLocation) {
    return Navigator.of(context).push<Location>(
      AnimationUtils.createBottomToTopRoute(
        BlaLocationPicker(
          initLocation: initialLocation,
          appRepositories: widget.appRepositories,
        ),
      ),
    );
  }

  void onDeparturePressed() async {
    Location? selectedLocation = await _pickLocation(departure);

    if (selectedLocation != null) {
      setState(() {
        departure = selectedLocation;
      });
    }
  }

  void onArrivalPressed() async {
    Location? selectedLocation = await _pickLocation(arrival);

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

  void onSearch() {
    if (departure == null || arrival == null) return;

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

  String get departureLabel =>
      departure != null ? departure!.name : "Leaving from";
  String get arrivalLabel => arrival != null ? arrival!.name : "Going to";

  bool get showDeparturePlaceholder => departure == null;
  bool get showArrivalPlaceholder => arrival == null;

  String get dateLabel => DateTimeUtils.formatDateTime(departureDate);
  String get numberLabel => "$requestedSeats";

  bool get switchVisible => arrival != null || departure != null;

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
                isPlaceholder: showDeparturePlaceholder,
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
                isPlaceholder: showArrivalPlaceholder,
                title: arrivalLabel,
                leftIcon: Icons.location_on,
                onPressed: onArrivalPressed,
              ),
              const BlaDivider(),

              RidePrefInput(
                title: dateLabel,
                leftIcon: Icons.calendar_month,
                onPressed: null,
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
  final VoidCallback? onPressed;
  final IconData leftIcon;

  final bool isPlaceholder;

  final IconData? rightIcon;
  final VoidCallback? onRightIconPressed;

  const RidePrefInput({
    super.key,
    required this.title,
    this.onPressed,
    required this.leftIcon,
    this.rightIcon,
    this.onRightIconPressed,
    this.isPlaceholder = false,
  });

  Color get textColor =>
      isPlaceholder ? BlaColors.textLight : BlaColors.textNormal;

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
