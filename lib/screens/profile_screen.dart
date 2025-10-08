import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String email;
  final String phone;

  const ProfileScreen({
    Key? key,
    required this.username,
    required this.email,
    required this.phone,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  String? _profileImagePath;
  late AnimationController _animController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero)
        .animate(_animController);
    Future.delayed(const Duration(milliseconds: 150), () => _animController.forward());
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = prefs.getString('profile_image');
    });
  }

  Future<void> _pick(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', picked.path);
      setState(() {
        _profileImagePath = picked.path;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile picture updated!')));
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Route _slideRoute(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(opacity: animation, child: child));
        },
      );

  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.value == ThemeMode.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final initials = widget.username.isNotEmpty
        ? widget.username
            .split(" ")
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
        : "U";

    Widget avatar = _profileImagePath != null &&
            File(_profileImagePath!).existsSync()
        ? CircleAvatar(
            radius: 55,
            backgroundImage: FileImage(File(_profileImagePath!)),
          )
        : CircleAvatar(
            radius: 55,
            backgroundColor: isDark ? Colors.blueGrey : Colors.blue[200],
            child: Text(
              initials,
              style: const TextStyle(
                  color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: isDark ? Colors.black87 : Colors.blueAccent,
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Container(
            color: isDark ? Colors.black : Colors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      avatar,
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: GestureDetector(
                          onTap: _showImageOptions,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white10 : Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.edit,
                                color: isDark ? Colors.blue[200] : Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.person, color: textColor),
                    title: Text(widget.username,
                        style: TextStyle(color: textColor, fontSize: 18)),
                  ),
                  ListTile(
                    leading: Icon(Icons.email, color: textColor),
                    title: Text(widget.email, style: TextStyle(color: textColor)),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, color: textColor),
                    title: Text(widget.phone, style: TextStyle(color: textColor)),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.settings,
                        color: isDark ? Colors.lightBlueAccent : Colors.blue),
                    title:
                        Text('Settings', style: TextStyle(color: textColor)),
                    onTap: () {
                      Navigator.of(context)
                          .push(_slideRoute(const SettingsScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info,
                        color: isDark ? Colors.cyanAccent : Colors.blueAccent),
                    title: Text('About', style: TextStyle(color: textColor)),
                    onTap: () {
                      Navigator.of(context)
                          .push(_slideRoute(const AboutScreen()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title:
                        Text('Logout', style: TextStyle(color: textColor)),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "AQUALENS v1.0.0\nFish identification made simpler 🐠",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
