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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = []; // Use Product model
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHomeScreenData();
  }

  // Fetch Home Data
  Future<void> _loadHomeScreenData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final homeData = HomeData.fromJson(data);
        setState(() {
          _products = homeData.products; // Assign products data
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load data')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // OTP Send Function
  Future<void> sendOtp(String phone, String deviceId) async {
    final response = await http.post(
      Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mobileNumber': phone, 'deviceId': deviceId}),
    );

    if (response.statusCode == 200) {
      // Handle success, maybe navigate to OTP verification page
    } else {
      // Handle failure
      print('Error: ${response.body}');
    }
  }

  // OTP Verification Function
  Future<void> verifyOtp(String phone, String otp, String deviceId, String userId) async {
    final response = await http.post(
      Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp/verification'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'otp': otp, 'deviceId': deviceId, 'userId': userId}),
    );

    if (response.statusCode == 200) {
      // Handle success
    } else {
      print('Error: ${response.body}');
    }
  }

  // Register User
  Future<void> registerUser(String email, String password, int referralCode, String userId) async {
    final response = await http.post(
      Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/email/referral'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'referralCode': referralCode, 'userId': userId}),
    );

    if (response.statusCode == 200) {
      // Handle registration success
    } else {
      print('Error: ${response.body}');
    }
  }

  // Add Device Info
  Future<void> addDevice(String deviceId, String deviceType, String deviceName, String deviceOS) async {
    final response = await http.post(
      Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/device/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'deviceId': deviceId, 'deviceType': deviceType, 'deviceName': deviceName, 'deviceOSVersion': deviceOS}),
    );

    if (response.statusCode == 200) {
      // Handle success
    } else {
      print('Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Home',
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return _buildProductCard(product);
              },
            ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              product.icon,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              product.subLabel,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: Text(
              'Offer: ${product.offer}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String icon;
  final String offer;
  final String label;
  final String subLabel;

  Product({
    required this.icon,
    required this.offer,
    required this.label,
    required this.subLabel,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      icon: json['icon'],
      offer: json['offer'],
      label: json['label'],
      subLabel: json['SubLabel'] ?? json['Sublabel'] ?? '',
    );
  }
}

class HomeData {
  final List<Product> products;

  HomeData({required this.products});

  factory HomeData.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final products = (data['products'] as List).map((e) => Product.fromJson(e)).toList();
    return HomeData(products: products);
  }
}