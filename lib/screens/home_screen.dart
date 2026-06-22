import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/admin_service.dart';
import 'login_screen.dart';
import 'upload_song_screen.dart';
import 'song_library_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    checkAdmin();
  }

  Future<void> checkAdmin() async {
    bool result = await AdminService().isAdmin();

    setState(() {
      isAdmin = result;
    });
  }

  Future<void> logout() async {
    await AuthService().signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "Welcome to Music App",
              style: TextStyle(fontSize: 24),
            ),

            const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {

              Navigator.push(
               context,
               MaterialPageRoute(
                 builder: (_) =>
                  const SongLibraryScreen(),
                ),
              );

            },
            child: const Text(
             "Music Library",
            ),
          ),

            if (isAdmin)
              ElevatedButton(
                onPressed: () { Navigator.push(
                context,
                 MaterialPageRoute(
                 builder: (_) =>
                 const UploadSongScreen(),
                  ),
               );
               },
                child: const Text("Upload Song"),
              ),
          ],
        ),
      ),
    );
  }
}