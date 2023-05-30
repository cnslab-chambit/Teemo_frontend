import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:ffi';

import 'chatroom_list.dart';

///테스트용 내 닉네임
String testMyName = "me";

///테스트용 상대 닉네임
String testyourName = "you";

class Message {
  final String content;
  final String sender;

  Message({required this.content, required this.sender});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required int arg}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = []; // 채팅 내용을 담는 리스트

  final TextEditingController _messageController =
      TextEditingController(); // 메시지 입력을 받는 컨트롤러

  late Long RoomId;

  @override
  void initState() {
    super.initState();

    /**
     * api 통신할 때 , 아래 주석 해제하면 됩니다.
     */
    // _loadChatHistory();

    _temLoadChatHistory();
  }

  _temLoadChatHistory() {
    _messages.add(Message(content: "진짜 10연승 찍을때까지 집 못가요?", sender: testMyName));
    _messages.add(Message(content: "네", sender: testyourName));
  }

  void _loadChatHistory() async {
    final Long roomId =
        ModalRoute.of(context)!.settings.arguments as Long; //roomId 설정
    final String url = 'URL/$roomId/chat'; //URL셋팅

    final response = await http.get(Uri.parse(url)); //링크 조회

    if (response.statusCode == 200) {
      final chatHistory = json.decode(response.body);
      setState(() {
        for (final message in chatHistory) {
          //리스트를 읽어와 메세지 리스트에 추가
          _messages.add(Message(
            content: message['content'] as String,
            sender: message['sender'] as String,
          ));
        }
      });
    } else {
      throw Exception('Failed to load chat history');
    }
  }

  //메세지를 서버에 업로드
  void _postMessage() async {
    final Long roomId = ModalRoute.of(context)!.settings.arguments as Long;
    final String url = 'URL/$roomId/chat';

    //message를 post
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(_messages
          .map((m) => {
                'sender': m.sender,
                'content': m.content,
              })
          .toList()),
    );

    //post 실패했을 경우
    if (response.statusCode != 201) {
      throw Exception('Failed to post message: ${response.statusCode}');
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
                builder: (context) => const ChatRoomList(),
              ),
            );
          },
        ),
        title: const Text('심심한 사람'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                '상대방 프로필 or 내 프로필?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text('내 위치 전송'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('내 위치 전송'),
                      content: const Text('상대방에게 현재 내 위치를 전송하겠습니까?'),
                      actions: [
                        TextButton(
                          child: const Text('취소'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('전송'),
                          onPressed: () {
                            // 전송 구현
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('채팅방 나가기'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('채팅방 나가기'),
                      content: const Text('정말로 채팅방을 나가시겠습니까?'),
                      actions: [
                        TextButton(
                          child: const Text('취소'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('나가기'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('채팅방을 퇴장했습니다')),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = _messages[_messages.length - 1 - index];
                return ChatMessage(
                  content: message.content,
                  sender: message.sender,
                );
              },
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: '메시지 입력',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    setState(
                      () {
                        _messages.add(
                          Message(
                            content: _messageController.text,
                            sender: testMyName,
                          ),
                        );
                        //_postMessage(); // 메세지 전송
                        _messageController.clear();
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    Key? key,
    required this.content,
    required this.sender,
  }) : super(key: key);

  final String content;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (sender != testMyName) // 상대 메시지인 경우에만 프로필 이미지 추가
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: const CircleAvatar(child: Text('상대')),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: testMyName == sender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  testMyName == sender ? '나' : '상대방',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  decoration: BoxDecoration(
                    color: testMyName == sender
                        ? Colors.blueAccent
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16.0,
                  ),
                  child: Text(
                    content,
                    style: TextStyle(
                      color: testMyName == sender ? Colors.white : Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (testMyName == sender) // 내 메시지인 경우에만 프로필 이미지 추가
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: const CircleAvatar(child: Text('나')),
            ),
        ],
      ),
    );
  }
}

// ChatMessage 위젯에서는 메시지 내용과 해당 메시지가 내 메시지인지 상대방 메시지인지를 전달받아 UI를 생성함
// _ChatScreenState 클래스에서는 채팅창의 전체 UI를 생성함
// 이 클래스에서는 _messages 리스트와 _messageController 변수를 선언하여 채팅 내용과 입력된 메시지를 관리함
// build() 메서드에서는 Scaffold 위젯을 반환하며, AppBar와 채팅 내용을 표시하는 리스트, 메시지 입력창을 담은 Row 위젯을 생성함
// ListView.builder() 위젯을 사용하여 _messages 리스트에 저장된 채팅 내용을 역순으로 출력함
// TextField() 위젯과 IconButton() 위젯을 사용하여 메시지를 입력하고 전송할 수 있음
