import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding

class ApiService {
  final String baseUrl = 'http://devapiv4.dealsdray.com/api/v2';

  /// Add Device Info
  Future<http.Response> addDevice(String deviceId, String deviceType) async {
    final url = Uri.parse('$baseUrl/user/device/add');
    return http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'device_id': deviceId,
        'device_type': deviceType,
      }),
    );
  }

  /// Send OTP to phone number
  Future<http.Response> sendOTP(String phoneNumber) async {
    final url = Uri.parse('$baseUrl/user/otp');
    return http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phoneNumber}),
    );
  }

  /// Verify OTP with phone number
  Future<http.Response> verifyOTP(String phoneNumber, String otp) async {
    final url = Uri.parse('$baseUrl/user/otp/verification');
    return http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': phoneNumber,
        'otp': otp,
      }),
    );
  }

  /// Register user using email and referral
  Future<http.Response> registerUser(
    String phoneNumber,
    String email,
    String password,
    String referralCode,
  ) async {
    final url = Uri.parse('$baseUrl/user/email/referral');
    return http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': phoneNumber,
        'email': email,
        'password': password,
        'referral_code': referralCode,
      }),
    );
  }

  /// Fetch home data
  Future<http.Response> getHomeData() async {
    final url = Uri.parse('$baseUrl/user/home/withoutPrice');
    return http.get(url);
  }
}
