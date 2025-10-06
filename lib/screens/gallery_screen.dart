// lib/screens/gallery_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'fish_details_screen.dart'; // Later we’ll create this screen

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // For now, dummy list of images. Later replace with backend data.
  List<File> _images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Captures'),
        centerTitle: true,
      ),
      body: _images.isEmpty
          ? const Center(child: Text('No captures yet'))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final img = _images[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FishDetailsScreen(image: img, initialImage: img,),
                      ),
                    );
                  },
                  child: Image.file(img, fit: BoxFit.cover),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to HomeScreen / capture flow to add new photo
          Navigator.pop(context); // Temporary for testing
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
