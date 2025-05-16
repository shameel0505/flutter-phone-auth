import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deals Dray',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Customize your theme
      ),
      initialRoute: '/login', // Start with the login screen
      routes: {
        '/login': (context) => const LoginScreen(),
        '/otp_verification': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final phoneNumber = (args != null && args is String) ? args : '';
          return OtpVerificationScreen(phoneNumber: phoneNumber);
        },
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        // ... other routes
      },
    );
  }
}
