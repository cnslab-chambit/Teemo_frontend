import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // //태그 로드
  void loadtagList() async {
    var url = Uri.parse('http://13.124.37.24:8080');
    // var url = Uri.parse('http://13.124.37.24:8080/api/tags/search');

    var requestBody = {
      'memberId': "2",
      'latitude': "37.62",
      'longitude': "127.06",
    };

    var response = await http.get(url.replace(queryParameters: requestBody));

    //로드한 태그는 _tag에 저장
    // if (response.statusCode == 200) {
    // print("통신 됨");
    // final tagList = jsonDecode(response.body);
    // for (var tag in tagList) {
    //   print(tag['tagid']);
    //   print(tag['longitude']);
    //   print(tag['latitude']);
    // }

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
    // } else {
    //   print("반환실패");
    //   // throw Exception('Failed to load tag list');
    // }
  }

  @override
  void initState() {
    super.initState();
    print("시작");
    loadtagList();
    print("탈출");
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Text("asdfasdfdasfdasfdasdfsadf"));
  }
}
