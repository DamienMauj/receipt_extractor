import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:receipt_extractor/widgets/navigation_bar.dart';
import 'package:fl_chart/fl_chart.dart' as fl_Chart;
import 'package:intl/intl.dart';
import 'package:receipt_extractor/widgets/analitics/pie_chart.dart';
import 'package:receipt_extractor/classes/receipt_class.dart';
import 'package:receipt_extractor/classes/data_service_class.dart';
import 'package:receipt_extractor/widgets/analitics/line_chart.dart';
import 'package:receipt_extractor/globals.dart' as globals;


class GraphPage extends StatefulWidget {
  final DataService dataService;

  GraphPage({Key? key, DataService? dataService})
      : dataService = dataService ?? DataService(),
        super(key: key);

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Receipt>> futureReceipts;
  late List<FlSpot> spots;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    futureReceipts = widget.dataService.fetchReceipts(globals.user_id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildAnimatedLineChart(List<Receipt> data, List<FlSpot> spots) {
    Map<DateTime, double> groupByMonth(List<Receipt> receipts) {
      Map<DateTime, double> monthlyTotals = {};

      for (var receipt in receipts) {
        DateTime month = DateTime(receipt.date.year, receipt.date.month);
        if (!monthlyTotals.containsKey(month)) {
          monthlyTotals[month] = 0;
        }
        monthlyTotals[month] = monthlyTotals[month]! + receipt.total;
      }
      return monthlyTotals;
    }

    List<Receipt> filterLatestThreeMonths(List<Receipt> receipts) {
      receipts.sort((a, b) => b.date.compareTo(a.date));

      var uniqueDates = receipts.map((e) => DateTime(e.date.year, e.date.month)).toSet().toList();
      uniqueDates.sort((a, b) => b.compareTo(a)); 
      uniqueDates = uniqueDates.take(4).toList(); 
      return receipts.where((receipt) {
        var receiptMonth = DateTime(receipt.date.year, receipt.date.month);
        return uniqueDates.contains(receiptMonth);
      }).toList();
    }

    List<Receipt> latestData = filterLatestThreeMonths(data);
    Map<DateTime, double> monthlyTotals = groupByMonth(latestData);

    List<FlSpot> spots = monthlyTotals.entries.map((entry) {
      return FlSpot(entry.key.millisecondsSinceEpoch.toDouble(), entry.value);
    }).toList();
    this.spots = spots;

    return Container(
      padding: const EdgeInsets.all(50),
      width: double.infinity,
      height: double.infinity,
      child: fl_Chart.LineChart(
        LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: false,
                dotData: FlDotData(
                  show: false,
                ),
                color: Colors.red
              ),
            ],
            borderData: FlBorderData(
                border: const Border(bottom: BorderSide(), left: BorderSide())),
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(sideTitles: _bottomTitles),
              leftTitles: AxisTitles(sideTitles: _leftTitles),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
          ),
      ),
    );  
  }

  SideTitles get _bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 30,
    getTitlesWidget: (value, meta) {
        bool isCloseToSpot(double spotValue, double checkValue) {
            return (spotValue - 300000000.0 <= checkValue) && (checkValue <= spotValue + 300000000.0);
        }
        bool hasCloseSpot = spots.any((spot) => isCloseToSpot(spot.x, value));

        if (hasCloseSpot) {
            final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
            final String formattedDate = DateFormat('yyyy-MM').format(date);

            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                    formattedDate,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 8, 
                    ),
                ),
            );
        } else {
            return const Text(''); 
        }
    },
);

  SideTitles get _leftTitles => SideTitles(
    showTitles: true,
    reservedSize: 30, 
    getTitlesWidget: (value, meta) {
      return Text(
        value.toStringAsFixed(2), 
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12, 
        ),
        textAlign: TextAlign.right,
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('Graph Page'),
      appBar: AppBar(
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TabBar(
              key: const Key('Tab Bar'),
              controller: _tabController, 
              tabs: const [
                Tab(key: Key("Tab 1"),  text: 'Line Chart'),
                Tab(key: Key("Tab 2"),  text: 'Pie Chart'),
              ], 
            )
          ],
        ),
      ),
      body: FutureBuilder<List<Receipt>>(
      future: futureReceipts,
      builder: (context, snapshot) {
        spots = [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Column(
            key: const Key('Error Message'),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                ),
              ),
              ),
            ],
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return TabBarView(
            key: const Key('Tab Bar View'),
            controller: _tabController,
            children: [
              AnimatedLineChartWidget(data: snapshot.data!), 
              BarChartWithSelector(data: snapshot.data!),
            ],
          );
        } else {
          return const Center(
            key: Key('No Data Message'),
            child: Text(
              'No data available',
               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
          );
        }
      },
    ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 2),
    );
  }
}



