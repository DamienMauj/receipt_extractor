import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:receipt_extractor/widgets/navigation_bar.dart';
import 'package:fl_chart/fl_chart.dart' as fl_Chart;
// import 'package:flutter_charts/flutter_charts.dart' as flutter_charts;
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
    // List<FlSpot> spots = [];
  
  }

  @override
  void dispose() {
    // Dispose of the TabController
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
      // Sort the receipts by date in descending order
      receipts.sort((a, b) => b.date.compareTo(a.date));

      // Get the unique year-month combinations of the latest three months
      var uniqueDates = receipts.map((e) => DateTime(e.date.year, e.date.month)).toSet().toList();
      uniqueDates.sort((a, b) => b.compareTo(a)); // Ensure the dates are sorted
      uniqueDates = uniqueDates.take(4).toList(); // Take only the latest three months

      // Filter the receipts to only include those from the latest three months
      return receipts.where((receipt) {
        var receiptMonth = DateTime(receipt.date.year, receipt.date.month);
        return uniqueDates.contains(receiptMonth);
      }).toList();
    }

    List<Receipt> latestData = filterLatestThreeMonths(data);

    Map<DateTime, double> monthlyTotals = groupByMonth(latestData);


    // List<LineChartBarData> lines = [];
    List<FlSpot> spots = monthlyTotals.entries.map((entry) {
      return FlSpot(entry.key.millisecondsSinceEpoch.toDouble(), entry.value);
    }).toList();
    print("spots: $spots");

    // set state ofn spots
    this.spots = spots;
    print("spots: ${this.spots}");

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

        // Find a spot that is within the tolerance range of the value
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
                        fontSize: 8, // Adjust the font size as needed
                    ),
                ),
            );
        } else {
            return const Text(''); // Empty text for values not close to any spot
        }
    },
);

  SideTitles get _leftTitles => SideTitles(
    showTitles: true,
    reservedSize: 30,  // Adjust this size based on your needs
    getTitlesWidget: (value, meta) {
      // Format the value as needed for the Y-axis
      return Text(
        value.toStringAsFixed(2),  // Example formatting
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,  // Adjust the font size as needed
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
              controller: _tabController, // Link the TabController here
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
          // Show a loading indicator while waiting for the data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Display an error message if something went wrong
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
          // Once the data is fetched, build the TabBarView with all three charts
          return TabBarView(
            key: const Key('Tab Bar View'),
            controller: _tabController,
            children: [
              AnimatedLineChartWidget(data: snapshot.data!), // Line chart with data
              BarChartWithSelector(data: snapshot.data!),  // Bar chart with the same data
              // pieChart(),  // Pie chart with the same data
            ],
          );
        } else {
          // Handle the case where no data is available
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


