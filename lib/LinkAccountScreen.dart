import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwatermeteringsystemapp/shared_functions.dart';

class LinkAccountScreen extends StatefulWidget {
  const LinkAccountScreen({Key? key}) : super(key: key);

  @override
  _LinkAccountScreenState createState() => _LinkAccountScreenState();
}

class _LinkAccountScreenState extends State<LinkAccountScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _linkAccount() async {
    final String email = _emailController.text;

    try {
      // Get meter number from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? meterNumber = prefs.getString('meterNumber');

      // Check if meter number is null or empty
      if (meterNumber == null || meterNumber.isEmpty) {
        throw Exception('Meter number not found in shared preferences');
      }

      // Make post request with email and meter number
      final response = await makePostRequest(
        {'email': email, 'meterNumber': meterNumber},
        '/linkaccount',
      );

      // After sending the email, you might want to navigate back or to another screen
      // For simplicity, let's just navigate back to the previous screen
      Navigator.pop(context);
    } catch (error) {
      // Handle error
      print('Error linking account: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Link Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Enter your email to link your account:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _linkAccount,
              child: Text(
                'Link Account',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Color(0xFFED9E2E); // Change button color when pressed
                  }
                  return Color(0xFF4C337B); // Default button color
                }),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
