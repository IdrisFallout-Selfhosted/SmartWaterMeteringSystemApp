import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

String hostName = 'https://water.waithakasam.com';

Future<Map<String, String>> _getRequestHeaders() async {
  // Initialize headers with default Content-Type
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // Read accessToken and meterNumber from shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');
  String? meterNumber = prefs.getString('meterNumber');

  // If accessToken exists, append it to the authorization header
  if (accessToken != null && accessToken.isNotEmpty) {
    headers['Authorization'] = 'Bearer $accessToken';
  }

  // If meterNumber exists, append it to the custom header
  if (meterNumber != null && meterNumber.isNotEmpty) {
    headers['X-Meter-Number'] = meterNumber;
  }

  return headers;
}

Future<dynamic> makePostRequest(
    Map<String, dynamic> postData, String endpoint) async {
  String url = '$hostName/api/android$endpoint';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: await _getRequestHeaders(),
      body: jsonEncode(postData),
    );

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      showToast(responseBody['message']);
      return responseBody;
    } else {
      String message = responseBody['message'];
      showToast(message);
      throw Exception(message);
    }
  } catch (error) {
    // showToast('Failed to post data: $error');
    throw Exception('$error');
  }
}

Future<dynamic> makeGETRequest(String endpoint) async {
  String url = '$hostName/api/android$endpoint';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: await _getRequestHeaders(),
    );

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // showToast(responseBody['message']);
      return responseBody;
    } else {
      showToast(responseBody['message']);
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (error) {
    showToast('Failed to fetch data: $error');
    throw Exception('Failed to fetch data: $error');
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black.withOpacity(0.7),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
