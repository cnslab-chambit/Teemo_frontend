import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:teemo_front/func/tagmake_func.dart';

//태그 포멧입니다.
class Tagformat {
  String memberId;
  String title;
  String detail;
  int maxNum;
  RangeValues ageRange = const RangeValues(20, 50);
  Gender targetGender;
  LatLng location;

  Tagformat({
    required this.memberId,
    required this.title,
    required this.detail,
    required this.maxNum,
    required this.ageRange,
    required this.targetGender,
    required this.location,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      'memberId': memberId,
      'title': title,
      'detail': detail,
      'maxNum': maxNum,
      'targetGender': targetGender.toString().split('.').last,
      'upperAge': ageRange.end.toInt(),
      'lowerAge': ageRange.start.toInt(),
      'latitude': location.latitude,
      'longitude': location.longitude,
    };
  }
}

class CreatetagPage extends StatefulWidget {
  final String memberId;
  const CreatetagPage({Key? key, required this.memberId}) : super(key: key);

  @override
  CreatetagPageState createState() => CreatetagPageState();
}

class CreatetagPageState extends State<CreatetagPage> {
  final TagmakeFunc tagmakeFunc = TagmakeFunc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tagmakeFunc.getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('태그생성'),
      ),
      body: Stack(
        children: [
          Expanded(
            //위치 선택
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.24,
              child: GoogleMap(
                onMapCreated: (controller) =>
                    tagmakeFunc.onMapCreated(controller),
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    tagmakeFunc.currentLocation!.latitude!,
                    tagmakeFunc.currentLocation!.longitude!,
                  ),
                  zoom: 15,
                ),
                onTap: (LatLng location) {
                  setState(() {
                    //지도 클릭시 seletecLoacation 좌표 변경
                    tagmakeFunc.onMarkerDragEnd(location);
                  });
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: tagmakeFunc.selectedLocation == null
                    ? {}
                    : {
                        Marker(
                          markerId: const MarkerId('selected-location'),
                          position: tagmakeFunc.selectedLocation!,
                        )
                      },
                circles: tagmakeFunc.currentLocation == null
                    ? {}
                    : {
                        Circle(
                          circleId: const CircleId('current-location'),
                          center: LatLng(
                            tagmakeFunc.currentLocation!.latitude!,
                            tagmakeFunc.currentLocation!.longitude!,
                          ),
                          radius: 500,
                          fillColor: tagmakeFunc.circle.fillColor,
                          strokeColor: tagmakeFunc.circle.strokeColor,
                          strokeWidth: tagmakeFunc.circle.strokeWidth,
                        ),
                      },
              ),
            ),
          ),
        ],
      ),
      //위치 선정 이외의 입력칸
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 30),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //제목입력
            TextFormField(
              controller: tagmakeFunc.titleController,
              decoration: const InputDecoration(labelText: '제목'),
            ),
            //설명입력
            TextFormField(
              controller: tagmakeFunc.descriptionController,
              decoration: const InputDecoration(labelText: '설명'),
            ),
            const SizedBox(height: 24),
            //나이대 설정
            Row(
              children: [
                const Text(
                  '나이대',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Text('${tagmakeFunc.ageRange.start.toInt()}세 ~ '),
                Text('${tagmakeFunc.ageRange.end.toInt()}세')
              ],
            ),
            const SizedBox(height: 12),
            //나이대 설정 슬라이더
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.blue,
                inactiveTrackColor: Colors.grey[200],
                trackHeight: 2,
                thumbColor: const Color.fromARGB(255, 255, 255, 255),
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 12,
                  elevation: 4,
                  pressedElevation: 8,
                ),
                overlayColor: Colors.blue.withOpacity(0.2),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 28),
                tickMarkShape: const RoundSliderTickMarkShape(),
                showValueIndicator: ShowValueIndicator.never,
              ),
              //텍스트 표시
              child: Column(
                children: [
                  RangeSlider(
                    values: tagmakeFunc.ageRange,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    labels: RangeLabels(
                      '${tagmakeFunc.ageRange.start.toInt()}대',
                      '${tagmakeFunc.ageRange.end.toInt()}대',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        tagmakeFunc.ageRange = values;
                      });
                    },
                  ),
                ],
              ),
            ),
            //성별설정
            Column(
              children: [
                Row(
                  children: [
                    const Text(
                      '성별',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 30),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              tagmakeFunc.selectedGender = Gender.M;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                tagmakeFunc.selectedGender == Gender.M
                                    ? Colors.blue
                                    : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: const BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: Text(
                            '남자',
                            style: TextStyle(
                              color: tagmakeFunc.selectedGender == Gender.M
                                  ? Colors.white
                                  : Colors.blue,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              tagmakeFunc.selectedGender = Gender.W;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                tagmakeFunc.selectedGender == Gender.W
                                    ? Colors.blue
                                    : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: const BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: Text(
                            '여자',
                            style: TextStyle(
                              color: tagmakeFunc.selectedGender == Gender.W
                                  ? Colors.white
                                  : Colors.blue,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              tagmakeFunc.selectedGender = Gender.N;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                tagmakeFunc.selectedGender == Gender.N
                                    ? Colors.blue
                                    : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: const BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: Text(
                            '상관없음',
                            style: TextStyle(
                              color: tagmakeFunc.selectedGender == Gender.N
                                  ? Colors.white
                                  : Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //인원수 설정
                Row(
                  children: [
                    const Text('모집인원수',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      width: 10,
                    ),
                    //인원수 설정 버튼
                    DropdownButton<int>(
                      value: tagmakeFunc.selectedRecruitCount,
                      onChanged: (int? newValue) {
                        setState(() {
                          tagmakeFunc.selectedRecruitCount = newValue;
                        });
                      },
                      items: tagmakeFunc.recruitCount
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      // 빈칸 체크
                      if (tagmakeFunc.selectedLocation != null &&
                          tagmakeFunc.titleController.text.isNotEmpty &&
                          tagmakeFunc.descriptionController.text.isNotEmpty &&
                          tagmakeFunc.selectedRecruitCount != null) {
                        // 업로드용 태그 생성
                        Tagformat newTag = Tagformat(
                          memberId: widget.memberId,
                          title: tagmakeFunc.titleController.text,
                          detail: tagmakeFunc.descriptionController.text,
                          maxNum: tagmakeFunc.selectedRecruitCount!,
                          ageRange: RangeValues(
                            tagmakeFunc.ageRange.start,
                            tagmakeFunc.ageRange.end,
                          ),
                          location: tagmakeFunc.selectedLocation!,
                          targetGender: tagmakeFunc.selectedGender,
                        );

                        // 서버 전송
                        try {
                          final response = await http.post(
                            Uri.parse('URL'), // 업로드할 URL 입력
                            headers: {
                              'Content-Type': 'application/json',
                            },
                            body: newTag.toJson(), // 태그를 JSON 형식으로 변환하여 전송
                          );

                          if (response.statusCode == 200) {
                            // 업로드 성공
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('태그가 성공적으로 업로드되었습니다.'),
                              ),
                            );
                            // 맵으로 나감
                            Navigator.pop(context, newTag);
                          } else {
                            // 업로드 실패
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('태그 업로드에 실패했습니다.'),
                              ),
                            );
                          }
                        } catch (e) {
                          // 오류 발생
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('서버와의 연결에 오류가 발생했습니다.'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('빈칸이 존재합니다.'),
                          ),
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('생성',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
