import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'capture_preview_screen.dart';
import 'gallery_screen.dart';
import 'profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? username;
  String? email;
  String? phone;

  late AnimationController _animController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero).animate(_animController);
    Future.delayed(const Duration(milliseconds: 120), () => _animController.forward());
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      email = prefs.getString('email');
      phone = prefs.getString('phone');
    });
  }

  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Take Photo'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); }),
          ListTile(leading: const Icon(Icons.photo_library), title: const Text('Upload from Gallery'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); }),
        ]),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() { _image = File(pickedFile.path); });
      Navigator.of(context).push(_slideRoute(CapturePreviewScreen(initialImage: _image!)));
    }
  }

  Route _slideRoute(Widget page) => PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final tween = Tween(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
      return SlideTransition(position: animation.drive(tween), child: FadeTransition(opacity: animation, child: child));
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fish MVP Home'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.photo_library), tooltip: 'My Captures', onPressed: () { Navigator.of(context).push(_slideRoute(const GalleryScreen())); }),
          IconButton(icon: const Icon(Icons.person), tooltip: 'Profile', onPressed: () {
              if (username != null && email != null && phone != null) {
                Navigator.of(context).push(_slideRoute(ProfileScreen(username: username!, email: email!, phone: phone!)));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User data not found. Please log in again.')));
              }
            }),
        ],
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Welcome to Fish MVP!', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _showImageSourceDialog, child: const Text('Capture Fish'), style: ElevatedButton.styleFrom(minimumSize: const Size(200,50))),
            ]),
          ),
        ),
      ),
    );
  }
}
