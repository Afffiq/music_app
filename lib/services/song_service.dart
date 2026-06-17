import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/song.dart';

class SongService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addSong({
    required String title,
    required String artist,
    required String audioUrl,
    required int coverIndex,
  }) async {
    await _firestore.collection('songs').add({
      'title': title,
      'artist': artist,
      'audioUrl': audioUrl,
      'coverIndex': coverIndex,
      'createdAt': Timestamp.now(),
    });
  }

  Future<List<Song>> getSongs() async {
    QuerySnapshot snapshot =
        await _firestore.collection('songs').get();

    return snapshot.docs.map((doc) {
      return Song.fromMap(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    }).toList();
  }
}