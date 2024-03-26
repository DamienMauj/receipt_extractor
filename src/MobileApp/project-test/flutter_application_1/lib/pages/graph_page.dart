// main.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/pages/camera_page.dart';
import 'package:flutter_application_1/pages/graph_page.dart';
import 'package:flutter_application_1/pages/home_page.dart';


class GraphPage extends StatefulWidget {
  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {

  // Generate some dummy data for the cahrt
  // This will be used to draw the red line
  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  // This will be used to draw the orange line
  final List<FlSpot> dummyData2 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  // This will be used to draw the blue line
  final List<FlSpot> dummyData3 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graph Page'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(50),
                width: double.infinity,
                child: LineChart(
                  LineChartData(
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      // The red line
                      LineChartBarData(
                        spots: dummyData1,
                        isCurved: true,
                        barWidth: 3,
                        color: Colors.indigo,
                      ),
                      // The orange line
                      LineChartBarData(
                        spots: dummyData2,
                        isCurved: true,
                        barWidth: 3,
                        color: Colors.red,
                      ),
                      // The blue line
                      LineChartBarData(
                        spots: dummyData3,
                        isCurved: false,
                        barWidth: 3,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // First row of buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {}, // Define what each button should do
                  child: Text('Button 1'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Button 2'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Button 3'),
                ),
              ],
            ),
            // Second row of buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  },
                  child: Text('Home'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraPage()),
                    );
                  },
                  child: Text('camera'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GraphPage()),
                    );
                  },
                  child: Text('graph'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}