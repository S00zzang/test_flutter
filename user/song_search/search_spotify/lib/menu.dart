import 'package:flutter/material.dart';
import 'my_playlist.dart'; // my_playlist.dart에서 만든 플레이리스트를 가져옴

// 왼쪽 메뉴바를 위한 NavigationDrawer
class NavigationDrawer extends StatelessWidget {
  final bool isIconOnly;
  final VoidCallback toggleMenu;

  const NavigationDrawer({
    required this.isIconOnly,
    required this.toggleMenu,
    super.key,
  });

  // 메뉴 항목을 생성하는 빌더 메소드
  Widget buildMenuItem(
      IconData icon, String label, String route, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: isIconOnly
          ? null
          : Text(label, style: TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pushNamed(context, route); // 각 메뉴 클릭 시 해당 페이지로 이동
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isIconOnly ? 60 : 140, // 메뉴가 열렸을 때 크기
      color: Colors.blueGrey,
      child: Column(
        children: [
          // 메뉴 토글 버튼
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: IconButton(
                icon: Icon(isIconOnly ? Icons.menu : Icons.close),
                onPressed: toggleMenu, // 메뉴 열기/닫기
              ),
            ),
          ),
          const SizedBox(height: 30),

          // 메뉴 항목들
          if (!isIconOnly) ...[
            buildMenuItem(
                Icons.account_box_outlined, 'My Page', '/myPage', context),
            const SizedBox(height: 20),
            buildMenuItem(
                Icons.library_music_outlined, 'Playlist', '/playlist', context),
            const SizedBox(height: 20),
            buildMenuItem(Icons.chat_bubble_outline, 'Talk', '/chat', context),
            const SizedBox(height: 20),
            buildMenuItem(
                Icons.family_restroom_outlined, 'Club', '/club', context),
            const SizedBox(height: 20),
            buildMenuItem(Icons.favorite_outlined, 'Like', '/like', context),
          ],

          if (isIconOnly) ...[
            buildMenuItem(Icons.account_box_outlined, '', '/myPage', context),
            const SizedBox(height: 20),
            buildMenuItem(
                Icons.library_music_outlined, '', '/playlist', context),
            const SizedBox(height: 20),
            buildMenuItem(Icons.chat_bubble_outline, '', '/chat', context),
            const SizedBox(height: 20),
            buildMenuItem(Icons.family_restroom_outlined, '', '/club', context),
            const SizedBox(height: 20),
            buildMenuItem(Icons.favorite_outlined, '', '/like', context),
          ]
        ],
      ),
    );
  }
}

// 메인 페이지 (메뉴와 플레이리스트를 동시에 표시)
class MenuPage extends StatefulWidget {
  final List selectedTracks; // 선택된 트랙 리스트

  MenuPage({Key? key, required this.selectedTracks}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool isIconOnly = true; // 메뉴 상태 (닫힌 상태)

  // 메뉴 열기/닫기 상태를 토글하는 함수
  void toggleMenu() {
    setState(() {
      isIconOnly = !isIconOnly; // 상태 반전 (열기/닫기)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("메인 페이지")),
      drawer: NavigationDrawer(
        isIconOnly: isIconOnly, // 현재 상태 전달
        toggleMenu: toggleMenu, // 메뉴 토글 함수 전달
      ),
      body: Row(
        children: [
          // 왼쪽 메뉴 (Navigation Drawer)
          NavigationDrawer(
            isIconOnly: isIconOnly, // 메뉴가 열리고 닫힐 때 상태 관리
            toggleMenu: toggleMenu,
          ),
          // 오른쪽 화면 (플레이리스트 표시)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "내 플레이리스트",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // 플레이리스트가 비어있지 않다면 리스트를 표시
                  Expanded(
                    child: widget.selectedTracks.isEmpty
                        ? const Center(child: Text('플레이리스트에 곡이 없습니다.'))
                        : ListView.builder(
                            itemCount: widget.selectedTracks.length,
                            itemBuilder: (context, index) {
                              final track = widget.selectedTracks[index];
                              return ListTile(
                                leading: track['album']['images'].isNotEmpty
                                    ? Image.network(
                                        track['album']['images'][0]['url'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.music_note),
                                title: Text('${index + 1}. ${track['name']}'),
                                subtitle: Text(track['artists']
                                    .map((artist) => artist['name'])
                                    .join(', ')),
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
