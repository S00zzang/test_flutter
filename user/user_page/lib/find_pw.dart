import 'package:flutter/material.dart';

class FindPasswordPage extends StatefulWidget {
  @override
  _FindPasswordPageState createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  final _emailController = TextEditingController();

  // 이미 존재하는 이메일 목록 (하드코딩된 예시)
  final List<String> _existingEmails = [
    'test@example.com',
    'user@example.com',
    'admin@example.com'
  ];
  final Map<String, String> _userPasswords = {
    'test@example.com': 'password123',
    'user@example.com': 'userpassword',
    'admin@example.com': 'adminpassword',
  };

  // 이메일 유효성 검사 함수
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return '유효한 이메일 형식을 입력해주세요';
    }
    return null;
  }

  // 비밀번호 찾기 함수
  void _findPassword() {
    String email = _emailController.text;

    // 이메일이 존재하는지 확인
    if (!_existingEmails.contains(email)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('이 이메일로 가입된 계정이 없습니다')));
      return;
    }

    // 이메일로 비밀번호 전송 (여기서는 비밀번호를 보여주는 방식으로 처리)
    String password = _userPasswords[email]!;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('비밀번호가 이메일로 전송되었습니다: $password')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('비밀번호 찾기')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _findPassword,
              child: const Text('비밀번호 찾기'),
            ),
          ],
        ),
      ),
    );
  }
}
