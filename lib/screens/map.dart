import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:teemo_front/func/map_func.dart';
import 'package:http/http.dart' as http;

//전역변수
late GoogleMapController mapController;
late LatLng _center;
LatLng markerPosition = const LatLng(37.6207, 127.0570);
final List<Marker> _tag = [];
bool showTagPage = false;
bool showNavigatePage = false;
Set<Circle> circles = {};

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
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    //실제 통신시 아래 주석
    //_loadtagList();
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

  void _setShowTagePage(bool value) {
    setState(() {
      showTagPage = value;
    });
  }

  void _setShowNavigatePage(bool value) {
    setState(() {
      showNavigatePage = value;
    });
  }

  void _loadtagList() async {
    const String url = 'URL'; //링크 설정
    final response = await http.get(Uri.parse(url)); //링크 조회

    if (response.statusCode == 200) {
      final tagList = json.decode(response.body);
      setState(() {
        for (final tag in tagList) {
          final String tagId = tag['markerid'];
          final double longitude = tag['longitude'];
          final double latitude = tag['latitude'];
          _tag.add(tag(tagId, longitude, latitude));
        }
      });
    } else {
      throw Exception('Failed to load tag list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            onTap: (LatLng location) {
              setState(() {
                showTagPage = false;
                circles.clear();
              });
            },
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 5.0,
            ),
            myLocationEnabled: true, // 현재 위치 표시
            myLocationButtonEnabled: true, // 현재 위치 버튼 표시
            mapToolbarEnabled: false,
            markers: <Marker>{
              tag('한울관', 37.6207, 127.0572, _setShowTagePage, circles)
            },
            circles: circles,
          ),
          if (showNavigatePage)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: showNavigatePage ? MediaQuery.of(context).size.height : 0,
              curve: Curves.easeOut,
              child: showNavigatePage ? navigatePage() : null,
            )
          else if (showTagPage)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: showTagPage ? MediaQuery.of(context).size.height : 0,
              curve: Curves.easeOut,
              child: showTagPage
                  ? tagPage(_setShowTagePage, _setShowNavigatePage)
                  : null,
            )
          else
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                margin: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      //생성페이지로 이동
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.circle, color: Colors.white),
                        const Text(
                          '  사람 모집하기',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 60.0),
                          child: const Text(
                            '태그 생성 ▶',
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    )),
              ),
            ),
        ],
      ),
    );
  }
}
