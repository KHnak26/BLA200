// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:blabla/data/repositories/app_repositories.dart';
import 'package:blabla/data/repositories/location/location_repository_mock.dart';
import 'package:blabla/data/repositories/ride/ride_repository_mock.dart';
import 'package:blabla/data/repositories/ride_preference/ride_preference_repository_mock.dart';
import 'package:blabla/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App shows home heading', (WidgetTester tester) async {
    final appRepositories = AppRepositories(
      locationRepository: LocationRepositoryMock(),
      rideRepository: RideRepositoryMock(),
      ridePreferenceRepository: RidePreferenceRepositoryMock(),
    );

    await tester.pumpWidget(BlaBlaApp(appRepositories: appRepositories));

    expect(find.text('Your pick of rides at low price'), findsOneWidget);
  });
}
