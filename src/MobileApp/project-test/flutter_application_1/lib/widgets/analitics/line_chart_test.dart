// main.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as fl_Chart;
import 'package:fl_animated_linechart/fl_animated_linechart.dart' as fl_a_Chart;
import 'package:intl/intl.dart';
import 'package:flutter_application_1/classes/receipt_class.dart';


class AnimatedLineChartWidget extends StatelessWidget {
  final List<Receipt> data;

  AnimatedLineChartWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<DateTime, double> monthlyTotals = _groupByMonth(data);

    // order the data by date
    Map<DateTime, double> sortedMonthlyTotals = order_by_date(monthlyTotals);

    List<DateTime> date_axis = _extractDates(monthlyTotals);

    fl_a_Chart.LineChart lineChart = fl_a_Chart.LineChart.fromDateTimeMaps(
      [sortedMonthlyTotals],
      [Colors.red],
      ['Rs'],
      tapTextFontWeight: FontWeight.w400,
    );



    List<String> _getHorizontalTitles(List<DateTime> dates) {
      List<String> titles = [];
      for (var date in dates) {
        String formattedDate = DateFormat('MMM yyyy').format(date);
        titles.add(formattedDate);
      }
      return titles;
    }

    return  Container(
      padding: const EdgeInsets.all(50),
      width: double.infinity,
      height: double.infinity, 
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: 
                fl_a_Chart.AnimatedLineChart(
                  lineChart,
                  gridColor: Colors.grey,
                  toolTipColor: Colors.blue,
                  // verticalMarker: [
                  //   DateTime.parse("2024-05-01 00:00:00.00"),
                  //   DateTime.parse("2024-06-01 00:00:00.00")
                  // ],
                  legendsRightLandscapeMode: true,
                  textStyle: TextStyle(fontSize: 10, color: Colors.black54),
                  showMarkerLines: true, 

                ) 
            ),
          ]
      ),
    );
  }

  Map<DateTime, double> _groupByMonth(List<Receipt> receipts) {
    Map<DateTime, double> monthlyTotals = {};
    for (var receipt in receipts) {
      DateTime month = DateTime(receipt.date.year, receipt.date.month);
      monthlyTotals.update(
          month, (value) => value + receipt.total,
          ifAbsent: () => receipt.total);
    }
    return monthlyTotals;
  }

  List<DateTime> _extractDates(Map<DateTime, double> monthlyTotals) {
    return monthlyTotals.keys.toList();
  }

  Map<DateTime, double> order_by_date(Map<DateTime, double> monthlyTotals) {
    Map<DateTime, double> sortedMonthlyTotals = {};
    var sortedKeys = monthlyTotals.keys.toList()..sort();
    for (var key in sortedKeys) {
      sortedMonthlyTotals[key] = monthlyTotals[key]!;
    }
    return sortedMonthlyTotals;

  }

  List<fl_Chart.FlSpot> _getSpotsFromData(List<Receipt> data) {
    List<fl_Chart.FlSpot> spots = [];
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
      spots.add(fl_Chart.FlSpot(month.millisecondsSinceEpoch.toDouble(), total));
    }

    return spots;
  }

  String _formatDateFromMilliseconds(double value) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    return DateFormat('yyyy-MM').format(date);
  }
}