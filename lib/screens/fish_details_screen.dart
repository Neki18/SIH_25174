// lib/screens/fish_details_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';

class FishDetailsScreen extends StatefulWidget {
  final File initialImage;
  const FishDetailsScreen({Key? key, required this.initialImage}) : super(key: key);

  @override
  State<FishDetailsScreen> createState() => _FishDetailsScreenState();
}

class _FishDetailsScreenState extends State<FishDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  void _saveDetails() {
    if (_formKey.currentState!.validate()) {
      // TODO: Send details + image to backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fish details saved successfully!')),
      );

      Navigator.pop(context); // or navigate somewhere else
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fish Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.file(
              widget.initialImage,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Fish Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter fish name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _sizeController,
                    decoration: const InputDecoration(
                      labelText: 'Size (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notes / Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveDetails,
                      child: const Text('Save'),
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
