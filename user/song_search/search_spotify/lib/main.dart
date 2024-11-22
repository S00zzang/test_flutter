import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List tracks = [];

  // Node.js 서버의 엔드포인트 URL (프록시 서버)
  final String apiUrl = 'http://192.168.0.2:3000/spotify';

  // Spotify 검색 API 호출
  Future<void> _searchSpotify() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    try {
      final response = await http.get(
        Uri.parse('$apiUrl?q=$query'),
      );

      if (response.statusCode == 200) {
        // 응답이 성공적이면 JSON 데이터 파싱
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          tracks = data['tracks']['items']; // Spotify API의 트랙 데이터 위치
        });
      } else {
        throw Exception('Failed to load tracks');
      }
    } catch (e) {
      // 예외 처리
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spotify Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for songs or artists',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _searchSpotify,
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            tracks.isEmpty
                ? Center(child: Text('No tracks found'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: tracks.length,
                      itemBuilder: (context, index) {
                        final track = tracks[index];
                        return ListTile(
                          title: Text(track['id']),
                          subtitle: Text(track['artists']
                              .map((artist) => artist['name'])
                              .join(', ')),
                          leading: track['album']['images'].isNotEmpty
                              ? Image.network(
                                  track['album']['images'][0]['url'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.music_note),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
