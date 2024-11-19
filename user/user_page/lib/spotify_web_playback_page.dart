import 'package:flutter/material.dart';

class SpotifyWebPlaybackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('스포티파이 Web Playback SDK 로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 안내 문구
            Text(
              '스포티파이 Web Playback SDK 로그인 방법',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Web Playback SDK를 사용하면 웹에서 음악을 스트리밍하고 제어할 수 있습니다.\n'
              '스포티파이 API와 함께 사용하는 방법은 아래와 같습니다:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            // 로그인 절차 안내
            Text(
              '1. 스포티파이 Developer 계정 생성 후, 앱 등록.\n'
              '2. Web Playback SDK 라이브러리 로드.\n'
              '3. 사용자 인증 및 액세스 토큰 발급.\n'
              '4. SDK 초기화 후 음악 제어.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // 실제 구현 시, 여기에 Web Playback SDK로의 연결을 처리하는 코드가 들어갑니다.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Web Playback SDK 로그인 방법 안내')),
                );
              },
              child: const Text('Web Playback SDK 연결'),
            ),
          ],
        ),
      ),
    );
  }
}
