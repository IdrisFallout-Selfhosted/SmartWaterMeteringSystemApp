import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwatermeteringsystemapp/shared_functions.dart'; // Assuming you have defined makePostRequest function here
import 'home_screen.dart'; // Import HomeScreen from home_screen.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF4C337B), // Changed primaryColor to #4C337B
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4C337B), // Changed appBar background color to #4C337B
        ),
      ),
      home: const MyHomePage(title: 'Login'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController meterNumberController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    void _login() async {
      final meterNumber = meterNumberController.text;
      final password = passwordController.text;

      if (meterNumber.isEmpty || password.isEmpty) {
        // Display prompt if the meter number or password is empty
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Meter number and password are required.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      try {
        final response = await makePostRequest(
            {'meterNumber': meterNumber, 'password': password}, '/login');

        String? token = response['token'];
        if (token != null) {
          // Save token securely using SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('meterNumber', meterNumber);
          await prefs.setString('accessToken', token);
        } else {
          // Handle case where token is null
          throw Exception('Token is null');
        }

        meterNumberController.clear();
        passwordController.clear();

        if (response != null && response['responseType'] == 'success') {
          // Navigate to the next screen if login is successful
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else {
          // Display error message if login is unsuccessful
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(response['message']),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (error) {
        // Display error message if there's an error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Login Failed'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4C337B), // Changed text color to #4C337B
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: meterNumberController,
            decoration: InputDecoration(
              labelText: 'Meter No.',
              prefixIcon: Icon(Icons.account_circle),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _login, // Call _login function when button is pressed
            child: Text(
              'Login',
              style: TextStyle(
                  color: Colors.white), // Change button text color to white
            ),
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Color(
                      0xFFED9E2E); // Change button color to #ED9E2E when pressed
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
    );
  }
}
