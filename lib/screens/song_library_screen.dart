import 'package:flutter/material.dart';

import '../models/song.dart';
import '../services/song_service.dart';
import 'player_screen.dart';

class SongLibraryScreen extends StatefulWidget {
  const SongLibraryScreen({super.key});

  @override
  State<SongLibraryScreen> createState() =>
      _SongLibraryScreenState();
}

class _SongLibraryScreenState
    extends State<SongLibraryScreen> {

  final songService = SongService();

  late Future<List<Song>> songsFuture;

  @override
  void initState() {
    super.initState();

    songsFuture =
        songService.getSongs();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Music Library",
        ),
      ),

      body: FutureBuilder<List<Song>>(
        future: songsFuture,

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return Center(
              child: Text(
                "Error: ${snapshot.error}",
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {

            return const Center(
              child: Text(
                "No songs found",
              ),
            );
          }

          List<Song> songs =
              snapshot.data!;

          return ListView.builder(
            itemCount: songs.length,

            itemBuilder:
                (context, index) {

              Song song =
                  songs[index];

              return Card(
                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                child: ListTile(

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PlayerScreen(
                          songs: songs,
                          currentIndex: index,
                        ),
                      ),
                    );

                  },

                  leading: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(8),

                    child: Image.asset(
                      'assets/album_covers/cover${song.coverIndex}.png',
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                    ),
                  ),

                  title: Text(
                    song.title,
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    song.artist,
                  ),

                  trailing: const Icon(
                    Icons.play_arrow,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}