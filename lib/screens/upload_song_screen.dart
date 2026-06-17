import 'package:flutter/material.dart';

class UploadSongScreen extends StatefulWidget {
  const UploadSongScreen({super.key});

  @override
  State<UploadSongScreen> createState() =>
      _UploadSongScreenState();
}

class _UploadSongScreenState
    extends State<UploadSongScreen> {

  final titleController =
      TextEditingController();

  final artistController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Song"),
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

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Choose MP3"),
            ),

          ],
        ),
      ),
    );
  }
}