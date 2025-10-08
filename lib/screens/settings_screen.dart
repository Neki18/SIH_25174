import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/db_service.dart';
import '../models/user.dart';
import 'login_screen.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  final _db = DBService();
  User? _user;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _curPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();

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
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      _user = await _db.getUserByEmail(email);
      if (_user != null) {
        _nameCtrl.text = _user!.name;
        _emailCtrl.text = _user!.email;
      }
      setState(() {});
    }
  }

  Future<void> _saveProfileChanges() async {
    if (_user != null) {
      _user!.name = _nameCtrl.text;
      _user!.email = _emailCtrl.text;
      await _db.updateUser(_user!);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _user!.name);
      await prefs.setString('email', _user!.email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully!')));
    }
  }

  Future<void> _changePassword() async {
    if (_user != null && _curPassCtrl.text == _user!.password && _newPassCtrl.text.isNotEmpty) {
      _user!.password = _newPassCtrl.text;
      await _db.updateUser(_user!);
      _curPassCtrl.clear();
      _newPassCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect current password or empty new password')));
    }
  }

  Future<void> _deleteHistory() async {
    await _db.clearAllHistory();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All history deleted.')));
  }

  Future<void> _uploadHistory() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload to cloud coming soon.')));
  }

  Future<void> _deleteAccount() async {
    if (_user == null) return;
    final confirm = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      title: const Text("Delete Account?"),
      content: const Text("Do you really want to delete account? All your data can be lost by this!"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
      ],
    ));
    if (confirm == true) {
      await _db.deleteUser(_user!.id!);
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.value == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings ⚙️'), centerTitle: true),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage(isDark ? 'assets/images/ocean_bg_dark.jpg' : 'assets/images/ocean_bg.jpg'), fit: BoxFit.cover)),
            child: ListView(padding: const EdgeInsets.all(16), children: [
              _card(
                title: 'Edit Profile',
                icon: Icons.edit,
                children: [
                  TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
                  const SizedBox(height: 8),
                  TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _saveProfileChanges, child: const Text('Save Changes')),
                ],
              ),
              _card(
                title: 'Change Password',
                icon: Icons.lock,
                children: [
                  TextField(controller: _curPassCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Current Password')),
                  const SizedBox(height: 8),
                  TextField(controller: _newPassCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'New Password')),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _changePassword, child: const Text('Save Password')),
                ],
              ),
              _card(
                title: 'Delete History',
                icon: Icons.delete_forever,
                children: [
                  ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), onPressed: _deleteHistory, child: const Text('Delete All History')),
                ],
              ),
              _card(
                title: 'Upload History to Cloud',
                icon: Icons.cloud_upload,
                children: [ElevatedButton(onPressed: _uploadHistory, child: const Text('Upload Now'))],
              ),
              _card(
                title: 'Delete Account',
                icon: Icons.warning_amber_rounded,
                children: [ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), onPressed: _deleteAccount, child: const Text('Delete Account'))],
              ),
              _card(
                title: 'App Appearance',
                icon: Icons.brightness_6,
                children: [
                  FutureBuilder<bool>(
                    future: SharedPreferences.getInstance().then((p) => p.getBool('darkMode') ?? false),
                    builder: (context, snap) {
                      final val = snap.data ?? (isDark);
                      return SwitchListTile(
                        title: const Text('Dark Mode 🌙'),
                        subtitle: const Text('Toggle between light and dark theme'),
                        value: val,
                        onChanged: (value) async {
                          final prefs = await SharedPreferences.getInstance();
                          themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                          await prefs.setBool('darkMode', value);
                          setState(() {});
                        },
                      );
                    },
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _card({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        childrenPadding: const EdgeInsets.all(12),
        children: children,
      ),
    );
  }
}
