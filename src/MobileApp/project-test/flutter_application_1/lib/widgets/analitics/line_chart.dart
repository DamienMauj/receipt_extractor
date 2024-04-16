import 'package:flutter/material.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart' as fl_a_Chart;
import 'package:intl/intl.dart';
import 'package:flutter_application_1/classes/receipt_class.dart';

class AnimatedLineChartWidget extends StatefulWidget {
  final List<Receipt> data;

  AnimatedLineChartWidget({Key? key, required this.data}) : super(key: key);

  @override
  _AnimatedLineChartWidgetState createState() => _AnimatedLineChartWidgetState();
}

class _AnimatedLineChartWidgetState extends State<AnimatedLineChartWidget> {
  late DateTime displayedMonth;

  @override
  void initState() {
    super.initState();
    displayedMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    List<Receipt> filteredData = _filterForMonth(widget.data, displayedMonth);

    Widget content;
    if (filteredData.isEmpty) {
      content = Center(child: Text("No data for this month"));
    } else {
      Map<DateTime, double> dailyTotals = _groupByDay(filteredData);
      Map<DateTime, double> sortedDailyTotals = order_by_date(dailyTotals);

      fl_a_Chart.LineChart lineChart = fl_a_Chart.LineChart.fromDateTimeMaps(
        [sortedDailyTotals],
        [Colors.red],
        ['Rs'],
        tapTextFontWeight: FontWeight.w400,
      );

      content = Container(
        padding: const EdgeInsets.all(50),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: fl_a_Chart.AnimatedLineChart(
                lineChart,
                key: ValueKey('${displayedMonth.year}-${displayedMonth.month}'),
                gridColor: Colors.grey,
                toolTipColor: Colors.blue,
                legendsRightLandscapeMode: true,
                textStyle: TextStyle(fontSize: 10, color: Colors.black54),
                showMarkerLines: true,
              ),
            ),
          ],
        ),
      );
    }

    DateTime now = DateTime.now();
    bool isCurrentOrFutureMonth = displayedMonth.year > now.year ||
                                 (displayedMonth.year == now.year && displayedMonth.month >= now.month);

    return Column(
      key: const Key('Line Chart'),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  displayedMonth = DateTime(displayedMonth.year, displayedMonth.month - 1);
                });
              },
            ),
            Text(DateFormat('MMM yyyy').format(displayedMonth)),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: isCurrentOrFutureMonth ? null : () {
                setState(() {
                  displayedMonth = DateTime(displayedMonth.year, displayedMonth.month + 1);
                });
              },
            ),
          ],
        ),
        Expanded(child: content),
      ],
    );
  }

  List<Receipt> _filterForMonth(List<Receipt> receipts, DateTime month) {
    return receipts.where((receipt) {
      return receipt.date.year == month.year && receipt.date.month == month.month;
    }).toList();
  }

  Map<DateTime, double> _groupByDay(List<Receipt> receipts) {
    Map<DateTime, double> dailyTotals = {};
    for (var receipt in receipts) {
      DateTime day = DateTime(receipt.date.year, receipt.date.month, receipt.date.day);
      dailyTotals.update(
          day, (value) => value + receipt.total,
          ifAbsent: () => receipt.total);
    }
    return dailyTotals;
  }

  Map<DateTime, double> order_by_date(Map<DateTime, double> monthlyTotals) {
    Map<DateTime, double> sortedMonthlyTotals = {};
    var sortedKeys = monthlyTotals.keys.toList()..sort();
    for (var key in sortedKeys) {
      sortedMonthlyTotals[key] = monthlyTotals[key]!;
    }
    return sortedMonthlyTotals;
  }

  List<DateTime> _extractDates(Map<DateTime, double> monthlyTotals) {
    return monthlyTotals.keys.toList();
  }
}
