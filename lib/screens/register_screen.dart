import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const AppScaffold({required this.title, required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: body,
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final referralCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _userId = "62a833766ec5dafd6780fc85";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Hardcode the userId for registration
    _userId = "62a833766ec5dafd6780fc85";
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    referralCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Register',
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // ... (Your Logo)
              const SizedBox(height: 32),
              const Text(
                "Let's Begin!",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Your Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Basic email validation
                  if (!value.contains('@')) {
                    return 'Invalid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Create Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  // Password validation (you can add more complexity)
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: referralCodeController,
                decoration: const InputDecoration(
                  labelText: 'Referral Code (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final email = emailController.text;
                    final password = passwordController.text;
                    final referralCode = referralCodeController.text;

                    // Show loading indicator
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(child: CircularProgressIndicator());
                        });
                    try {
                      final response = await http.post(
                        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/email/referral'),
                        headers: {'Content-Type': 'application/json'},
                        body: json.encode({
                          "email": email,
                          "password": password,
                          "referralCode": referralCode,
                          "userId": _userId,
                        }),
                      );
                      Navigator.of(context).pop();

                      if (response.statusCode == 201) { // 201 Created for successful registration
                        // Parse response
                        json.decode(response.body);
                        // Navigate to home
                        Navigator.pushNamed(context, '/home');
                      } else {
                        // Handle error, parse JSON and show message
                        final Map<String, dynamic> errorData = json.decode(response.body);
                        String errorMessage = 'Unknown error';

                        if (errorData.containsKey('message')) {
                          errorMessage = errorData['message'];
                        } else if (errorData.containsKey('data')) {
                          final data = errorData['data'];
                          if (data is Map<String, dynamic> && data.containsKey('message')) {
                            errorMessage = data['message'];
                          }
                        }

                        if (errorMessage.toLowerCase().contains('email exists')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage)),
                          );
                        } else {
                          Navigator.pushNamed(context, '/home');
                        }
                      }
                    } catch (error) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $error')),
                      );
                    }
                  }
                },
                child: const Text('Let\'s Begin!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
