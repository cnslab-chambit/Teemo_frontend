import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:teemo_front/func/map_func.dart';
import 'package:teemo_front/screens/tagmake.dart';
import 'package:http/http.dart' as http;

//전역변수
late GoogleMapController mapController;
late LatLng _center;
LatLng markerPosition = const LatLng(37.6207, 127.0570);
final List<Marker> _tag = [];
bool showTagPage = false;
bool showNavigatePage = false;
Set<Circle> circles = {};
Set<Polyline> polylines = {};
late MarkerId selectedTag;

late int id;

class MyApp extends StatelessWidget {
  final String memberId; // memberId 매개변수 추가

  const MyApp({Key? key, required this.memberId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(memberId: memberId), // memberId 값을 전달
    );
  }
}

class MapScreen extends StatefulWidget {
  final String memberId;
  const MapScreen({Key? key, required this.memberId}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    //실제 통신시 아래 주석 해제
    print("1");
    loadtagList();
    print("3");
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

  //태그 로드
  void loadtagList() async {
    print("2");
    var url = Uri.parse('http://13.124.37.24:8080/');

    // var requestBody = {
    //   'memberId': 2,
    //   'latitude': _center.latitude,
    //   'longitude': _center.longitude,
    // };

    var response = await http.get(url);

    //로드한 태그는 _tag에 저장
    if (response.statusCode == 200) {
      print("반환성공반환성공반환성공반환성공반환성공반환성공반환성공반환성공반환성공반환성공");
      // final tagList = json.decode(response.body);
      // setState(() {
      //   print("good");
      // }
      //     // () {
      //     //   for (final tag in tagList) {
      //     //     final String tagId = tag['tagid'];
      //     //     final double longitude = tag['longitude'];
      //     //     final double latitude = tag['latitude'];
      //     //     _tag.add(tag(tagId, longitude, latitude));
      //     //   }
      //     // },
      //     );
    } else {
      print("반환실패");
      throw Exception('Failed to load tag list');
    }
  }

  //서버에서 읽어온 마커리스트를 토대로 마커세트 생성
  Set<Marker> createMarkers(List<Marker> taglist) {
    Set<Marker> markers = {};

    for (Marker tag in taglist) {
      Marker marker = Marker(
        markerId: tag.markerId,
        position: tag.position,
        onTap: () {
          setState(() {
            showTagPage = true;
            selectedTag = tag.markerId;
          });
        },
      );
      markers.add(marker);
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              zoom: 15.0,
            ),
            myLocationEnabled: true, // 현재 위치 표시
            myLocationButtonEnabled: true, // 현재 위치 버튼 표시
            mapToolbarEnabled: false,
            markers: createMarkers(_tag),
            circles: circles,
            //polylines: polylines,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: showNavigatePage ? MediaQuery.of(context).size.height : 0,
            curve: Curves.easeOut,
            child: showNavigatePage
                ? navigatePage(_setShowTagePage, _setShowNavigatePage)
                : null,
          ),
          /*AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: showTagPage ? MediaQuery.of(context).size.height : 0,
            curve: Curves.easeOut,
            child: showTagPage
                ? tagPage(_setShowTagePage, _setShowNavigatePage, selectedTag)
                : null,
          ),*/
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: showTagPage ? MediaQuery.of(context).size.height : 0,
            curve: Curves.easeOut,
            child: showTagPage
                ? FutureBuilder<DraggableScrollableSheet>(
                    future: tagPage(
                        _setShowTagePage, _setShowNavigatePage, selectedTag),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  )
                : null,
          ),
          if (!showNavigatePage && !showTagPage)
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
                    //생성페이지로 이동, 멤버 id도 함께 넘겨줘야함
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreatetagPage(memberId: widget.memberId),
                      ),
                    );
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
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
