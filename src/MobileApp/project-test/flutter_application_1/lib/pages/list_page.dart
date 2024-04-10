import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/navigation_bar.dart';
import 'package:flutter_application_1/classes/receipt_class.dart'; // Import your receipt class
import 'package:flutter_application_1/classes/data_service_class.dart';
import 'package:flutter_application_1/globals.dart' as globals;
import 'package:flutter_application_1/widgets/popup.dart';

class ReceiptsPage extends StatefulWidget {
  @override
  _ReceiptsPageState createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage> {
  late Future<List<Receipt>> futureReceipts;
  // static const IconData subject_outlined = IconData(0xf3f9, fontFamily: 'MaterialIcons', matchTextDirection: true);

  @override
  void initState() {
    super.initState();
    futureReceipts = DataService().fetchReceipts(globals.user_id);
    
  }

  void refreshReceipts() {
    setState(() {
      futureReceipts = DataService().fetchReceipts(globals.user_id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('Receipts Page'),
      appBar: AppBar(
        // add refresh button
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              refreshReceipts();
            },
          ),
        ],
        title: Text('Receipts')),
      body: FutureBuilder<List<Receipt>>(
        future: futureReceipts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var receipt = snapshot.data![index];
                return ListTile(
                  title: Text(receipt.shop_name),
                  subtitle: Text('Total: ${receipt.total.toString()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(receipt.date.toString()), // Added date
                      SizedBox(width: 8),
                      Icon(Icons.edit_note),
                    ],
                  ),
                  onTap: () {
                    print("edit receipt : ${receipt.toString()}");
                    showPopup(context, "edit receipt", receipt.toString(), false);
                    refreshReceipts();
                  },
                );
              },
            );
          } else {
            return Text('No receipts found');
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 0),
    );
  }
}
