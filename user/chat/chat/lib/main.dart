// main.dart

import 'package:flutter/material.dart';
import 'chatroom.dart'; // ChatRoomPage를 불러오기 위해 import
import 'request.dart'; // RequestChatPage를 불러오기 위해 import

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
        '/chat': (context) => const ChatListPage(),
        '/RequestChat': (context) =>
            const RequestChatPage(), // request.dart에 정의된 RequestChatPage를 사용
        '/chatroom': (context) => const ChatRoomPage(), // ChatRoomPage 추가
      },
      home: const ChatListPage(),
    );
  }
}

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Map<String, String>> chatList = List.generate(
    5,
    (index) => {
      'profileImageUrl': 'https://www.example.com/profile.jpg',
      'nickname': 'User $index',
      'lastMessage': '최근 메시지 $index',
      'unreadCount': '${index + 1}', // 미확인 메시지 수
    },
  );

  bool isIconOnly = false;

  void toggleMenu() {
    setState(() {
      isIconOnly = !isIconOnly;
    });
  }

  void deleteChat(int index) {
    setState(() {
      chatList.removeAt(index);
    });
  }

  Future<void> showDeleteConfirmationDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('정말 삭제하시겠습니까?'),
          content: const Text('이 채팅방을 삭제하면 복구할 수 없습니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                deleteChat(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(
            isIconOnly: isIconOnly,
            toggleMenu: toggleMenu,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Chatting',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context,
                              '/RequestChat'); // request.dart에서 정의된 RequestChatPage로 이동
                        },
                        child: const Text('Request Chat'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            if (details.primaryDelta! < -10) {
                              showDeleteConfirmationDialog(index);
                            }
                          },
                          onTap: () {
                            Navigator.pushNamed(context, '/chatroom');
                          },
                          child: ChatBox(
                            profileImageUrl: chatList[index]
                                ['profileImageUrl']!,
                            nickname: chatList[index]['nickname']!,
                            lastMessage: chatList[index]['lastMessage']!,
                            unreadCount:
                                int.parse(chatList[index]['unreadCount']!),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBox extends StatelessWidget {
  final String profileImageUrl;
  final String nickname;
  final String lastMessage;
  final int unreadCount;

  const ChatBox({
    required this.profileImageUrl,
    required this.nickname,
    required this.lastMessage,
    required this.unreadCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(profileImageUrl),
        ),
        title: Text(nickname),
        subtitle: Text(lastMessage),
        trailing: unreadCount > 0
            ? CircleAvatar(
                radius: 12,
                backgroundColor: Colors.red,
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            : null,
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final bool isIconOnly;
  final VoidCallback toggleMenu;

  const NavigationDrawer({
    required this.isIconOnly,
    required this.toggleMenu,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isIconOnly ? 60 : 140,
      color: Colors.blueGrey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: IconButton(
                icon: Icon(isIconOnly ? Icons.menu : Icons.menu),
                onPressed: toggleMenu,
              ),
            ),
          ),
          const SizedBox(height: 30),
          if (!isIconOnly) ...[
            buildMenuItem(
                Icons.account_box_outlined, 'My Page', '/myPage', context),
            const SizedBox(height: 20),
            buildMenuItem(
                Icons.library_music_outlined, 'Playlist', '/playlist', context),
            const SizedBox(height: 20),
            buildMenuItem(Icons.chat_bubble_outline, 'Talk', '/chat', context),
            const SizedBox(height: 20),
            buildMenuItem(
                Icons.family_restroom_outlined, 'Club', '/club', context),
            const SizedBox(height: 20),
            buildMenuItem(Icons.favorite_outlined, 'Like', '/like', context),
          ],
          if (isIconOnly) ...[
            buildMenuItem(Icons.account_box_outlined, '', '/myPage', context),
            const SizedBox(height: 20),
            buildMenuItem(
                Icons.library_music_outlined, '', '/playlist', context),
            const SizedBox(height: 20),
            buildMenuItem(Icons.chat_bubble_outline, '', '/chat', context),
            const SizedBox(height: 20),
            buildMenuItem(Icons.family_restroom_outlined, '', '/club', context),
            const SizedBox(height: 20),
            buildMenuItem(Icons.favorite_outlined, '', '/like', context),
          ]
        ],
      ),
    );
  }

  Widget buildMenuItem(
      IconData icon, String label, String route, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Icon(icon, color: Colors.white),
            ),
            if (!isIconOnly) ...[
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
