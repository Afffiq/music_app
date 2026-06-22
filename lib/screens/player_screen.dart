import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/song.dart';

class PlayerScreen extends StatefulWidget {
  final Song song;

  const PlayerScreen({
    super.key,
    required this.song,
  });

  @override
  State<PlayerScreen> createState() => 
  _PlayerScreenState();
}

class _PlayerScreenState
    extends State<PlayerScreen> {

  final player = AudioPlayer();
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  bool isPlaying = false;

  String formatDuration(Duration d) {

    String twoDigits(int n) =>
      n.toString().padLeft(2, '0');

    final minutes =
      twoDigits(d.inMinutes.remainder(60));

    final seconds =
      twoDigits(d.inSeconds.remainder(60));

    return "$minutes:$seconds";
  }

  @override
void initState() {
  super.initState();

  loadSong();

  player.playerStateStream.listen((state) {
    setState(() {
      isPlaying = state.playing;
    });
  });

  player.positionStream.listen((p) {
    setState(() {
      position = p;
    });
  });

  player.durationStream.listen((d) {
    if (d != null) {
      setState(() {
       duration = d;
      });
    }
  });
}

  Future<void> loadSong() async {
  try {
    print("Loading: ${widget.song.assetPath}");

    await player.setAsset(
      widget.song.assetPath,
    );

    print("Song Loaded Successfully");

  } catch (e) {
    print("ERROR: $e");
  }
}

  Future<void> playPause() async {

  if (player.playing) {
    await player.pause();
  } else {
    await player.play();
  }
}

   @override
   void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Now Playing",
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Image.asset(
              'assets/album_covers/cover${widget.song.coverIndex}.png',
              width: 250,
              height: 250,
            ),

            const SizedBox(height: 20),

            Text(
              widget.song.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            Text(
              widget.song.artist,
            ),

            const SizedBox(height: 30),

           Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
             value: position.inSeconds
             .clamp(
               0,
               duration.inSeconds,
              )
             .toDouble(),

             onChanged: (value) async {

             await player.seek(
             Duration(
             seconds: value.toInt(),
             ),
             );

              },
            ),

            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: Row(
               mainAxisAlignment:
               MainAxisAlignment.spaceBetween,

                children: [

                Text(
                  formatDuration(position),
               ),

                Text(
                 formatDuration(duration),
                ),

                 ],
              ),
            ),

            IconButton(
              iconSize: 80,

              onPressed: playPause,

              icon: Icon(
                isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}