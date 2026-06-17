import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<bool> isAdmin() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return false;

    DocumentSnapshot doc =
        await _firestore
            .collection('admins')
            .doc(user.uid)
            .get();

    return doc.exists;
  }
}