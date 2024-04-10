import 'dart:convert';
import 'package:logger/logger.dart';

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

  static final _logger = Logger();


  factory Receipt.fromJson(Map<String, dynamic> json) {
    try {
      return Receipt(
        receipt_id: json['receipt_id'] as String,
        shop_name: json['shop_information'] as String,
        type: json['type'] as String,
        date: DateTime.parse(json['time']),
        total: json['total'] as double,
        item_purchase: jsonDecode(json['item_purchase'] as String),
        // initialize other fields...
      );
    } catch (e) {
      _logger.d('Error parsing receipt: $e');
      return Receipt(
        receipt_id: 'Error parsing receipt',
        shop_name: 'Error parsing receipt',
        type: 'Error parsing receipt',
        date: DateTime.now(),
        total: 0.0,
        item_purchase: null,
        // initialize other fields...
      );
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'receipt_id': receipt_id,
      'shop_information': shop_name,
      'type': type,
      'time': date.toIso8601String(),
      'total': total,
      'item_purchase': item_purchase,
      // add other fields...
    };
  }

  String toString() {
    return jsonEncode({"results":this.toJson()});
  }
}
