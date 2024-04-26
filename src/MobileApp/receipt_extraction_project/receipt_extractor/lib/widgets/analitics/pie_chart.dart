import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:receipt_extractor/classes/receipt_class.dart';

class BarChartWithSelector extends StatefulWidget {
  final List<Receipt> data;

  BarChartWithSelector({Key? key, required this.data}) : super(key: key);

  @override
  _BarChartWithSelectorState createState() => _BarChartWithSelectorState();
}

class _BarChartWithSelectorState extends State<BarChartWithSelector> {
  late DateTime displayedMonth;

  @override
  void initState() {
    super.initState();
    displayedMonth = widget.data.isNotEmpty
        ? DateTime(widget.data.first.date.year, widget.data.first.date.month)
        : DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    bool isCurrentOrFutureMonth = displayedMonth.year > now.year ||
                                 (displayedMonth.year == now.year && displayedMonth.month >= now.month);

    Widget content;
    if (!_checkIfDataInMonth(displayedMonth, widget.data)) {
      content =  Center(child: Text("No data for this month"));
    } else {
      content = BarChart(
            data: widget.data,
            month: DateFormat('yyyy-MM').format(displayedMonth),
          );
    }
    

    return Column(
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
            Text(DateFormat('yyyy-MM').format(displayedMonth)),
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

  bool _checkIfDataInMonth(DateTime month, List<Receipt> receipts) {
    return receipts.any((receipt) {
      return receipt.date.year == month.year && receipt.date.month == month.month;
    });
  }
}

class BarChart extends StatelessWidget {
  final List<Receipt> data;
  final String? month;

  BarChart({Key? key, required this.data, this.month}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, double>> monthlyTotals = groupByMonth(data);

    double totalMonthAmount = 0;
    if (month != null && monthlyTotals[month] != null) {
      monthlyTotals[month]!.forEach((_, total) {
        totalMonthAmount += total;
      });
    }

    List<PieChartSectionData> barGroups = [];
    if (month != null && monthlyTotals[month] != null) {
      List<MapEntry<String, double>> sortedEntries = monthlyTotals[month]!.entries.toList();

      // Sort entries by total in descending order
      sortedEntries.sort((a, b) => b.value.compareTo(a.value));

      // Reorder the list to alternate large and small
      List<MapEntry<String, double>> reorderedEntries = [];
      int start = 0, end = sortedEntries.length - 1;
      while (start <= end) {
        if (start == end) {
          reorderedEntries.add(sortedEntries[start]);
          break;
        }
        reorderedEntries.add(sortedEntries[start]);
        reorderedEntries.add(sortedEntries[end]);
        start++;
        end--;
      }

      // Generate section data using the reordered entries
      reorderedEntries.forEach((entry) {
        double total = entry.value;
        double percentage = (total / totalMonthAmount) * 100;
        String title = '${entry.key}\n${total.toStringAsFixed(2)}Rs \n(${percentage.toStringAsFixed(1)}%)';
        barGroups.add(PieChartSectionData(
          value: total,
          color: _getLightRandomColor(),
          title: title,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          radius: 100,
          titlePositionPercentageOffset: 1.4,
          badgePositionPercentageOffset: 0.98,
        ));
      });
    }

    return Center(
      child: PieChart(
        key: const Key('Pie Chart'),
        PieChartData(
          centerSpaceRadius: 10,
          borderData: FlBorderData(show: true),
          sections: barGroups,
        ),
      ),
    );
  }

  Map<String, Map<String, double>> groupByMonth(List<Receipt> receipts) {
    Map<String, Map<String, double>> monthlyTotals = {};
    for (var receipt in receipts) {
      String month = DateFormat('yyyy-MM').format(receipt.date);
      if (!monthlyTotals.containsKey(month)) {
        monthlyTotals[month] = {};
      }
      if (!monthlyTotals[month]!.containsKey(receipt.type)) {
        monthlyTotals[month]![receipt.type] = 0;
      }
      monthlyTotals[month]![receipt.type] = monthlyTotals[month]![receipt.type]! + receipt.total;
    }
    return monthlyTotals;
  }

  Color _getLightRandomColor() {
    Random random = Random();
    const int minBrightness = 100; // Adjust the minimum brightness as needed
    int red = minBrightness + random.nextInt(256 - minBrightness);
    int green = minBrightness + random.nextInt(256 - minBrightness);
    int blue = minBrightness + random.nextInt(256 - minBrightness);
    return Color.fromRGBO(red, green, blue, 1);
  }

}
