import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'my_playlist.dart'; // 새 페이지 import

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List selectedTracks = []; // 플레이리스트에 담긴 트랙
  final String apiUrl = 'http://192.168.0.2:3000/spotify'; // Node.js 서버 URL

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PlaylistPage(
        selectedTracks: selectedTracks,
        onPlaylistUpdated: (newTracks) {
          setState(() {
            selectedTracks = newTracks; // 업데이트된 플레이리스트 상태 관리
          });
        },
      ),
    );
  }
}

class PlaylistPage extends StatefulWidget {
  final List selectedTracks;
  final Function(List) onPlaylistUpdated;

  PlaylistPage({required this.selectedTracks, required this.onPlaylistUpdated});

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final TextEditingController _searchController = TextEditingController();
  List tracks = []; // 검색된 트랙 리스트
  bool isSidebarOpen = true; // 사이드바 상태 관리
  int offset = 0; // Spotify API에서 10곡씩 가져오기 위한 오프셋

  final String apiUrl = 'http://192.168.0.2:3000/spotify'; // Node.js 서버 URL

  // Spotify 검색 API 호출
  Future<void> _searchSpotify() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    try {
      final response = await http.get(
        Uri.parse('$apiUrl?q=$query&limit=10&offset=$offset'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          tracks = data['tracks']['items']; // 검색된 트랙 리스트 업데이트
        });
      } else {
        throw Exception('Failed to load tracks');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // 플레이리스트에 노래 추가
  void _addToPlaylist(Map<String, dynamic> track) {
    if (!widget.selectedTracks.contains(track)) {
      setState(() {
        widget.selectedTracks.add(track);
      });
      widget.onPlaylistUpdated(widget.selectedTracks); // 상태 업데이트
    }
  }

  // 플레이리스트에서 노래 삭제
  void _removeFromPlaylist(Map<String, dynamic> track) {
    setState(() {
      widget.selectedTracks.remove(track);
    });
    widget.onPlaylistUpdated(widget.selectedTracks); // 상태 업데이트
  }

  // 플레이리스트가 최소 10곡 이상일 때
  bool get isPlaylistComplete => widget.selectedTracks.length >= 10;

  // 플레이리스트 완성 여부 체크
  void _onComplete() {
    if (isPlaylistComplete) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyPlaylistPage(
            selectedTracks: widget.selectedTracks,
            onPlaylistUpdated: widget.onPlaylistUpdated, // 상태 전달
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("플레이리스트 미완성"),
          content: const Text("최소 10곡을 선택하세요."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        ),
      );
    }
  }

  // 사이드바 열고 닫기
  void _toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 사이드바: 왼쪽에 플레이리스트 표시
          isSidebarOpen
              ? Container(
                  width: 250,
                  color: Colors.grey[200], // 사이드바 열릴 때 색깔 지정
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        // "내 플레이리스트" 텍스트 가운데 정렬
                        Center(
                          child: const Text(
                            '내 플레이리스트',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
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
                                onTap: () =>
                                    _removeFromPlaylist(track), // 앨범 커버를 눌러서 삭제
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(), // 사이드바 닫을 경우 빈 컨테이너
          // 오른쪽: 검색 및 곡 정보 표시
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    '나의 플레이리스트 만들기',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '최소 10곡을 골라 플레이리스트를 완성하세요.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'Search for songs or artists',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _searchSpotify(), // 엔터 키로도 검색
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _searchSpotify,
                        child: const Text('Search'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: tracks.isEmpty
                        ? const Center(child: Text('No tracks found'))
                        : ListView.builder(
                            itemCount: tracks.length,
                            itemBuilder: (context, index) {
                              final track = tracks[index];
                              return ListTile(
                                leading: track['album']['images'].isNotEmpty
                                    ? Image.network(
                                        track['album']['images'][0]['url'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.music_note),
                                title: Text(track['name']),
                                subtitle: Text(track['artists']
                                    .map((artist) => artist['name'])
                                    .join(', ')),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    _addToPlaylist(track);
                                  },
                                  child: Text(
                                      widget.selectedTracks.contains(track)
                                          ? '이미 담긴 곡'
                                          : '담기'),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onComplete,
                    child: const Text('완성'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isPlaylistComplete ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // 오른쪽 아래에 고정된 음악 아이콘 버튼 추가
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleSidebar, // 버튼 클릭 시 사이드바 열고 닫기
        child: Icon(Icons.audiotrack),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
