import 'package:flutter/material.dart';
import 'edit_profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyPageScreen(),
      routes: {
        '/myPage': (context) => const MyPageScreen(),
        '/playlist': (context) => const PlaylistScreen(),
        '/talk': (context) => const TalkScreen(),
        '/club': (context) => const ClubScreen(),
        '/like': (context) => const LikeScreen(),
      },
    );
  }
}

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  // 메뉴 상태
  bool isIconOnly = false;

  // 친구 목록
  final List<Map<String, String>> friends = [
    {'nickname': 'Drew', 'email': 'friend1@example.com'},
    {'nickname': 'young인', 'email': 'friend2@example.com'},
    {'nickname': '쩡25', 'email': 'friend3@example.com'},
    {'nickname': '석규**', 'email': 'friend4@example.com'},
  ];

  // 닉네임과 이메일
  final String nickname = '쑤';
  final String email = '수짱@테스트.com';

  // 메뉴 버튼 클릭 시 이모티콘 표시 여부 변경
  void toggleMenu() {
    setState(() {
      isIconOnly = !isIconOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 왼쪽 메뉴바
          NavigationDrawer(
            isIconOnly: isIconOnly,
            toggleMenu: toggleMenu,
          ),
          // 오른쪽 My Page 화면
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Profile',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 60, // 프로필 사진 크기를 키움
                        backgroundImage: NetworkImage(
                            'https://www.example.com/path_to_profile_picture.jpg'),
                      ),
                      const SizedBox(width: 20),
                      // 닉네임, 이메일 및 버튼을 오른쪽으로 배치
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0), // 왼쪽에 추가적인 여백을 줘서 간격을 조정
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(nickname,
                                  style: const TextStyle(fontSize: 20)),
                              const SizedBox(height: 5),
                              Text(email, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      // 개인정보 수정 버튼
                      ElevatedButton(
                        onPressed: () {
                          // 개인정보 수정 페이지로 이동하는 로직
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfilePage()),
                          );
                        },
                        child: const Text('Edit Profile'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  const Text(
                    'Following',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // 팔로잉 목록
                  Expanded(
                    child: ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final friend = friends[index];
                        return ListTile(
                          leading: const CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                                'https://www.example.com/path_to_friend_profile.jpg'),
                          ),
                          title: Text(friend['nickname']!),
                          subtitle: Text(friend['email']!),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // 대화하기 버튼 클릭 시
                                },
                                child: const Text('Talk'),
                              ),
                              MouseRegion(
                                onEnter: (_) {
                                  setState(() {});
                                },
                                onExit: (_) {
                                  setState(() {});
                                },
                                child: TextButton(
                                  onPressed: () {
                                    // 팔로우 삭제 버튼 클릭 시
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                        WidgetStateProperty.all(Colors.red),
                                    backgroundColor: WidgetStateProperty.all(
                                        Colors.transparent),
                                    textStyle: WidgetStateProperty.all(
                                      const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  child: const Text('Unfollow'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final bool isIconOnly;
  final VoidCallback toggleMenu;

  const NavigationDrawer({
    required this.isIconOnly,
    required this.toggleMenu,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // 애니메이션 지속 시간
      width: isIconOnly ? 60 : 140, // 메뉴의 너비
      color: Colors.blueGrey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft, // 아이콘을 왼쪽 정렬
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0), // 아이콘 왼쪽 여백 추가
              child: IconButton(
                icon: Icon(isIconOnly ? Icons.menu : Icons.menu),
                onPressed: toggleMenu,
              ),
            ),
          ),
          const SizedBox(height: 30), // 메뉴 항목과의 갭
          if (!isIconOnly) ...[
            buildMenuItem(
              Icons.account_box_outlined,
              'My Page',
              '/myPage',
              context,
            ),
            const SizedBox(height: 20),
            buildMenuItem(
              Icons.library_music_outlined,
              'Playlist',
              '/playlist',
              context,
            ),
            const SizedBox(height: 20),
            buildMenuItem(
              Icons.chat_bubble_outline,
              'Talk',
              '/talk',
              context,
            ),
            const SizedBox(height: 20),
            buildMenuItem(
              Icons.family_restroom_outlined,
              'Club',
              '/club',
              context,
            ),
            const SizedBox(height: 20),
            buildMenuItem(
              Icons.favorite_outlined,
              'Like',
              '/like',
              context,
            ),
          ],
          if (isIconOnly) ...[
            buildMenuItem(Icons.account_box_outlined, '', '/myPage', context),
            const SizedBox(height: 20),
            buildMenuItem(
                Icons.library_music_outlined, '', '/playlist', context),
            const SizedBox(height: 20),
            buildMenuItem(Icons.chat_bubble_outline, '', '/talk', context),
            const SizedBox(height: 20),
            buildMenuItem(Icons.family_restroom_outlined, '', '/club', context),
            const SizedBox(height: 20),
            buildMenuItem(Icons.favorite_outlined, '', '/like', context),
          ]
        ],
      ),
    );
  }

  // 메뉴 항목 생성 (아이콘 클릭 시 페이지 이동)
  Widget buildMenuItem(
      IconData icon, String label, String route, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route); // 지정된 경로로 페이지 이동
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0), // 아이콘 왼쪽 여백 추가
              child: Icon(icon, color: Colors.white),
            ),
            if (!isIconOnly) ...[
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// 각 메뉴에 해당하는 화면 (예시)
class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playlist')),
      body: const Center(child: Text('Playlist Page')),
    );
  }
}

class TalkScreen extends StatelessWidget {
  const TalkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Talk')),
      body: const Center(child: Text('Talk Page')),
    );
  }
}

class ClubScreen extends StatelessWidget {
  const ClubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Club')),
      body: const Center(child: Text('Club Page')),
    );
  }
}

class LikeScreen extends StatelessWidget {
  const LikeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Like')),
      body: const Center(child: Text('Like Page')),
    );
  }
}
