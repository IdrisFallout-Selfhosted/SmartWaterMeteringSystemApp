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
    double screenHeight = MediaQuery.of(context).size.height;
    double graphHeight = screenHeight * 0.7;

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
            ? Container(
          height: graphHeight,
          padding: EdgeInsets.only(right: 16), // Add padding to the right of the graph
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _calculateMaxY(),
              titlesData: FlTitlesData(
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, value) => const TextStyle(color: Colors.black),
                  getTitles: (value) {
                    if (value.toInt() >= 0 && value.toInt() < _dataPoints.length) {
                      final dataPoint = _dataPoints[value.toInt()];
                      // Display every nth date to avoid cluttering
                      if (value.toInt() % 2 == 0) {
                        return dataPoint['date'];
                      } else {
                        return '';
                      }
                    }
                    return '';
                  },
                  rotateAngle: -45, // Rotate labels to prevent overlapping
                  margin: 8,
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, value) => const TextStyle(color: Colors.black),
                ),
              ),
              gridData: FlGridData(
                show: true, // Show grid lines
                horizontalInterval: 1, // Interval between horizontal grid lines
                verticalInterval: 1, // Interval between vertical grid lines
                checkToShowHorizontalLine: (value) => value % 1 == 0, // Custom condition to show horizontal grid lines
                checkToShowVerticalLine: (value) => value % 1 == 0, // Custom condition to show vertical grid lines
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey, // Color of horizontal grid lines
                  strokeWidth: 0.5, // Width of horizontal grid lines
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.grey, // Color of vertical grid lines
                  strokeWidth: 0.5, // Width of vertical grid lines
                ),
              ),
              borderData: FlBorderData(show: true),
              barGroups: _buildBarGroups(),
            ),
          ),
        )
            : SizedBox(), // Show a message if there are no data points
      ],
    );
  }

  // Calculate the maximum y value for setting the maximum range of the chart
  double _calculateMaxY() {
    double maxVolume = 0;
    for (var dataPoint in _dataPoints) {
      if (dataPoint['volume'] > maxVolume) {
        maxVolume = dataPoint['volume'];
      }
    }
    return maxVolume * 1.2; // Add some padding to the maximum y value
  }

  // Build Bar Chart Groups from data points
  List<BarChartGroupData> _buildBarGroups() {
    return _dataPoints
        .asMap()
        .entries
        .map(
          (entry) => BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            y: entry.value['volume'].toDouble(),
            colors: [Color(0xFF4C337B)],
          ),
        ],
      ),
    )
        .toList();
  }
}
