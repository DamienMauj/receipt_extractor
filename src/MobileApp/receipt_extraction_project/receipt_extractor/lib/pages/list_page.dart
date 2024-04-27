import 'package:flutter/material.dart';
import 'package:receipt_extractor/widgets/navigation_bar.dart';
import 'package:receipt_extractor/classes/receipt_class.dart';
import 'package:receipt_extractor/classes/data_service_class.dart';
import 'package:receipt_extractor/globals.dart' as globals;
import 'package:receipt_extractor/widgets/popup.dart';

class ReceiptsPage extends StatefulWidget {
  final String? userId; // Optional user ID
  final DataService dataService; // Data service dependency

  // Non-const constructor
  ReceiptsPage({Key? key, this.userId, DataService? dataService})
      : dataService = dataService ?? DataService(),
        super(key: key);

  @override
  _ReceiptsPageState createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage> {
  late Future<List<Receipt>> futureReceipts;

  @override
  void initState() {
    super.initState();
    String userId = widget.userId ?? globals.user_id;
    futureReceipts = widget.dataService.fetchReceipts(userId);
  }

  void refreshReceipts() {
    setState(() {
      // Refresh with the current userId in use
      String userId = widget.userId ?? globals.user_id;
      futureReceipts = widget.dataService.fetchReceipts(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('Receipts Page'),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshReceipts,
          ),
          IconButton(
            key: const Key('Add Button'),
            icon: const Icon(Icons.add),
            onPressed: () {
              print("add receipt");
              showPopup(context, "Add Receipt", "", true);
              refreshReceipts();
            },
          ),
        ],
        title: const Text('Receipts'),
      ),
      body: FutureBuilder<List<Receipt>>(
        future: futureReceipts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Column(
              key: const Key('Error Message'),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Error: ${snapshot.error}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                ),
              ],
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var receipt = snapshot.data![index];
                return ListTile(
                  key: Key("row $index"),
                  title: Text(receipt.shop_name),
                  subtitle: Text('Total: ${receipt.total.toString()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(receipt.date.toLocal().toString().split(' ')[0]),
                      const SizedBox(width: 8),
                      const Icon(Icons.edit_note),
                    ],
                  ),
                  onTap: () {
                    print("edit receipt: ${receipt.toString()}");
                    showPopup(context, "Edit Receipt", receipt.toString(), false);
                    refreshReceipts();
                  },
                );
              },
            );
          } else {
            return const Center(
              key: Key('No Receipts Message'),
              child: Text("No receipts found. Add a new receipt.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 0),
    );
  }
}
