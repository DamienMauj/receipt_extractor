import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_1/widgets/navigation_bar.dart';

// import 'package:your_project_name/services/data_service.dart'; // Import your data service

class ReceiptsPage extends StatefulWidget {
  @override
  _ReceiptsPageState createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage> {
  late Future<List<Receipt>> futureReceipts;
  static const IconData subject_outlined = IconData(0xf3f9, fontFamily: 'MaterialIcons', matchTextDirection: true);

  @override
  void initState() {
    super.initState();
    futureReceipts = DataService().fetchReceipts();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Receipts')),
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
                  trailing: Icon(IconData(0xf3f9, fontFamily: 'MaterialIcons', matchTextDirection: true)),
                  // Other UI elements...
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






////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////


// import 'dart:convert';
// import 'package:http/http.dart' as http;

class DataService {
  Future<List<Receipt>> fetchReceipts() async {
    var url = Uri.parse("http://${dotenv.env['CURRENT_IP']}:8000/getReceipt/");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print("data: $data");
      return data.map((json) => Receipt.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load receipts');
    }
  }
}


////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

class Receipt {
  final String receipt_id;
  final String shop_name;
  final String type;
  final String date;
  final String total;
  final Map<String, dynamic> item_purchase;
  // other fields...

  Receipt({required this.receipt_id,
             required this.shop_name,
             required this.type,
             required this.date,
             required this.total,
             required this.item_purchase,
             });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      receipt_id: json['receipt_id'] as String,
      shop_name: json['shop_information'] as String,
      type: json['type'] as String,
      date: json['date'].toString(),
      total: json['total'].toString(),
      item_purchase: jsonDecode(json['item_purchase'] as String),
      // initialize other fields...
    );
  }
}