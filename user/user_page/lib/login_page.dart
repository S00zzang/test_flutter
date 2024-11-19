import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences import 추가
import 'find_pw.dart'; // 비밀번호 찾기 페이지
import 'sign_up_page.dart'; // 회원가입 페이지
import 'spotify_connect_page.dart'; // 스포티파이 연동 페이지

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  // 로그인 처리 로직
  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일과 비밀번호를 입력해주세요.')),
      );
    } else {
      // SharedPreferences로 연동 여부 체크
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isSpotifyLinked = prefs.getBool('isSpotifyLinked') ?? false;

      // 스포티파이 연동이 되어 있지 않으면 연동 페이지로 이동
      if (!isSpotifyLinked) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SpotifyConnectPage(nickname: '사용자')),
        );
      } else {
        // 연동이 완료되었으면 홈 화면 등으로 이동
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인 성공!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LOGIN')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 이메일 입력 필드
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // 비밀번호 입력 필드
            TextField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: '비밀번호',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 로그인 버튼
            ElevatedButton(
              onPressed: _login,
              child: const Text('로그인하기'),
            ),
            const SizedBox(height: 20),
            // 비밀번호 찾기와 회원가입 버튼을 가로로 배치
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 비밀번호 찾기 버튼
                TextButton(
                  onPressed: () {
                    // 비밀번호 찾기 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FindPasswordPage()),
                    );
                  },
                  child: const Text('비밀번호 찾기'),
                ),
                const SizedBox(width: 20), // 버튼 사이 간격
                // 회원가입 버튼
                TextButton(
                  onPressed: () {
                    // 회원가입 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: const Text('회원가입'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
