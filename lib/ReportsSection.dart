import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smartwatermeteringsystemapp/shared_functions.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsSection extends StatefulWidget {
  @override
  _ReportsSectionState createState() => _ReportsSectionState();
}

class _ReportsSectionState extends State<ReportsSection> {
  List<Map<String, dynamic>> _dataPoints = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final responseData = await makeGETRequest('/waterUsage');

      if (responseData['responseType'] == 'success') {
        setState(() {
          _dataPoints = List<Map<String, dynamic>>.from(responseData['message']);
        });
      } else {
        throw Exception('Failed to fetch data: ${responseData['message']}');
      }
    } catch (error) {
      print('Error: $error');
      // Handle error, e.g., show an error message to the user
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator() // Show loading indicator while fetching data
        : Column(
      children: [
        Text(
          'Water Usage Report',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        _dataPoints.isNotEmpty
            ? Expanded(
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: _dataPoints
                      .asMap()
                      .entries
                      .map((entry) =>
                      FlSpot(entry.key.toDouble(), entry.value['volume'].toDouble()))
                      .toList(),
                  isCurved: true,
                  colors: [Color(0xFF4C337B)],
                  barWidth: 4,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: false,
                    colors: [Color(0xFF4C337B).withOpacity(0.3)],
                  ),
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, value) => const TextStyle(color: Colors.black),
                  getTitles: (value) {
                    if (value.toInt() >= 0 && value.toInt() < _dataPoints.length) {
                      final dataPoint = _dataPoints[value.toInt()];
                      return dataPoint['date'];
                    }
                    return '';
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, value) => const TextStyle(color: Colors.black),
                ),
              ),
              borderData: FlBorderData(show: true),
            ),
          ),
        )
            : SizedBox(), // Show a message if there are no data points
      ],
    );
  }
}
