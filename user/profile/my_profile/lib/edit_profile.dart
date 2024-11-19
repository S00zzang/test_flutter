import 'package:flutter/material.dart';
import 'dart:io'; // File 클래스를 사용하기 위해 필요한 import
import 'package:image_picker/image_picker.dart'; // 사진 업로드를 위한 라이브러리

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditProfileScreen(), // 개인정보 수정 페이지로 직접 이동
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // 프로필 사진
  XFile? _image;
  String _profileImageUrl =
      'https://www.example.com/path_to_default_profile_picture.jpg'; // 기본 이미지 URL

  // 닉네임, 이메일, 비밀번호
  final TextEditingController _nicknameController =
      TextEditingController(text: '쑤');
  final TextEditingController _emailController =
      TextEditingController(text: '수짱@테스트.com');
  final TextEditingController _passwordController = TextEditingController();

  // 스포티파이 연동 상태
  bool _isSpotifyLinked = false;

  // 이미지 선택 기능
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = image;
        _profileImageUrl = image.path; // 이미지 경로로 업데이트
      });
    }
  }

  // 스포티파이 연동/끊기 기능
  void _toggleSpotifyLink() {
    setState(() {
      _isSpotifyLinked = !_isSpotifyLinked;
    });
  }

  // 저장 버튼 클릭 시
  void _saveChanges() {
    // 여기서 저장 로직을 구현합니다 (예: 서버로 변경된 정보 전송)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 사진
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _image == null
                        ? NetworkImage(_profileImageUrl)
                        : FileImage(File(_image!.path))
                            as ImageProvider<Object>, // 수정된 부분: File로 변환
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 닉네임 입력 필드
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: 'Nickname',
              ),
            ),
            const SizedBox(height: 20),

            // 이메일 입력 필드 (수정 불가)
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                enabled: false, // 이메일은 수정할 수 없도록 설정
              ),
            ),
            const SizedBox(height: 20),

            // 비밀번호 입력 필드
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),

            const Divider(),

            // 스포티파이 연동
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.music_note, color: Colors.green),
                    SizedBox(width: 10),
                    Text('Spotify Link'),
                  ],
                ),
                TextButton(
                  onPressed: _toggleSpotifyLink,
                  child: Text(
                    _isSpotifyLinked ? 'Unlink' : 'Link',
                    style: TextStyle(
                      color: _isSpotifyLinked ? Colors.red : Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 저장 버튼
            Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
