import 'package:flutter/material.dart';
import 'main.dart';
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
      home: EditProfilePage(), // 개인정보 수정 페이지로 직접 이동
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfilePage> {
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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // 스포티파이 연동 상태
  bool _isSpotifyLinked = false;

  // 비밀번호 숨기기/보이기 기능
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // 닉네임 중복 확인 (예시)
  final List<String> _existingNicknames = ['쑤', '김철수', '박영희'];

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

  // 프로필 사진 확대 보기 팝업
  void _viewProfileImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            clipBehavior: Clip.none, // 엑스 버튼을 밖으로 위치시킬 수 있게
            children: [
              Image.file(File(_image?.path ?? _profileImageUrl)),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 30,
                  ),
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

  // 스포티파이 연동/끊기 기능
  void _toggleSpotifyLink() {
    setState(() {
      _isSpotifyLinked = !_isSpotifyLinked;
    });
  }

  // 닉네임 유효성 검사 함수 (공백 금지, 중복 닉네임 체크)
  String? _validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return '닉네임을 입력해주세요';
    }

    value = value.trim(); // 양옆 공백 제거

    // 공백만 입력된 경우
    if (value.isEmpty) {
      return '닉네임을 입력해주세요';
    }

    // 닉네임의 첫 글자가 공백인 경우
    if (value.startsWith(' ')) {
      return '처음 공백을 제거해주세요';
    }

    // 닉네임이 변경되었을 때만 중복 검사
    if (_nicknameController.text != '쑤' && _existingNicknames.contains(value)) {
      return '이미 사용 중인 닉네임입니다';
    }

    return null;
  }

  // 비밀번호 유효성 검사 함수
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }

    if (value.length < 6) {
      return '비밀번호는 6자리 이상이어야 합니다';
    }

    return null;
  }

  // 비밀번호 확인 유효성 검사 함수
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호 확인을 입력해주세요';
    }

    if (value != _passwordController.text) {
      return '비밀번호가 일치하지 않습니다';
    }

    return null;
  }

  // 저장 버튼 클릭 시
  void _saveChanges() {
    final nicknameError = _validateNickname(_nicknameController.text);
    final passwordError = _validatePassword(_passwordController.text);
    final confirmPasswordError =
        _validateConfirmPassword(_confirmPasswordController.text);

    if (nicknameError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      // 에러 메시지가 있으면 저장하지 않고 출력
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                nicknameError ?? passwordError ?? confirmPasswordError ?? '')),
      );
      return;
    }

    // 여기서 저장 로직을 구현!!
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // 뒤로가기 화살표 아이콘
          onPressed: () {
            // 메인 페이지로 이동
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyPageScreen()));
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 사진과 오른쪽 필드
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // 닉네임과 프로필 사진 높이를 맞추기
              children: [
                // 프로필 사진
                Padding(
                  padding: const EdgeInsets.only(left: 40.0), // 왼쪽 공백 추가
                  child: GestureDetector(
                    onTap: _viewProfileImage, // 프로필 사진 클릭 시 확대 보기
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 100, // 프로필 사진 크기
                          backgroundImage: _image == null
                              ? NetworkImage(_profileImageUrl)
                              : FileImage(File(_image!.path))
                                  as ImageProvider<Object>, // 수정된 부분: File로 변환
                        ),
                        const SizedBox(height: 10), // 버튼과 사진 사이 간격 추가
                        ElevatedButton(
                          onPressed: _pickImage, // 사진 변경 버튼
                          child: const Text('사진 변경하기'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // 프로필 오른쪽 필드 (닉네임, 이메일, 비밀번호)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30.0), // 오른쪽 공백 추가
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end, // 오른쪽 정렬
                      children: [
                        // 닉네임 입력 필드
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.50, // 화면의 절반 크기
                          child: TextField(
                            controller: _nicknameController,
                            decoration: InputDecoration(
                              labelText: 'Nickname',
                              errorText:
                                  _validateNickname(_nicknameController.text),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // 이메일 입력 필드 (수정 불가)
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.50, // 화면의 절반 크기
                          child: TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              enabled: false, // 이메일은 수정할 수 없도록 설정
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // 비밀번호 입력 필드
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.50, // 화면의 절반 크기
                          child: TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              errorText:
                                  _validatePassword(_passwordController.text),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // 비밀번호 확인 입력 필드
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.50, // 화면의 절반 크기
                          child: TextField(
                            controller: _confirmPasswordController,
                            obscureText: !_isConfirmPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              errorText: _validateConfirmPassword(
                                  _confirmPasswordController.text),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 구분선
            const Divider(),

            // 스포티파이 연동
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.music_note, color: Colors.green),
                    SizedBox(width: 20),
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
            Align(
              alignment: Alignment.centerRight, // 오른쪽 끝 정렬
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
