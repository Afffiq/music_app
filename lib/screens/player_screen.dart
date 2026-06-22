import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/song.dart';

class PlayerScreen extends StatefulWidget {
  final List<Song> songs;
  final int currentIndex;

  const PlayerScreen({
    super.key,
    required this.songs,
    required this.currentIndex,
  });

  @override
  State<PlayerScreen> createState() =>
      _PlayerScreenState();
}

class _PlayerScreenState
    extends State<PlayerScreen> {

  final player = AudioPlayer();

  bool isPlaying = false;

  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  late int currentIndex;
  late Song currentSong;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.currentIndex;
    currentSong = widget.songs[currentIndex];

    loadSong();

    player.playerStateStream.listen((state) {
      if (!mounted) return;

      setState(() {
        isPlaying = state.playing;
      });
    });

    player.processingStateStream.listen(
      (processingState) {

        if (processingState ==
            ProcessingState.completed) {

          nextSongAuto();
        }
      },
    );

    player.positionStream.listen((p) {
      if (!mounted) return;

      setState(() {
        position = p;
      });
    });

    player.durationStream.listen((d) {
      if (d != null && mounted) {
        setState(() {
          duration = d;
        });
      }
    });
  }

  Future<void> loadSong() async {

    try {

      print(
        "Loading: ${currentSong.assetPath}",
      );

      await player.stop();

      await player.setAsset(
        currentSong.assetPath,
      );

      print(
        "Song Loaded Successfully",
      );

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

  Future<void> previousSong() async {

    if (currentIndex > 0) {

      setState(() {

        currentIndex--;

        currentSong =
            widget.songs[currentIndex];
      });

      await player.stop();

      await loadSong();

      await player.play();
    }
  }

  Future<void> nextSong() async {

    if (currentIndex <
        widget.songs.length - 1) {

      setState(() {

        currentIndex++;

        currentSong =
            widget.songs[currentIndex];
      });

      await player.stop();

      await loadSong();

      await player.play();
    }
  }

  Future<void> nextSongAuto() async {

    if (currentIndex <
        widget.songs.length - 1) {

      setState(() {

        currentIndex++;

        currentSong =
            widget.songs[currentIndex];
      });

      await loadSong();

      await player.play();
    }
  }

  String formatDuration(
    Duration d,
  ) {

    String twoDigits(
      int n,
    ) =>
        n.toString().padLeft(
              2,
              '0',
            );

    final minutes =
        twoDigits(
      d.inMinutes.remainder(60),
    );

    final seconds =
        twoDigits(
      d.inSeconds.remainder(60),
    );

    return "$minutes:$seconds";
  }

  @override
  void dispose() {

    player.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Now Playing",
        ),
      ),

      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Image.asset(
                'assets/album_covers/cover${currentSong.coverIndex}.png',
                width: 250,
                height: 250,
              ),

              const SizedBox(
                height: 20,
              ),

              Text(
                currentSong.title,
                style:
                    const TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
                textAlign:
                    TextAlign.center,
              ),

              const SizedBox(
                height: 5,
              ),

              Text(
                currentSong.artist,
                style:
                    const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              Slider(
                min: 0,

                max: duration
                            .inSeconds >
                        0
                    ? duration
                        .inSeconds
                        .toDouble()
                    : 1,

                value: position
                    .inSeconds
                    .clamp(
                      0,
                      duration
                                  .inSeconds >
                              0
                          ? duration
                              .inSeconds
                          : 1,
                    )
                    .toDouble(),

                onChanged:
                    (value) async {

                  await player.seek(
                    Duration(
                      seconds:
                          value.toInt(),
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
                      MainAxisAlignment
                          .spaceBetween,

                  children: [

                    Text(
                      formatDuration(
                        position,
                      ),
                    ),

                    Text(
                      formatDuration(
                        duration,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                children: [

                  IconButton(
                    iconSize: 50,
                    onPressed:
                        previousSong,
                    icon:
                        const Icon(
                      Icons
                          .skip_previous,
                    ),
                  ),

                  IconButton(
                    iconSize: 80,
                    onPressed:
                        playPause,
                    icon: Icon(
                      isPlaying
                          ? Icons.pause
                          : Icons
                              .play_arrow,
                    ),
                  ),

                  IconButton(
                    iconSize: 50,
                    onPressed:
                        nextSong,
                    icon:
                        const Icon(
                      Icons.skip_next,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}