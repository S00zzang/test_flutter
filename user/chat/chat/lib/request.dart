import 'package:flutter/material.dart';
import 'main.dart';
import 'chatroom.dart' as chatroom;

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
      artistName: 'Artist1',
      songTitle: 'Song1',
    ),
    UserRequest(
      profileImage: 'https://via.placeholder.com/150',
      nickname: 'User2',
      artistName: 'Artist2',
      songTitle: 'Song2',
    ),
    UserRequest(
      profileImage: 'https://via.placeholder.com/150',
      nickname: 'User3',
      artistName: 'Artist3',
      songTitle: 'Song3',
    ),
    UserRequest(
      profileImage: 'https://via.placeholder.com/150',
      nickname: 'User4',
      artistName: 'Artist4',
      songTitle: 'Song4',
    ),
    UserRequest(
      profileImage: 'https://via.placeholder.com/150',
      nickname: 'User5',
      artistName: 'Artist5',
      songTitle: 'Song5',
    )
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

  // Playlist 버튼을 눌렀을 때 팝업 띄우기
  void _showPlaylistDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 배경 클릭으로 팝업 닫히지 않도록
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Container(
                height: 400, // 팝업의 높이 설정
                width: 300, // 팝업의 너비 설정
                child: ListView.builder(
                  itemCount: 15, // 15개 항목을 리스트로 보여주기
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Song ${index + 1}', // 동적으로 곡 제목 표시
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Artist ${index + 1}', // 동적으로 가수 이름 표시
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Divider(), // 각 항목 사이에 구분선 추가
                        ],
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context); // 팝업 닫기
                  },
                ),
              ),
            ],
          ),
        );
      },
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
                artistName: users[index].artistName,
                songTitle: users[index].songTitle,
                onReject: () => _removeUser(index), // Reject 클릭 시 유저 삭제
                onAccept: () =>
                    _goToChatRoomPage(context), // Accept 클릭 시 ChatRoomPage로 이동
                onPlaylist: () =>
                    _showPlaylistDialog(context), // Playlist 버튼 클릭 시 팝업
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
  final String artistName;
  final String songTitle;

  UserRequest({
    required this.profileImage,
    required this.nickname,
    required this.artistName,
    required this.songTitle,
  });
}

class UserRequestWidget extends StatelessWidget {
  final String profileImage;
  final String nickname;
  final String artistName;
  final String songTitle;
  final VoidCallback onReject;
  final VoidCallback onAccept;
  final VoidCallback onPlaylist;

  const UserRequestWidget({
    super.key,
    required this.profileImage,
    required this.nickname,
    required this.artistName,
    required this.songTitle,
    required this.onReject,
    required this.onAccept,
    required this.onPlaylist,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(width: 20),
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(profileImage),
          ),
          SizedBox(width: 25),
          Text(
            nickname,
            style: TextStyle(
              fontSize: 15, // 글씨 크기 키우기
              fontWeight: FontWeight.bold, // 볼드체로 설정
            ),
          ),
          SizedBox(width: 50),
          // Playlist 버튼 추가
          Container(
            width: 300, // 버튼 가로 길이 설정
            height: 40, // 버튼 세로 길이 설정
            decoration: BoxDecoration(
              color: Colors.blue, // 배경 색
              borderRadius: BorderRadius.circular(8), // 둥근 모서리
            ),
            child: TextButton(
              onPressed: onPlaylist, // Playlist 버튼 클릭 시 팝업
              child: Text(
                'Playlist', // 버튼 텍스트
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: onAccept, // Accept 버튼 클릭 시 ChatRoomPage로 이동
            child: Text('Accept'),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            onPressed: onReject, // Reject 버튼 클릭 시 유저 삭제
            child: Text('Reject'),
          ),
          SizedBox(width: 20)
        ],
      ),
    );
  }
}
