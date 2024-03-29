import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartwatermeteringsystemapp/shared_functions.dart';

class TokenShareSection extends StatelessWidget {
  final TextEditingController meterNumberController = TextEditingController();
  final TextEditingController unitsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Token Share',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: meterNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Meter Number',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: unitsController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Units',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _shareTokens(context),
            child: Text('Share'),
          ),
        ],
      ),
    );
  }

  void _shareTokens(BuildContext context) async {
    final meterNumber = meterNumberController.text;
    final units = unitsController.text;

    if (meterNumber.isEmpty || units.isEmpty) {
      _showErrorDialog(context, 'Please fill all fields.');
      return;
    }

    final postData = {
      'meterNumber': meterNumber,
      'units': units,
    };

    try {
      final response = await makePostRequest(postData, '/share');

      if (response['responseType'] == 'success') {
        _showSuccessDialog(context, 'Tokens shared successfully.');
        // Clear input fields
        meterNumberController.clear();
        unitsController.clear();
      } else {
        throw Exception('Failed to share tokens');
      }
    } catch (error) {
      _showErrorDialog(context, '$error');
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
