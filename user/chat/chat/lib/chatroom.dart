import 'dart:convert';
import 'package:flutter/gestures.dart'; //url만 밑줄
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'package:url_launcher/url_launcher.dart'; // url_launcher 패키지 임포트

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/chatroom': (context) => const ChatRoomPage(),
        '/chatlist': (context) => const ChatListPage(),
      },
      home: const ChatListPage(),
    );
  }
}

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  bool isMenuOpen = false;
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;
  List<ChatMessage> chatMessages = [];
  List<String> sharedMusicList = []; // 공유된 음악 리스트
  String userNickname = "User123";
  String profileImageUrl = "https://www.example.com/profile.jpg";

  String _getFormattedTime() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    final hour = now.hour;
    final minute = now.minute;
    return '$year년 $month월 $day일 ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  // 메시지를 채팅에 추가하는 함수
  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        String currentTime = _getFormattedTime();
        chatMessages.add(ChatMessage(message: message, time: currentTime));
        if (message.contains('https://open.spotify.com/embed/track/')) {
          // 음악 메시지라면 노래 제목과 가수만 sharedMusicList에 추가
          final splitMessage = message.split("\n")[0]; // '노래 제목 - 가수' 부분만 추출
          sharedMusicList.add(splitMessage);
        }
        _messageController.clear();
        _isTyping = false;
      });
    }
  }

  void _onMessageChange(String text) {
    setState(() {
      _isTyping = text.isNotEmpty;
    });
  }

  // 팝업창을 띄워서 Spotify에서 음악을 검색할 수 있도록 구현
  Future<void> _searchMusic() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MusicSearchDialog(
          onSongSelected: (song) {
            _sendMessage(song); // 선택된 노래를 바로 메시지로 보냄
          },
        );
      },
    );
  }

  // URL을 여는 함수
  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url); // URL 열기
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(userNickname),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              setState(() {
                isMenuOpen = !isMenuOpen;
              });
            },
          ),
        ],
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      bool isUserMessage = index % 2 == 0;
                      final chatMessage = chatMessages[index];
                      return Align(
                        alignment: isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!isUserMessage)
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(profileImageUrl),
                                ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isUserMessage
                                        ? Colors.blue
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 채팅 메시지에서 URL을 감지하여 링크로 만들기
                                      RichText(
                                        text: TextSpan(
                                          children: _getTextSpans(
                                              chatMessage.message),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        chatMessage.time,
                                        style: TextStyle(
                                          color: isUserMessage
                                              ? Colors.white
                                              : Colors.black.withOpacity(0.6),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          onChanged: _onMessageChange,
                          onSubmitted: (_) {
                            _sendMessage(_messageController.text); // 엔터로 전송
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter your message...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isTyping ? Icons.send : Icons.send,
                          color: _isTyping ? Colors.blue : Colors.grey,
                        ),
                        onPressed: _isTyping
                            ? () {
                                _sendMessage(_messageController.text);
                              }
                            : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.music_note),
                        onPressed: _searchMusic, // 음악 검색 팝업 호출
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isMenuOpen) _buildSideBar(),
        ],
      ),
    );
  }

  // URL을 클릭 가능한 링크로 변환
  List<TextSpan> _getTextSpans(String message) {
    final regex = RegExp(r'(https?://[^\s]+)');
    final matches = regex.allMatches(message);
    List<TextSpan> textSpans = [];

    int start = 0;
    for (final match in matches) {
      if (match.start > start) {
        textSpans.add(TextSpan(
            text: message.substring(start, match.start),
            style: TextStyle(color: Colors.black)));
      }

      final url = match.group(0)!;
      textSpans.add(TextSpan(
          text: url,
          style: TextStyle(
              color: const Color.fromARGB(255, 122, 123, 124),
              decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchURL(url);
            }));

      start = match.end;
    }

    // 남은 텍스트 추가
    if (start < message.length) {
      textSpans.add(TextSpan(
          text: message.substring(start),
          style: TextStyle(color: Colors.black)));
    }

    return textSpans;
  }

  Widget _buildSideBar() {
    return Container(
      width: 250,
      color: Colors.blueGrey,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Shared Music List',
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          // 공유된 음악 리스트 표시
          Expanded(
            child: ListView.builder(
              itemCount: sharedMusicList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    sharedMusicList[index],
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 채팅 메시지 모델
class ChatMessage {
  final String message;
  final String time;

  ChatMessage({required this.message, required this.time});
}

// 음악 검색 다이얼로그
class MusicSearchDialog extends StatefulWidget {
  final Function(String) onSongSelected;

  const MusicSearchDialog({required this.onSongSelected, super.key});

  @override
  _MusicSearchDialogState createState() => _MusicSearchDialogState();
}

class _MusicSearchDialogState extends State<MusicSearchDialog> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = []; // 트랙 ID와 정보를 함께 저장
  String? _selectedSong;
  String? _selectedSongArtist;
  String? _selectedTrackId;

  // 서버에서 음악 검색
  Future<void> _searchSpotify(String query) async {
    if (query.isEmpty) return; // 빈 값일 때는 검색하지 않음

    final response =
        await http.get(Uri.parse('http://192.168.0.2:3000/spotify?q=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _searchResults =
            data['tracks']['items'].map<Map<String, dynamic>>((item) {
          return {
            'name': item['name'],
            'artist': item['artists'][0]['name'],
            'id': item['id'], // 트랙 ID 추가
          };
        }).toList();
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  // 선택된 노래 바로 전송
  void _sendSong() {
    if (_selectedSong != null && _selectedTrackId != null) {
      // 노래 제목, 가수, 트랙 URL을 포함한 메시지 포맷
      final songMessage = '$_selectedSong - $_selectedSongArtist\n'
          'https://open.spotify.com/embed/track/$_selectedTrackId';
      widget.onSongSelected(songMessage); // 선택된 노래를 메세지로 보내기
      Navigator.pop(context); // 팝업만 닫기
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(30), // 팝업 여백 조정
      child: Container(
        width: 650, // 팝업 너비 조정
        height: 450, // 팝업 높이 조정
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목과 닫기 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Search Music',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context), // 다이얼로그 닫기
                ),
              ],
            ),
            SizedBox(height: 10),
            // 검색 창과 버튼
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for a song...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // 사용자가 입력한 검색어에 대해 즉시 결과를 표시하지 않음
                    },
                    onSubmitted: (value) {
                      _searchSpotify(value); // 엔터 키로 검색 실행
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchSpotify(_searchController.text); // 검색 버튼 클릭 시 검색
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // 검색된 음악 리스트
            if (_searchResults.isNotEmpty) // 검색 결과가 있을 때만 리스트를 표시
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final song = _searchResults[index];
                    final songName = song['name'];
                    final artistName = song['artist'];
                    final trackId = song['id'];

                    return ListTile(
                      title: Text('$songName - $artistName'),
                      onTap: () {
                        setState(() {
                          _selectedSong = songName;
                          _selectedSongArtist = artistName;
                          _selectedTrackId = trackId; // 트랙 ID 저장
                        });
                      },
                      selected: _selectedSong == songName, // 선택된 노래 강조
                    );
                  },
                ),
              ),
            SizedBox(height: 10),
            // 선택된 노래와 전송 버튼
            if (_selectedSong != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    // Selected Song: 노래 제목과 가수 이름을 같은 라인에 표시
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Selected Song: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$_selectedSong - $_selectedSongArtist',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _sendSong, // 전송 버튼 클릭 시 바로 전송
                      child: Text('Send Song'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
