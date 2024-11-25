import 'package:flutter/material.dart';
import 'main.dart'; // main.dart로 돌아가기 위해 import

class MyPlaylistPage extends StatelessWidget {
  final List selectedTracks;
  final Function(List) onPlaylistUpdated;

  // 생성자에서 선택된 트랙들을 받아옵니다.
  MyPlaylistPage(
      {required this.selectedTracks, required this.onPlaylistUpdated});

  // 플레이리스트에서 노래 삭제
  void _removeTrack(BuildContext context, Map<String, dynamic> track) {
    final newSelectedTracks = List.from(selectedTracks);
    newSelectedTracks.remove(track);

    // 삭제된 리스트를 업데이트하여 새로 렌더링
    onPlaylistUpdated(newSelectedTracks); // 상태 업데이트
  }

  // '완성' 버튼 눌렀을 때 처리
  void _onComplete(BuildContext context) {
    if (selectedTracks.length >= 10) {
      // 10곡 이상이면 완료 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyPlaylistPage(
            selectedTracks: selectedTracks,
            onPlaylistUpdated: onPlaylistUpdated, // 상태 전달
          ),
        ),
      );
    } else {
      // 10곡 미만이면 경고 메시지 띄움
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("플레이리스트 미완성"),
          content: const Text("최소 10곡을 담아야 합니다. 더 담아주세요."),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 플레이리스트'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: selectedTracks.isEmpty
                  ? const Center(child: Text('플레이리스트에 곡이 없습니다.'))
                  : ListView.builder(
                      itemCount: selectedTracks.length,
                      itemBuilder: (context, index) {
                        final track = selectedTracks[index];
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
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeTrack(context, track),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            // '더 담기' 버튼과 '완성' 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 더 담기 버튼을 누르면 main.dart로 이동
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaylistPage(
                          selectedTracks: selectedTracks,
                          onPlaylistUpdated: onPlaylistUpdated,
                        ),
                      ),
                    );
                  },
                  child: const Text('더 담기'),
                ),
                ElevatedButton(
                  onPressed: () => _onComplete(context),
                  child: const Text('완성'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedTracks.length >= 10
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
