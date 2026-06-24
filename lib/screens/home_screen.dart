import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/admin_service.dart';
import 'login_screen.dart';
import 'upload_song_screen.dart';
import 'song_library_screen.dart';
import 'favorites_screen.dart';

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
  
  Widget buildMenuCard({
  required String title,
  required String subtitle,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return Card(
    color: const Color(0xFF002B12),

    elevation: 10,

    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(20),
    ),

    child: ListTile(
      contentPadding:
          const EdgeInsets.all(16),

      leading: Icon(
        icon,
        color: const Color(
          0xFF23D160,
        ),
        size: 32,
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontWeight:
              FontWeight.bold,
        ),
      ),

      subtitle: Text(
        subtitle,
      ),

      trailing: const Icon(
        Icons.arrow_forward_ios,
      ),

      onTap: onTap,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music App"),
      ),

      body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(24),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const SizedBox(height: 20),

        const Text(
          "🎵 Music App",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          "Listen to your favorite music",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),

        const SizedBox(height: 40),

        buildMenuCard(
          title: "Music Library",
          subtitle: "Browse all songs",
          icon: Icons.library_music,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const SongLibraryScreen(),
              ),
            );
          },
        ),

        const SizedBox(height: 15),

        buildMenuCard(
          title: "Favorite Songs",
          subtitle: "Your liked music",
          icon: Icons.favorite,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const FavoritesScreen(),
              ),
            );
          },
        ),

        if (isAdmin) ...[

          const SizedBox(height: 15),

          buildMenuCard(
            title: "Upload Song",
            subtitle: "Admin only",
            icon: Icons.upload_file,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const UploadSongScreen(),
                ),
              );
            },
          ),
        ],

        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,

          child: ElevatedButton.icon(
            onPressed: logout,

            icon: const Icon(
              Icons.logout,
            ),

            label: const Text(
              "Logout",
            ),

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(
                0xFF23D160,
              ),

              foregroundColor:
                  Colors.black,

              padding:
                  const EdgeInsets.all(
                16,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),
    );
  }
}
