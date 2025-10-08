import 'package:flutter/material.dart';
import '../main.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero).animate(_animController);
    Future.delayed(const Duration(milliseconds: 120), () => _animController.forward());
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.value == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('About'), centerTitle: true),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage(isDark ? 'assets/images/ocean_bg_dark.jpg' : 'assets/images/ocean_bg.jpg'), fit: BoxFit.cover)),
            child: ListView(padding: const EdgeInsets.all(16), children: [
              Card(child: ListTile(title: const Text('App Version'), subtitle: const Text('v1.0.0'))),
              const SizedBox(height: 10),
              Card(
                child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  Text('About the App', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('AQUALENS helps fishermen, inspectors, and buyers identify fish species, estimate freshness/health, and estimate volume/weight — all offline on-device.'),
                ])),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  Text('Open Source Licenses', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('This app uses Flutter packages (image_picker, shared_preferences, sqflite). See pubspec.yaml for versions and licenses.'),
                ])),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  Text('Acknowledgments', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('- Oceanic icon set\n- Fish dataset sources (custom / public datasets)\n- Community contributions'),
                ])),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
