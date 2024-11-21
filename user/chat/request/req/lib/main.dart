import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RequestScreen(),
    );
  }
}

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
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

  // Reject 버튼을 클릭하면 해당 유저를 삭제하는 함수
  void _removeUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기
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
                onReject: () => _removeUser(index), // Reject 버튼 클릭 시 유저 삭제
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

  UserRequestWidget({
    required this.profileImage,
    required this.nickname,
    required this.albumCover,
    required this.artistName,
    required this.songTitle,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(profileImage), // 임시 이미지 URL
          ),
          SizedBox(width: 10),
          Text(nickname),
          SizedBox(width: 20),
          // 플레이리스트 버튼 추가
          ElevatedButton(
            onPressed: () => _showPlaylistPopup(context),
            child: Text('Playlist'),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {},
            child: Text('Accept'),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: onReject, // Reject 버튼 클릭 시 onReject 호출
            child: Text('Reject'),
          ),
        ],
      ),
    );
  }

  // 팝업을 표시하는 함수
  void _showPlaylistPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(1), // 배경을 완전히 불투명하게 설정
      builder: (BuildContext context) {
        return PlaylistPopup(
          artistName: artistName,
          songTitle: songTitle,
          albumCover: albumCover,
        );
      },
    );
  }
}

class PlaylistPopup extends StatelessWidget {
  final String artistName;
  final String songTitle;
  final String albumCover;

  PlaylistPopup({
    required this.artistName,
    required this.songTitle,
    required this.albumCover,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding:
          EdgeInsets.symmetric(horizontal: 200, vertical: 15), // 팝업 크기 조정
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // 모서리 둥글게
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15), // 모서리 둥글게
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$artistName - $songTitle',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // 팝업 닫기
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Image.network(
                  albumCover,
                  width: 120, // 앨범 커버 크기
                  height: 120, // 앨범 커버 크기
                ),
                SizedBox(height: 20),
                Text(
                  'Artist: $artistName',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Song: $songTitle',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
