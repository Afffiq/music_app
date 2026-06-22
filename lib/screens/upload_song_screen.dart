import 'dart:math';

import 'package:flutter/material.dart';

import '../services/song_service.dart';

class UploadSongScreen extends StatefulWidget {
  const UploadSongScreen({super.key});

  @override
  State<UploadSongScreen> createState() =>
      _UploadSongScreenState();
}

class _UploadSongScreenState
    extends State<UploadSongScreen> {

  bool isUploading = false;

  final songService =
      SongService();

  final titleController =
      TextEditingController();

  final artistController =
      TextEditingController();

  final audioUrlController =
      TextEditingController();

  Future<void> uploadSong() async {

    if (titleController.text.trim().isEmpty ||
        artistController.text.trim().isEmpty ||
        audioUrlController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields",
          ),
        ),
      );

      return;
    }

    try {

      setState(() {
        isUploading = true;
      });

      int coverIndex =
          Random().nextInt(10) + 1;

      await songService.addSong(
        title: titleController.text.trim(),
        artist: artistController.text.trim(),
        assetPath: audioUrlController.text.trim(),
        coverIndex: coverIndex,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Song added successfully",
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      setState(() {
        isUploading = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upload Song",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Song Title",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: artistController,
              decoration: const InputDecoration(
                labelText: "Artist",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: audioUrlController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "GitHub Audio URL",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed:
                  isUploading
                      ? null
                      : uploadSong,
              child: Text(
                isUploading
                    ? "Adding..."
                    : "Add Song",
              ),
            ),

          ],
        ),
      ),
    );
  }
}