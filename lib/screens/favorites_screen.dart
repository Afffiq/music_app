import 'package:flutter/material.dart';

import '../models/song.dart';
import '../services/song_service.dart';
import '../services/favorite_service.dart';
import 'player_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState
    extends State<FavoritesScreen> {

  final songService =
      SongService();

  final favoriteService =
      FavoriteService();

  List<Song> favoriteSongs = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadFavorites();
  }

  Future<void> loadFavorites() async {

    List<Song> allSongs =
        await songService.getSongs();

    List<String> favoriteIds =
        await favoriteService
            .getFavoriteSongIds();

    favoriteSongs =
        allSongs.where((song) {
      return favoriteIds.contains(
        song.id,
      );
    }).toList();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorite Songs",
        ),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : favoriteSongs.isEmpty
              ? const Center(
                  child: Text(
                    "No favorite songs",
                  ),
                )
              : ListView.builder(
                  itemCount:
                      favoriteSongs.length,

                  itemBuilder:
                      (context, index) {

                    Song song =
                        favoriteSongs[index];

                    return ListTile(

                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PlayerScreen(
                              songs:
                                  favoriteSongs,
                              currentIndex:
                                  index,
                            ),
                          ),
                        );
                      },

                      leading:
                          Image.asset(
                        'assets/album_covers/cover${song.coverIndex}.png',
                        width: 50,
                        height: 50,
                      ),

                      title:
                          Text(song.title),

                      subtitle:
                          Text(song.artist),
                    );
                  },
                ),
    );
  }
}