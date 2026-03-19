import 'package:blabla/data/repositories/app_repositories.dart';
import 'package:blabla/model/ride/locations.dart';
import 'package:blabla/ui/theme/theme.dart';
import 'package:blabla/ui/widgets/display/bla_divider.dart';
import 'package:flutter/material.dart';

class BlaLocationPicker extends StatefulWidget {
  const BlaLocationPicker({
    super.key,
    required this.initLocation,
    required this.appRepositories,
  });

  final Location? initLocation;
  final AppRepositories appRepositories;

  @override
  State<BlaLocationPicker> createState() => _BlaLocationPickerState();
}

class _BlaLocationPickerState extends State<BlaLocationPicker> {
  String searchText = "";

  void onTap(Location location) {
    Navigator.pop<Location>(context, location);
  }

  void onBackTap() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    if (widget.initLocation != null) {
      searchText = widget.initLocation!.name;
    }
  }

  void onSearchChanged(String search) {
    setState(() {
      searchText = search;
    });
  }

  List<Location> get filteredLocation {
    if (searchText.length < 2) {
      return [];
    }
    final query = searchText.toLowerCase();

    return widget.appRepositories.locationRepository.availableLocations
        .where(
          (location) => location.name.toLowerCase().contains(query),
        )
        .toList();
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
            LocationSearchBar(
              initSearch: searchText,
              onBackTap: onBackTap,
              onSearchChanged: onSearchChanged,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: filteredLocation.length,
                itemBuilder: (context, index) => LocationTile(
                  location: filteredLocation[index],
                  onTap: onTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationSearchBar extends StatefulWidget {
  const LocationSearchBar({
    super.key,
    required this.onBackTap,
    required this.onSearchChanged,
    required this.initSearch,
  });

  final String initSearch;
  final VoidCallback onBackTap;
  final ValueChanged<String> onSearchChanged;

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  void onClearTap() {
    setState(() {
      _searchController.clear();
      widget.onSearchChanged('');
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initSearch;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get searchIsNotEmpty => _searchController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: BlaColors.greyLight,
      ),
      child: Row(
        children: [
          // BACK ICON
          IconButton(
            onPressed: widget.onBackTap,
            icon: Icon(
              Icons.arrow_back_ios,
              color: BlaColors.iconLight,
              size: 16,
            ),
          ),

          // TEXT FILED
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              style: TextStyle(color: BlaColors.textLight),
              decoration: InputDecoration(
                hintText: "Any city, street...",
                border: InputBorder.none, // No border
                filled: false, // No background fill
              ),
            ),
          ),

          // CLOSE ICON
          searchIsNotEmpty
              ? IconButton(
                  onPressed: onClearTap,
                  icon: Icon(Icons.close, color: BlaColors.iconLight, size: 16),
                )
              : const SizedBox.shrink(), // Hides the icon if text field is empty
        ],
      ),
    );
  }
}

class LocationTile extends StatelessWidget {
  const LocationTile({super.key, required this.location, required this.onTap});

  final Location location;

  final ValueChanged<Location> onTap;

  String get title => location.name;

  String get subTitle => location.country.name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => onTap(location),
          leading: Icon(Icons.history, color: BlaColors.iconLight),

          title: Text(title, style: BlaTextStyles.body),
          subtitle: Text(
            subTitle,
            style: BlaTextStyles.label.copyWith(color: BlaColors.textLight),
          ),

          trailing: Icon(
            Icons.arrow_forward_ios,
            color: BlaColors.iconLight,
            size: 16,
          ),
        ),
        const BlaDivider(),
      ],
    );
  }
}
