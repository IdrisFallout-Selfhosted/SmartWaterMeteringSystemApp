import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartwatermeteringsystemapp/shared_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenRechargeSection extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Token Recharge',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Amount (Ksh)',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _confirmPurchase(context),
            child: Text('Purchase'),
          ),
        ],
      ),
    );
  }

  void _confirmPurchase(BuildContext context) async {
    final amount = amountController.text;
    final paybill = '222953'; // Default paybill

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final meterNumber = prefs.getString('meterNumber') ?? '';

    final tokenAmount = int.parse(amount) / 22;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Purchase'),
          content: Text(
            'Are you sure you want to purchase ${tokenAmount.toStringAsFixed(2)} token units worth Ksh $amount for the meter account $meterNumber?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close current dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close current dialog
                _performPurchase(context, amount, paybill, meterNumber,
                    tokenAmount.toStringAsFixed(2));
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _performPurchase(BuildContext context, String amount, String paybill,
      String meterNumber, String formattedTokenAmount) async {
    // Call API to perform purchase
    final postData = {
      'meterNumber': meterNumber,
      'amount': amount,
      'tokenAmount': formattedTokenAmount, // Use formatted token amount
      'paybill': paybill,
    };

    try {
      final response = await makePostRequest(postData, '/recharge');

      if (response['responseType'] == 'success') {
        // Show success message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Purchase successful.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close success dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        // Clear amount controller
        amountController.clear();
      } else {
        throw Exception('Failed to perform purchase');
      }
    } catch (error) {
      // Show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content:
                Text('Failed to perform purchase. Please try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close error dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
