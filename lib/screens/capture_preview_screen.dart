// lib/screens/capture_preview_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'fish_details_screen.dart';

class CapturePreviewScreen extends StatefulWidget {
  final File initialImage;
  const CapturePreviewScreen({Key? key, required this.initialImage})
    : super(key: key);

  @override
  State<CapturePreviewScreen> createState() => _CapturePreviewScreenState();
}

class _CapturePreviewScreenState extends State<CapturePreviewScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _image = widget.initialImage;
  }

  Future<void> _replaceImage(ImageSource source) async {
    try {
      setState(() => _isProcessing = true);
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _image = File(picked.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _usePhoto() {
    if (_image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FishDetailsScreen(initialImage: _image!, image: _image!),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No image selected!')));
    }
  }

  void _clearSelection() {
    // simply go back to Home without returning an image
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview'), centerTitle: true),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: _image != null
                          ? Image.file(_image!, fit: BoxFit.contain)
                          : const Text('No image selected'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Retake / Camera
                        ElevatedButton.icon(
                          onPressed: () => _replaceImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Retake'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 44),
                          ),
                        ),

                        // Replace from gallery
                        ElevatedButton.icon(
                          onPressed: () => _replaceImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Replace'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 44),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _usePhoto,
                            child: const Text('Use Photo'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _clearSelection,
                          child: const Icon(Icons.clear),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            minimumSize: const Size(56, 48),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
