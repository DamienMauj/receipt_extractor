import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/network_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert'; // Import JSON decoder


class ReceiptPopup extends StatefulWidget {
  final String buttonText;
  final String popupText;
  // final double _fontSize = 13;
  final TextEditingController _endpointController = TextEditingController(text: "http://${dotenv.env['CURRENT_IP']}:8000/uploadReceiptData/");


  ReceiptPopup({Key? key, required this.buttonText, required this.popupText}) : super(key: key);

  @override
  _ReceiptPopupState createState() => _ReceiptPopupState();
}

class _ReceiptPopupState extends State<ReceiptPopup> {
  late Map<String, dynamic> result;
  late TextEditingController shopNameController;
  late TextEditingController dateController;
  late TextEditingController totalController;
  late Map<String, TextEditingController> nameControllersDict;
  late Map<String, TextEditingController> qtyControllersDict;
  late Map<String, TextEditingController> priceControllersDict;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> response = json.decode(widget.popupText);
    result = response['results'] ?? {};
    shopNameController = TextEditingController(text: result["shop_information"].toString());
    dateController = TextEditingController(text: result["time"].toString());
    totalController = TextEditingController(text: result["total"].toString());

    nameControllersDict = {};
    qtyControllersDict = {};
    priceControllersDict = {};
    _initItemFields();
  }

  void _initItemFields() {
    result["item_purchase"]?.forEach((key, value) {
      nameControllersDict[key] = TextEditingController(text: key.toString());
      qtyControllersDict[key] = TextEditingController(text: value['qty'].toString());
      priceControllersDict[key] = TextEditingController(text: value['price'].toString());
    });
  }

  void _addItem() {
    String newItemKey = "Item ${nameControllersDict.length + 1}";
    print("adding item $newItemKey");
    setState(() {
      nameControllersDict[newItemKey] = TextEditingController();
      qtyControllersDict[newItemKey] = TextEditingController();
      priceControllersDict[newItemKey] = TextEditingController();
    });
  }

  List<Widget> _buildItemFields(double _fontSize) {
    return nameControllersDict.keys.map((key) {
      return _buildItemRow(key, _fontSize);
    }).toList();
  }

  Widget buildBasicResponseField(TextEditingController textController, String category, double _fontSize) {
  return Column(
    children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 8), // Add vertical margin for separation
        child: Row(
          children: [
            Text(category + ': '),
            SizedBox(width: 8), // Add some horizontal space between text and TextField
            Expanded(
              child: TextField(
                controller: textController,
                decoration: InputDecoration(hintText: category),
                style: TextStyle(
                  fontSize: _fontSize,
                ),
              ),
            ),
          ],
        ),
      ),
      Divider(
        color: Color.fromARGB(255, 84, 69, 50), // Add your desired color
        thickness: 1.5, // Add your desired thickness
        height: 20, // Add your desired height
      ),
    ],
  );
}

  Widget _buildItemRow(String key, double _fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 4,
          child: TextField(
            controller: nameControllersDict[key],
            decoration: InputDecoration(hintText: 'Name'),
            style: TextStyle(
              fontSize: _fontSize,
            ),
            maxLines: null,
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.red, // Add red background color
            child: TextField(
              controller: qtyControllersDict[key],
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: 'Quantity'),
              style: TextStyle(
                fontSize: _fontSize,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: TextField(
            textAlign: TextAlign.center,
            controller: priceControllersDict[key],
            decoration: InputDecoration(hintText: 'Price'),
            style: TextStyle(fontSize: _fontSize,),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _fontSize = 13;
    final TextEditingController _endpointController = TextEditingController(text: "http://${dotenv.env['CURRENT_IP']}:8000/uploadReceiptData/");


    return AlertDialog(
      title: Text('Popup'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Your existing buildBasicResponseField calls...
            buildBasicResponseField(shopNameController, "Shop Name", _fontSize),
            buildBasicResponseField(dateController, "Day/Month/Year", _fontSize),
            buildBasicResponseField(totalController, "total", _fontSize),
            ..._buildItemFields(_fontSize),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the popup
          },
        ),
        TextButton(
          child: Text('Submit'),
          onPressed: () {
              Map<String, dynamic> updatedResult = {
              "shop_information": shopNameController.text,
              "time": dateController.text,
              "total": totalController.text,
              "item_purchase": {}
            };

            for (var entry in nameControllersDict.entries) {
              updatedResult["item_purchase"][entry.value.text] = {
                "name": nameControllersDict[entry.key]?.text,
                "qty": qtyControllersDict[entry.key]?.text,
                "price": priceControllersDict[entry.key]?.text
              };
            }

            updatedResult["receipt_id"] = result["receipt_id"];
            updatedResult["type"] = result["type"];

            String updatedJson = json.encode({
              "results": updatedResult
            });

            // Here, you can use updatedJson as you need
            print(updatedJson); // For debugging
            // Handle the submission logic here
            sendData(_endpointController.text, json.decode(updatedJson));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
