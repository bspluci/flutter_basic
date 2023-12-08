import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PianoApp extends StatefulWidget {
  const PianoApp({Key? key}) : super(key: key);

  @override
  State<PianoApp> createState() => _PianoAppState();
}

class _PianoAppState extends State<PianoApp> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<String> _notes = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  void _initAudioPlayer() async {
    await _audioPlayer.setAsset('piano_C.wav');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('피아노 앱'),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.landscape
              ? _buildLandscapeMode()
              : _buildPortraitMode();
        },
      ),
    );
  }

  Widget _buildLandscapeMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _notes.map((note) => _buildNoteButton(note)).toList(),
    );
  }

  Widget _buildPortraitMode() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _notes.map((note) => _buildNoteButton(note)).toList(),
    );
  }

  Widget _buildNoteButton(String note) {
    return ElevatedButton(
      onPressed: () {
        _playNoteSound(note);
      },
      child: Text(note),
    );
  }

  void _playNoteSound(String note) async {
    // 파일명이 'piano_c.wav'와 같이 형식이 되도록 설정
    String soundPath = 'piano_$note.wav';

    // 현재 재생 중인 음악을 중지
    await _audioPlayer.stop();

    // assets 폴더에 저장된 음악 파일을 로드
    await _audioPlayer.setAsset(soundPath);

    // 음악 재생
    await _audioPlayer.play();
  }

  @override
  void dispose() {
    // 앱이 종료되면 오디오 플레이어를 정리
    _audioPlayer.dispose();
    super.dispose();
  }
}
