class Song {
  final String id;
  final String title;
  final String artist;
  final String assetPath;
  final int coverIndex;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.assetPath,
    required this.coverIndex,
  });

  factory Song.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return Song(
      id: id,
      title: data['title'] ?? '',
      artist: data['artist'] ?? '',
      assetPath: data['assetPath'] ?? '',
      coverIndex: data['coverIndex'] ?? 1,
    );
  }
}