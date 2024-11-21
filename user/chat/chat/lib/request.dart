import 'package:flutter/material.dart';
import 'main.dart'; // ChatListPage가 포함된 main.dart를 import

class RequestChatPage extends StatelessWidget {
  const RequestChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Chat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // ChatListPage로 이동
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChatListPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Request',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // 프로필 이미지와 닉네임, 플레이리스트 앨범 이미지
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      NetworkImage('https://www.example.com/profile.jpg'),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User 1', // 닉네임
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        showSongListPopup(context); // 앨범 클릭 시 팝업
                      },
                      child: Image.network(
                        'https://www.example.com/album.jpg', // 플레이리스트 앨범 이미지
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Accept 버튼 클릭 시 처리
                      },
                      child: const Text('Accept'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Reject 버튼 클릭 시 처리
                      },
                      child: const Text('Reject'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // 다른 유저 요청
            const Text(
              'Other Requests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // 다른 요청들 나열 (여러 유저가 있다고 가정)
            const RequestItemWidget(),
            const Divider(),
            const RequestItemWidget(),
            const Divider(),
            const RequestItemWidget(),
          ],
        ),
      ),
    );
  }

  // 노래 리스트 팝업
  void showSongListPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          builder: (BuildContext context, scrollController) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: GestureDetector(
                onPanUpdate: (details) {
                  // 드래그로 팝업을 움직일 수 있게 처리
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop(); // 팝업 닫기
                          },
                        ),
                      ),
                      const Text(
                        'Song List',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // 노래 목록 예시
                      const Text('Song 1'),
                      const Text('Song 2'),
                      const Text('Song 3'),
                      const Text('Song 4'),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class RequestItemWidget extends StatelessWidget {
  const RequestItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://www.example.com/profile.jpg'),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User 2',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text('Request message or info'),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            // Accept 버튼 클릭 시 처리
          },
          child: const Text('Accept'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            // Reject 버튼 클릭 시 처리
          },
          child: const Text('Reject'),
        ),
      ],
    );
  }
}
