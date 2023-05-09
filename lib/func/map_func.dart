import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:teemo_front/screens/chatroom_list.dart';
import 'package:teemo_front/screens/map.dart';
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
                  polylines.add(
                    const Polyline(
                      polylineId: PolylineId('test'),
                      color: Colors.red,
                      width: 5,
                      points: [
                        LatLng(37.6207, 127.0572),
                        LatLng(37.6195, 127.0599),
                      ],
                    ),
                  );
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

DraggableScrollableSheet navigatePage(
    Function(bool) setShowTagePage, Function(bool) setShowNavigatePage) {
  return DraggableScrollableSheet(
    initialChildSize: 0.5,
    minChildSize: 0.2,
    maxChildSize: 0.5,
    builder: (BuildContext context, ScrollController scrollController) {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        //controller: scrollController, //이거 해제하면 위아래 스크롤 가능해짐
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
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
          child: PageView(
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
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
                  const Icon(Icons.arrow_upward, size: 100),
                  const SizedBox(height: 125),
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
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.6, 50),
                    ),
                    child: const Text(
                      '채팅하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 15,
                        color: Color.fromARGB(255, 58, 58, 58),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.circle,
                        size: 15,
                        color: Color.fromARGB(255, 221, 221, 221),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      const Text(
                        "* 주의 사항 및 이용가이드",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "- 현재 이동 중인 목적지는 Tag의 최초 생성 위치입니다.\n( *호스트의 실제 위치가 아닙니다.)\n\n"
                        "- 목적지 기준, 반경 500m 이내로 접근 시, 호스트와의 1대1 채팅방이 개설됩니다. (단, 호스트 기준, 채팅인원은 10명으로 제한되어 있습니다. 그 외의 인원은 연결이 불가하여, ‘채팅하기’ 요청을 다시 시도하여 주십시오.) \n\n"
                        "- 아래 ‘취소하기’ 버튼을 누르면 설정된 목적지를 해제합니다. 호스트와 채팅 중이라면 채팅이 중단되며, 채팅내용은 저장되지 않습니다.",
                        style: TextStyle(fontSize: 11),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          polylines.remove(const PolylineId('test'));
                          setShowTagePage(true);
                          setShowNavigatePage(false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * 0.6, 50),
                        ),
                        child: const Text(
                          '취소하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 15,
                            color: Color.fromARGB(255, 221, 221, 221),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.circle,
                            size: 15,
                            color: Color.fromARGB(255, 58, 58, 58),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
