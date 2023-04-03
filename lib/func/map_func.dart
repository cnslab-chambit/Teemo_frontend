import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
export 'package:teemo_front/func/map_func.dart';

List<Widget> buildButtons(int numPeople, BuildContext context) {
  List<Widget> buttons = [];
  for (int i = 1; i <= numPeople; i++) {
    buttons.add(
      const SizedBox(
        height: 10,
      ),
    );
    buttons.add(
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fixedSize: Size(MediaQuery.of(context).size.width * 0.6, 50),
        ),
        child: const Text(
          'User Name',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  return buttons;
}

Widget buildIconRow(IconData icon, String text, double Size) {
  return Row(
    children: [
      Icon(icon, size: Size),
      const SizedBox(width: 10),
      Text(text, style: TextStyle(fontSize: Size)),
    ],
  );
}

Widget buildRow(String text, double Size) {
  return Row(
    children: [
      const SizedBox(width: 10),
      Text(text, style: TextStyle(fontSize: Size)),
    ],
  );
}

Marker Tag(String name, double longitude, double latitude) {
  return Marker(
    markerId: MarkerId(name),
    position: LatLng(longitude, latitude),
  );
}
