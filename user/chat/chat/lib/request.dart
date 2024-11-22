import 'package:flutter/material.dart';
import 'main.dart';
import 'chatroom.dart'
    as chatroom; // chatroom.dart에서의 Image는 chatroom.Image로 구분

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RequestPage(),
    );
  }
}

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  // 유저 목록을 리스트로 관리
  List<UserRequest> users = [
    UserRequest(
      profileImage: 'https://via.placeholder.com/150',
      nickname: 'User1',
      albumCover: 'https://via.placeholder.com/300x300',
      artistName: 'Artist1',
      songTitle: 'Song1',
    ),
    UserRequest(
      profileImage: 'https://via.placeholder.com/150',
      nickname: 'User2',
      albumCover: 'https://via.placeholder.com/300x300',
      artistName: 'Artist2',
      songTitle: 'Song2',
    ),
    UserRequest(
      profileImage: 'https://via.placeholder.com/150',
      nickname: 'User3',
      albumCover: 'https://via.placeholder.com/300x300',
      artistName: 'Artist3',
      songTitle: 'Song3',
    ),
    UserRequest(
      profileImage: 'https://via.placeholder.com/150',
      nickname: 'User4',
      albumCover: 'https://via.placeholder.com/300x300',
      artistName: 'Artist4',
      songTitle: 'Song4',
    ),
    UserRequest(
      profileImage: 'https://via.placeholder.com/150',
      nickname: 'User5',
      albumCover: 'https://via.placeholder.com/300x300',
      artistName: 'Artist5',
      songTitle: 'Song5',
    ),
  ];

  // 유저를 삭제하는 함수
  void _removeUser(int index) {
    setState(() {
      users.removeAt(index); // 리스트에서 해당 유저를 제거
    });
  }

  // Accept 버튼 클릭 시 ChatRoomPage로 이동
  void _goToChatRoomPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => chatroom.ChatRoomPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 뒤로 가기 버튼 누르면 ChatListPage로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatListPage()),
            );
          },
        ),
        title: Text('Request'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              UserRequestWidget(
                profileImage: users[index].profileImage,
                nickname: users[index].nickname,
                albumCover: users[index].albumCover,
                artistName: users[index].artistName,
                songTitle: users[index].songTitle,
                onReject: () => _removeUser(index), // Reject 클릭 시 유저 삭제
                onAccept: () =>
                    _goToChatRoomPage(context), // Accept 클릭 시 ChatRoomPage로 이동
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}

class UserRequest {
  final String profileImage;
  final String nickname;
  final String albumCover;
  final String artistName;
  final String songTitle;

  UserRequest({
    required this.profileImage,
    required this.nickname,
    required this.albumCover,
    required this.artistName,
    required this.songTitle,
  });
}

class UserRequestWidget extends StatelessWidget {
  final String profileImage;
  final String nickname;
  final String albumCover;
  final String artistName;
  final String songTitle;
  final VoidCallback onReject;
  final VoidCallback onAccept;

  const UserRequestWidget({
    super.key,
    required this.profileImage,
    required this.nickname,
    required this.albumCover,
    required this.artistName,
    required this.songTitle,
    required this.onReject,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(profileImage),
          ),
          SizedBox(width: 10),
          Text(nickname),
          SizedBox(width: 20),
          // Playlist 버튼 제거
          Spacer(),
          ElevatedButton(
            onPressed: onAccept, // Accept 버튼 클릭 시 ChatRoomPage로 이동
            child: Text('Accept'),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: onReject, // Reject 버튼 클릭 시 유저 삭제
            child: Text('Reject'),
          ),
        ],
      ),
    );
  }
}
