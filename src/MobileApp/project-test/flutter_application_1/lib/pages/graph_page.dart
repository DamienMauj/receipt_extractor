import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/widgets/navigation_bar.dart';
import 'package:fl_chart/fl_chart.dart' as fl_Chart;
import 'package:flutter_charts/flutter_charts.dart' as flutter_charts;
import 'package:intl/intl.dart';
import 'package:flutter_application_1/widgets/analitics/pie_chart.dart';
import 'package:flutter_application_1/classes/receipt_class.dart';
import 'package:flutter_application_1/classes/data_service_class.dart';
import 'package:flutter_application_1/widgets/analitics/line_chart.dart';




class GraphPage extends StatefulWidget {
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
    _tabController = TabController(length: 3, vsync: this);
    futureReceipts = DataService().fetchReceipts();
    List<FlSpot> spots = [];
  
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


    List<LineChartBarData> lines = [];
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 8, // Adjust the font size as needed
                    ),
                ),
            );
        } else {
            return Text(''); // Empty text for values not close to any spot
        }
    },
);

  SideTitles get _leftTitles => SideTitles(
    showTitles: true,
    reservedSize: 30,  // Adjust this size based on your needs
    getTitlesWidget: (value, meta) {
      // Format the value as needed for the Y-axis
      return Text(
        '${value.toStringAsFixed(2)}',  // Example formatting
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,  // Adjust the font size as needed
        ),
        textAlign: TextAlign.right,
      );
    },
  );

  // Example method to create a pie chart
  Widget pieChart() {
    
    flutter_charts.LabelLayoutStrategy? xContainerLabelLayoutStrategy;
    flutter_charts.ChartData chartData;
    flutter_charts.ChartOptions chartOptions = const flutter_charts.ChartOptions();
    // Example shows an explicit use of the DefaultIterativeLabelLayoutStrategy.
    // The xContainerLabelLayoutStrategy, if set to null or not set at all,
    //   defaults to DefaultIterativeLabelLayoutStrategy
    // Clients can also create their own LayoutStrategy.
    xContainerLabelLayoutStrategy = flutter_charts.DefaultIterativeLabelLayoutStrategy(
    options: chartOptions,
    );
    chartData = flutter_charts.ChartData(
    dataRows: const [
    [10.0, 20.0, 5.0, 30.0, 5.0, 20.0],
    [30.0, 60.0, 16.0, 100.0, 12.0, 120.0],
    [25.0, 40.0, 20.0, 80.0, 12.0, 90.0],
    [12.0, 30.0, 18.0, 40.0, 10.0, 30.0],
    ],
    xUserLabels: const ['Wolf', 'Deer', 'Owl', 'Mouse', 'Hawk', 'Vole'],
    dataRowsLegends: const [
    'Spring',
    'Summer',
    'Fall',
    'Winter',
    ],
    chartOptions: chartOptions,
    );
    // chartData.dataRowsDefaultColors(); // if not set, called in constructor
    var lineChartContainer = flutter_charts.LineChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );

    var lineChart = flutter_charts.LineChart(
      painter: flutter_charts.LineChartPainter(
        lineChartContainer: lineChartContainer,
      ),
    );
    return lineChart;
  
  }

  // Generate some dummy data for the cahrt
  // This will be used to draw the red line

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TabBar(
              controller: _tabController, // Link the TabController here
              tabs: [
                Tab(text: 'Line Chart'),
                Tab(text: 'Pie Chart'),
                Tab(text: 'Missed'),
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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Display an error message if something went wrong
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // Once the data is fetched, build the TabBarView with all three charts
          return TabBarView(
            controller: _tabController,
            children: [
              AnimatedLineChartWidget(data: snapshot.data!), // Line chart with data
              BarChartWithSelector(data: snapshot.data!),  // Bar chart with the same data
              pieChart(),  // Pie chart with the same data
            ],
          );
        } else {
          // Handle the case where no data is available
          return Center(child: Text('No data available'));
        }
      },
    ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 2),
    );
  }
}



