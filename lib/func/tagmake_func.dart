import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TagmakeFunc {
  final Completer<GoogleMapController> _controller = Completer();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  RangeValues ageRange = const RangeValues(20, 50);
  Gender selectedGender = Gender.N;
  LatLng? selectedLocation;
  late LocationData? currentLocation;
  int? selectedRecruitCount;
  List<int> recruitCount = [1, 2, 3, 4, 5];

  // define a radius for the blue circle
  static const double radius = 500.0;

  Circle get circle => Circle(
        circleId: const CircleId('myCircle'),
        center: selectedLocation ?? const LatLng(0, 0),
        radius: radius,
        fillColor: Colors.blue.withOpacity(0.1),
        strokeColor: Colors.blue,
        strokeWidth: 2,
        visible: true,
        zIndex: 1,
      );

  Future<void> getCurrentLocation() async {
    var location = Location();
    var locationData = await location.getLocation();

    currentLocation = locationData;
    selectedLocation = LatLng(locationData.latitude!, locationData.longitude!);
  }

  void updateCircle() {
    if (selectedLocation == null) {
      return;
    }

    // update the circle by setting the selectedLocation property
    // this will trigger the circle getter to create a new Circle object
    selectedLocation = selectedLocation;
  }

  void onMarkerDragEnd(LatLng position) {
    selectedLocation = position;
    updateCircle();
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
  }

  TagmakeFunc() {
    getCurrentLocation();
  }
}

enum Gender {
  M,
  W,
  N,
}
