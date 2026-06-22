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

              return ListTile(

                onTap: () {

               Navigator.push(
                context,
                MaterialPageRoute(
                 builder: (_) =>
                  PlayerScreen(
                   song: song,
                  ),
                ),
              );

                },

               leading: Image.asset(
                 'assets/album_covers/cover${song.coverIndex}.png',
                 width: 50,
                 height: 50,
                 fit: BoxFit.cover,
                ),

               title: Text(song.title),

               subtitle: Text(song.artist),
              );
            },
          );
        },
      ),
    );
  }
}