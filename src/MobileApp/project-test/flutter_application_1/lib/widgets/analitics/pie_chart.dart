import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/classes/receipt_class.dart';




class BarChartWithSelector extends StatefulWidget {
  final List<Receipt> data;

  BarChartWithSelector({Key? key, required this.data}) : super(key: key);

  @override
  _BarChartWithSelectorState createState() => _BarChartWithSelectorState();
}

class _BarChartWithSelectorState extends State<BarChartWithSelector> {
  String? selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.data.isNotEmpty
        ? DateFormat('yyyy-MM').format(widget.data.first.date)
        : 'No Data';
  }

  @override
  Widget build(BuildContext context) {
    List<String> months = groupByMonth(widget.data).keys.toList();

    return Column(
      children: [
        DropdownButton<String>(
          value: selectedMonth,
          onChanged: (String? newValue) {
            setState(() {
              selectedMonth = newValue;
            });
          },
          items: months.map<DropdownMenuItem<String>>((String month) {
            return DropdownMenuItem<String>(
              value: month,
              child: Text(month),
            );
          }).toList(),
        ),
        Expanded(
          child: BarChart(data: widget.data, month: selectedMonth),
        ),
      ],
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
}


class BarChart extends StatelessWidget {
  final List<Receipt> data;
  final String? month;

  BarChart({Key? key, required this.data, this.month}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, double>> monthlyTotals = groupByMonth(data);

    List<PieChartSectionData> barGroups = [];
    if (month != null && monthlyTotals[month] != null) {
      monthlyTotals[month]!.forEach((type, total) {
        barGroups.add(PieChartSectionData(
          value: total,
          color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
          title: type,
          radius: 100,
        ));
      });
    }

    return Center(
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 10,
          borderData: FlBorderData(show: false),
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
}


