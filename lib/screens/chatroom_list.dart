import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chat.dart';
import 'map.dart';

class ChatRoomList extends StatefulWidget {
  const ChatRoomList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatRoomListState createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  List<ChatRoom> _chatRooms = [];

  @override
  void initState() {
    super.initState();

    /**
     * api 통신할 때 , 아래 주석 해제하면 됩니다.
     */
    //_fetchChatRooms();
    _temDataFetchChatRooms();
  }

  _temDataFetchChatRooms() {
    _chatRooms.add(ChatRoom(id: 1, title: "test1"));
    _chatRooms.add(ChatRoom(id: 2, title: "test2"));
    _chatRooms.add(ChatRoom(id: 3, title: "test3"));
    _chatRooms.add(ChatRoom(id: 4, title: "test4"));
    _chatRooms.add(ChatRoom(id: 5, title: "test5"));
  }

  Future<void> _fetchChatRooms() async {
    try {
      // HTTP GET 요청을 보내서 채팅방 목록을 가져옴
      final response =
          await http.get(Uri.parse('http://localhost:8080/api/chatRooms'));

      if (response.statusCode == 200) {
        // JSON 데이터를 파싱하여 ChatRoom 모델로 변환 후 _chatRooms 리스트에 저장
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MapScreen(),
              ),
            );
          },
        ),
        title: const Text('Chat Rooms'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          // ListView의 아이템 수는 _chatRooms 리스트의 길이와 같음
          itemCount: _chatRooms.length,
          itemBuilder: (context, index) {
            // 현재 인덱스에 해당하는 ChatRoom 객체를 가져옴
            final chatRoom = _chatRooms[index];
            return ListTile(
              title: Text(chatRoom.title),
              subtitle: Text('ID: ${chatRoom.id}'),
              //채팅방으로 이동하는 코드
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(arg: chatRoom.id),
                  ),
                );
              },
            );
          },
        ),
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
