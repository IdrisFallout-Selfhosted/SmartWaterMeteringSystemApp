import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';  // Import the package

class AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'About Us',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'This project report is submitted in partial fulfillment for the requirement of award of Bachelor of Science in Computer Science of Machakos University.',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/logo.png', // Assuming you have a logo image
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'December, 2024',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(width: 5),
              Text(
                '|',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(width: 5),
              TextButton(
                onPressed: _launchURL, // Call function to launch URL
                child: Text(
                  'Visit our website',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Copyright © 2024 IdrisFallout. All Rights Reserved.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Function to launch URL
  void _launchURL() async {
    const url = 'https://waithakasam.com'; // Your website URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
