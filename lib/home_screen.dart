// home_screen.dart

import 'package:flutter/material.dart';
import 'package:smartwatermeteringsystemapp/TokenShareSection.dart';
import 'AboutSection.dart';
import 'HomeSection.dart';
import 'ReportsSection.dart';
import 'SettingsSection.dart';
import 'TokenRechargeSection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedOption = 'Home';

  @override
  Widget build(BuildContext context) {
    Widget _getContent() {
      switch (_selectedOption) {
        case 'Reports':
          return ReportsSection();
        case 'Settings':
          return SettingsSection();
        case 'About':
          return AboutSection();
        case 'Token Recharge':
          return TokenRechargeSection();
        case 'Token Share':
          return TokenShareSection();
        default:
          return HomeSection();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedOption),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Machakos Waters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                setState(() {
                  _selectedOption = 'Home';
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Reports'),
              onTap: () {
                setState(() {
                  _selectedOption = 'Reports';
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Token Recharge'),
              onTap: () {
                setState(() {
                  _selectedOption = 'Token Recharge';
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Token Share'),
              onTap: () {
                setState(() {
                  _selectedOption = 'Token Share';
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                setState(() {
                  _selectedOption = 'Settings';
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('About'),
              onTap: () {
                setState(() {
                  _selectedOption = 'About';
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _getContent(),
      ),
    );
  }
}
