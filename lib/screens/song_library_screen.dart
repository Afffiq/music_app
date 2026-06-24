import 'package:flutter/material.dart';

import '../models/song.dart';
import '../services/song_service.dart';
import 'player_screen.dart';
import '../services/favorite_service.dart';

class SongLibraryScreen extends StatefulWidget {
  const SongLibraryScreen({super.key});

  @override
  State<SongLibraryScreen> createState() => _SongLibraryScreenState();
}

class _SongLibraryScreenState extends State<SongLibraryScreen> {
  final songService = SongService();
  final searchController = TextEditingController();
  final favoriteService = FavoriteService();

List<String> favoriteSongIds = [];

  List<Song> allSongs = [];
  List<Song> filteredSongs = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadSongs() async {
    try {
      allSongs = await songService.getSongs();
      favoriteSongIds = await favoriteService.getFavoriteSongIds();
      filteredSongs = List.from(allSongs);
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchSongs(String query) {
    setState(() {
      final lowerQuery = query.toLowerCase();
      filteredSongs = allSongs.where((song) {
        return song.title.toLowerCase().contains(lowerQuery) ||
            song.artist.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Music Library (${filteredSongs.length})',),
      ),
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (errorMessage != null) {
            return Center(
              child: Text('Error: $errorMessage'),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: searchSongs,
                  decoration: InputDecoration(
                    hintText: 'Search songs...',
                    prefixIcon: const Icon(Icons.search,color: Color(0xFF23D160),),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              if (filteredSongs.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('No songs found'),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) {
                      final song = filteredSongs[index];
                      return Card(
                        color: const Color(0xFF002B12),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          onTap: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlayerScreen(
                                  songs: filteredSongs,
                                  currentIndex: index,
                                ),
                              ),
                            );
                          
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(song.artist),
                          trailing: IconButton(

                            icon: Icon(
                              favoriteSongIds.contains(
                                song.id,
                             )
                             ? Icons.favorite
                             : Icons.favorite_border,

                            ),

                            onPressed: () async {

                              await favoriteService
                             .toggleFavorite(
                                song.id,
                              );

                             await loadSongs();

                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
