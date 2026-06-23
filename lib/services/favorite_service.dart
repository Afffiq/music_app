import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  Future<List<String>> getFavoriteSongIds() async {

    String uid =
      _auth.currentUser!.uid;

    DocumentSnapshot doc =
      await _firestore
          .collection('users')
          .doc(uid)
          .get();

    if (!doc.exists ||
      doc.data() == null) {
        return [];
      }

  Map<String, dynamic> data =
      doc.data()
          as Map<String, dynamic>;

    return List<String>.from(
      data['favoriteSongs'] ?? [],
    );
  }

  Future<void> toggleFavorite(
    String songId,
  ) async {

    String uid =
        _auth.currentUser!.uid;

    DocumentReference userDoc =
        _firestore
            .collection('users')
            .doc(uid);

    DocumentSnapshot snapshot =
        await userDoc.get();

    Map<String, dynamic> data =
        snapshot.data()
            as Map<String, dynamic>;

    List<String> favorites =
        List<String>.from(
      data['favoriteSongs'] ?? [],
    );

    if (favorites.contains(songId)) {

      favorites.remove(songId);

    } else {

      favorites.add(songId);
    }

    await userDoc.update({
      'favoriteSongs': favorites,
    });
  }
}