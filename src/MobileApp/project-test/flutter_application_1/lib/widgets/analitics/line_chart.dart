// main.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/fl_chart.dart' as fl_Chart;
import 'package:intl/intl.dart';
import 'package:flutter_application_1/classes/receipt_class.dart';


class AnimatedLineChartWidget extends StatelessWidget {
  final List<Receipt> data;

  AnimatedLineChartWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = _getSpotsFromData(data);

    return Container(
      padding: const EdgeInsets.all(50),
      width: double.infinity,
      height: double.infinity, // Adjust height as necessary
      child: fl_Chart.LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              dotData: FlDotData(show: false),
              color: Colors.red,
            ),
          ],
          borderData: FlBorderData(
              border: const Border(bottom: BorderSide(), left: BorderSide())),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return Text(_formatDateFromMilliseconds(value));
              },
            )),
            leftTitles: AxisTitles(sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return Text('${value.toStringAsFixed(2)}');
              },
            )),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getSpotsFromData(List<Receipt> data) {
    List<FlSpot> spots = [];
    Map<DateTime, double> monthlyTotals = {};

    for (var receipt in data) {
      DateTime month = DateTime(receipt.date.year, receipt.date.month);
      monthlyTotals.update(
          month, (value) => value + receipt.total,
          ifAbsent: () => receipt.total);
    }

    var sortedKeys = monthlyTotals.keys.toList()..sort();
    for (var month in sortedKeys) {
      double total = monthlyTotals[month]!;
      spots.add(FlSpot(month.millisecondsSinceEpoch.toDouble(), total));
    }

    return spots;
  }

  String _formatDateFromMilliseconds(double value) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    return DateFormat('yyyy-MM').format(date);
  }
}