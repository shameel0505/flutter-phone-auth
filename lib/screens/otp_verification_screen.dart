import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pin_code_fields/pin_code_fields.dart'; 


class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String _otp = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 32),
              const Text(
                'OTP Verification',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              Text(
                'We have sent a unique OTP number to your mobile +91-${widget.phoneNumber}', 
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              PinCodeTextField(
                appContext: context,
                length: 4, // OTP length
                onChanged: (value) {
                  setState(() {
                    _otp = value;
                  });
                },
                onCompleted: (value) {
                  setState(() {
                    _otp = value;
                  });
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey,
                  selectedColor: Colors.blue,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter OTP';
                  }
                  if (value.length != 4) {  
                    return 'Invalid OTP';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Show loading indicator
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );

                    try {
                      final response = await http.post(
                        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp/verification'),
                        headers: {'Content-Type': 'application/json'},
                        body: json.encode({
                          "otp": _otp,
                          "deviceId": "62b341aeb0ab5ebe28a758a3",
                          "userId": "62b43547c84bb6dac82e0525"
                        }),
                      );
                      Navigator.of(context).pop(); // hide dialog

                      if (response.statusCode == 200) {
                        // Parse response
                        final responseData = json.decode(response.body);
                        // Navigate to registration or home
                        if (responseData['isNewUser'] == true) {
                          Navigator.pushNamed(context, '/register', arguments: widget.phoneNumber);
                        } else {
                          Navigator.pushNamed(context, '/home');
                        }
                      } else {
                        // Handle error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${response.body}')),
                        );
                      }
                    } catch (error) {
                      Navigator.of(context).pop(); // hide dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $error')),
                      );
                    }
                  }
                },
                child: const Text('VERIFY'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Implement resend OTP functionality (call sendOTP again)
                },
                child: const Text('Resend Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}