import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String hostName = 'http://192.168.0.181:5000';

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

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Failed to post data: $error');
  }
}

Future<dynamic> makeGETRequest(String endpoint) async {
  String url = '$hostName/api/android$endpoint';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: await _getRequestHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Failed to fetch data: $error');
  }
}