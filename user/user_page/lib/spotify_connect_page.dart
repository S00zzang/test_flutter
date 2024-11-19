import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences 사용

class SpotifyConnectPage extends StatelessWidget {
  final String nickname;

  const SpotifyConnectPage({super.key, required this.nickname});

  // 연동 완료 후 SharedPreferences에 상태 저장
  void _linkSpotify(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSpotifyLinked', true); // 연동 상태 저장

    // 연동 후 메시지와 함께 다음 화면으로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('스포티파이 연동 완료!')),
    );
  }

  // 연동 안 하기로 선택 시 SharedPreferences에 상태 저장
  void _skipSpotify(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSpotifySkipped', true); // 연동 안 함 상태 저장

    // 넘어가기 버튼 클릭 시 연동 안 함 상태를 저장하고, 홈 화면 등으로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('스포티파이를 연동하지 않기로 선택하셨습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('스포티파이 연동')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '안녕하세요. $nickname 님!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/spotify_logo.png', // 스포티파이 로고 이미지 (이미지 파일을 프로젝트에 추가해야 합니다)
              height: 100,
            ),
            const SizedBox(height: 40),
            Text(
              '스포티파이와 연결하시겠어요?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // 연동하기 버튼 클릭 시 연동 완료 처리
                _linkSpotify(context);
              },
              child: const Text('연동하기'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // 넘어가기 버튼을 클릭하면 연동 안 함 상태를 저장하고, 홈 화면 등으로 이동
                _skipSpotify(context);
              },
              child: const Text('넘어가기'),
            ),
          ],
        ),
      ),
    );
  }
}
