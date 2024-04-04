import 'dart:convert';

class Receipt {
  final String receipt_id;
  final String shop_name;
  final String type;
  final DateTime date;
  final double total;
  final Map<String, dynamic>? item_purchase;
  // other fields...

  Receipt({required this.receipt_id,
             required this.shop_name,
             required this.type,
             required this.date,
             required this.total,
             this.item_purchase,
             });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      
      receipt_id: json['receipt_id'] as String,
      shop_name: json['shop_information'] as String,
      type: json['type'] as String,
      date: DateTime.parse(json['time']),
      total: json['total'] as double,
      item_purchase: jsonDecode(json['item_purchase'] as String),
      // initialize other fields...
    );
  }
}
