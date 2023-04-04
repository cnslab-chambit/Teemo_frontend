import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:teemo_front/screens/chatroom_list.dart';
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

bool addcircle(Set<Circle> circles, LatLng markerPosition) {
  return circles.add(
    Circle(
      circleId: const CircleId('myCircle'),
      center: markerPosition,
      radius: 500,
      fillColor: Colors.blue.withOpacity(0.2),
      strokeColor: Colors.blue,
      strokeWidth: 2,
    ),
  );
}

Marker tag(String name, double longitude, double latitude,
    Function(bool) setShowTagePage, Set<Circle> circles) {
  return Marker(
    markerId: MarkerId(name),
    position: LatLng(longitude, latitude),
    onTap: () {
      setShowTagePage(true);
      addcircle(circles, LatLng(longitude, latitude));
    },
  );
}

DraggableScrollableSheet tagPage(
    Function(bool) setShowTagePage, Function(bool) setShowNavigatePage) {
  return DraggableScrollableSheet(
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
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 10,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                onPressed: () {
                  setShowTagePage(false);
                  setShowNavigatePage(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.6, 50),
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
  );
}

DraggableScrollableSheet navigatePage() {
  return DraggableScrollableSheet(
    initialChildSize: 0.5,
    minChildSize: 0.5,
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
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 10,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const Text('네비게이터 자리'),
              const SizedBox(height: 200),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatRoomList()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.6, 50),
                ),
                child: const Text(
                  '채팅하기',
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
  );
}
