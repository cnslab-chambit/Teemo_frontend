import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:teemo_front/func/map_func.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  LatLng _center = const LatLng(0, 0);
  LatLng markerPosition = const LatLng(37.6207, 127.0570);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    final Location location = Location();

    try {
      final currentLocation = await location.getLocation();
      setState(() {
        _center = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    } catch (e) {
      print(e);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMarkerDragEnd(LatLng position) {
    setState(() {
      markerPosition = position;
    });
    print(markerPosition.latitude);
    print(markerPosition.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 5.0,
            ),
            myLocationEnabled: true, // 현재 위치 표시
            myLocationButtonEnabled: true,
            markers: <Marker>{
              Tag('한울관', 37.6207, 127.0572),
              Marker(
                markerId: const MarkerId('marker_1'),
                position: markerPosition,
                draggable: true,
                onDragEnd: _onMarkerDragEnd,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue,
                ),
              )
            }, // 현재 위치 버튼 표시
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  physics: const ClampingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ).applyTo(const ClampingScrollPhysics()),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      border: Border.all(
                        color: const Color.fromARGB(255, 160, 160, 160),
                        width: 1,
                      )),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      SizedBox(
                        height: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildIconRow(Icons.person, '유저정보', 40),
                      const SizedBox(height: 30),
                      const Row(
                        children: [Text('태그설명')],
                      ),
                      const SizedBox(height: 30),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      buildRow('모집 인원', 15),
                      buildRow('나이 조건', 15),
                      buildRow('성별 조건', 15),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * 0.6, 50),
                        ),
                        child: const Text(
                          '목적지로 설정',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
