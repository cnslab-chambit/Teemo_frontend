import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatRoomListScreen(),
    );
  }
}

class ChatRoomListScreen extends StatefulWidget {
  const ChatRoomListScreen({super.key});

  @override
  _ChatRoomListScreenState createState() => _ChatRoomListScreenState();
}

class _ChatRoomListScreenState extends State<ChatRoomListScreen> {
  List<ChatRoom> _chatRooms = [];

  @override
  void initState() {
    super.initState();
    _fetchChatRooms();
  }

  Future<void> _fetchChatRooms() async {
    try {
      // HTTP GET 요청을 보내서 채팅방 목록을 가져옴
      final response = await http.get(Uri.parse('URI'));

      if (response.statusCode == 200) {
        // JSON 데이터를 파싱하여 ChatRoom 모델로 변환 후 _chatRooms 리스트에 저장
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _chatRooms = data.map((json) => ChatRoom.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to fetch chat rooms');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Rooms'),
      ),
      body: ListView.builder(
        // ListView의 아이템 수는 _chatRooms 리스트의 길이와 같음
        itemCount: _chatRooms.length,
        itemBuilder: (context, index) {
          // 현재 인덱스에 해당하는 ChatRoom 객체를 가져옴
          final chatRoom = _chatRooms[index];
          // ListTile을 사용하여 채팅방 목록을 보여줌
          return ListTile(
            title: Text(chatRoom.title),
            subtitle: Text('ID: ${chatRoom.id}'),
            onTap: () {
              //채팅방으로 이동하는 코드
            },
          );
        },
      ),
    );
  }
}

class ChatRoom {
  final int id;
  final String title;

  ChatRoom({required this.id, required this.title});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      title: json['title'],
    );
  }
}
