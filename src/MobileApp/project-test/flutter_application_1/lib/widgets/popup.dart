import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/network_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert'; // Import JSON decoder

void showPopup(BuildContext context, String buttonText, String popupText) {
  TextEditingController textEditingController = TextEditingController(text: popupText);
  final TextEditingController _endpointController = TextEditingController(text: "http://${dotenv.env['CURRENT_IP']}:8000/uploadReceiptData/");
  double _fontSize = 13;


  Map<String, dynamic> response = json.decode(popupText);
  Map<String, dynamic> result = response['results'] ?? {};
  TextEditingController shopNameController = TextEditingController(text: result["shop_information"].toString());
  TextEditingController dateController = TextEditingController(text: result["time"].toString());
  TextEditingController totalController = TextEditingController(text: result["total"].toString());

  Map<String, TextEditingController> nameControllers = {};
  Map<String, TextEditingController> qtyControllersDict = {};
  Map<String, TextEditingController> priceControllersDict = {};

  
  // List<Widget> itemFields = result["Item_purchase"].entries.map<Widget>((entry) {
  //   String key = entry.key;
  //   Map<String, dynamic> value = entry.value;
  //   TextEditingController nameControler = TextEditingController(text: key);
  //   qtyControllers[key] = TextEditingController(text: value['qty'].toString());
  //   TextEditingController priceController = TextEditingController(text: value['price'].toString());

  //   return Row(

List<Widget> buildItemFields(Map<String, dynamic> items, Map<String, TextEditingController> nameControllers,Map<String, TextEditingController> qtyControllers, Map<String, TextEditingController> priceControllers) {
  return items.entries.map<Widget>((entry) {
    String key = entry.key;
    Map<String, dynamic> value = entry.value;

    nameControllers[key] = TextEditingController(text: key);
    qtyControllers[key] = TextEditingController(text: value['qty'].toString());
    priceControllers[key] = TextEditingController(text: value['price'].toString());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 4,
          child: TextField(
            controller: nameControllers[key],
            decoration: InputDecoration(hintText: 'Name'),
            style: TextStyle(
              fontSize: _fontSize,
            )
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.red, // Add red background color
            child: TextField(
              controller: qtyControllers[key],
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
            controller: priceControllers[key],
            decoration: InputDecoration(hintText: 'Price'),
            style: TextStyle(fontSize: _fontSize,),
          ),
        ),
      ],
    );
  }).toList();}

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Popup'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildBasicResponseField(shopNameController, "Shop Name", _fontSize),
              buildBasicResponseField(dateController, "Date", _fontSize),
              buildBasicResponseField(totalController, "total", _fontSize),
              ...buildItemFields(result["item_purchase"], nameControllers, qtyControllersDict, priceControllersDict)
              // Add other widgets here if needed
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
                "Shop_Information": shopNameController.text,
                "Time": dateController.text,
                "Total": totalController.text,
                "Item_purchase": {}
              };

              for (var entry in result["Item_purchase"].entries) {
                updatedResult["Item_purchase"][entry.key] = {
                  "name": nameControllers[entry.key]?.text,
                  "qty": qtyControllersDict[entry.key]?.text,
                  "price": priceControllersDict[entry.key]?.text
                };
              }

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
    },
  );
}

Widget buildBasicResponseField(TextEditingController textController, String category,  double _fontSize) {
                return Row(
                  children: [
                    Text(category + ': '),
                    Flexible(
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(hintText: category),
                        style: TextStyle(
                          fontSize: _fontSize,
                        ),
                      ),
                    ),
                  ],
                );
              }