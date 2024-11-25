import 'dart:convert';
import 'main.dart'; // ChatListPage가 main.dart에 있으므로 그대로 사용
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/chatroom': (context) => const ChatRoomPage(),
        '/chatlist': (context) =>
            const ChatListPage(), // ChatListPage로 이동할 수 있는 라우트 추가
      },
      home: const ChatListPage(), // 앱 시작 시 ChatListPage를 기본 화면으로 설정
    );
  }
}

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  bool isMenuOpen = false;
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;
  List<ChatMessage> chatMessages = []; // 채팅 메시지 리스트
  String userNickname = "User123"; // 예시로 사용자 닉네임 설정
  String profileImageUrl =
      "https://www.example.com/profile.jpg"; // 예시 프로필 이미지 URL

  String _getFormattedTime() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    final hour = now.hour;
    final minute = now.minute;
    return '$year년 $month월 $day일 ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  // 메시지를 보내는 함수
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        String currentTime = _getFormattedTime();
        chatMessages.add(
            ChatMessage(message: _messageController.text, time: currentTime));
        _messageController.clear();
        _isTyping = false;
      });
    }
  }

  // 채팅방 나가기
  void _leaveChatRoom() {
    Navigator.pop(context); // ChatListPage로 돌아가기
  }

  // 메시지 입력시 타이핑 상태에 따른 아이콘 변경
  void _onMessageChange(String text) {
    setState(() {
      _isTyping = text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 버튼 클릭 시 ChatListPage로 이동
          },
        ),
        title: Text(userNickname), // 대화 상대의 닉네임
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              setState(() {
                isMenuOpen = !isMenuOpen; // 메뉴 버튼 클릭 시 사이드바 열고 닫기
              });
            },
          ),
        ],
        backgroundColor: Colors.blueGrey[900], // 앱바 배경색을 설정 (예: 어두운 블루그레이)
        foregroundColor: Colors.white, // 앱바의 텍스트와 아이콘 색상 설정
      ),
      body: Row(
        children: [
          // 채팅방 영역
          Expanded(
            child: Column(
              children: [
                // 채팅 메시지 영역
                Expanded(
                  child: ListView.builder(
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      bool isUserMessage =
                          index % 2 == 0; // 임의로 사용자 메시지를 짝수 인덱스에 설정
                      final chatMessage = chatMessages[index];
                      return Align(
                        alignment: isUserMessage
                            ? Alignment.centerRight // 내 메시지는 오른쪽
                            : Alignment.centerLeft, // 상대방 메시지는 왼쪽
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!isUserMessage)
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(profileImageUrl),
                                ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isUserMessage
                                        ? Colors.blue
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chatMessage.message,
                                        style: TextStyle(
                                          color: isUserMessage
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        chatMessage.time,
                                        style: TextStyle(
                                          color: isUserMessage
                                              ? Colors.white
                                              : Colors.black.withOpacity(0.6),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 하단 바 영역
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          onChanged: _onMessageChange,
                          onSubmitted: (_) {
                            _sendMessage(); // 엔터키를 눌러서 메시지 전송
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter your message...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isTyping ? Icons.send : Icons.send,
                          color: _isTyping ? Colors.blue : Colors.grey,
                        ),
                        onPressed: _isTyping ? _sendMessage : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 사이드바 화면을 오른쪽에 표시
          if (isMenuOpen) _buildSideBar(),
        ],
      ),
    );
  }

  // 사이드바 화면
  Widget _buildSideBar() {
    return Container(
      width: 250,
      color: Colors.blueGrey,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Shared Music List',
              style: TextStyle(color: Colors.white),
            ),
          ),
          // 여기에서는 Spotify 관련 API 호출을 제거했습니다.
        ],
      ),
    );
  }
}

// 채팅 메시지 모델 (메시지와 시간을 저장)
class ChatMessage {
  final String message;
  final String time;

  ChatMessage({required this.message, required this.time});
}
