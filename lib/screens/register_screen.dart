import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/db_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero).animate(_animController);
    Future.delayed(const Duration(milliseconds: 150), () => _animController.forward());
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      User newUser = User(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
      );

      try {
        int id = await DBService().insertUser(newUser);
        if (id > 0) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', _nameController.text);
          await prefs.setString('email', _emailController.text);
          await prefs.setString('phone', _phoneController.text);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User registered successfully!')));
          Navigator.of(context).pop(); // back to login
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration failed!')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register'), centerTitle: true),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (v) => v!.isEmpty ? 'Please enter your name' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? 'Please enter your email' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Please enter your phone number' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true,
                    validator: (v) => v!.length < 6 ? 'Password too short' : null),
                  const SizedBox(height: 24),
                  ElevatedButton(onPressed: _register, child: const Text('Register'), style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity,50))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
