import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:receipt_extractor/globals.dart' as globals;
import 'package:receipt_extractor/classes/data_service_class.dart';



class ReceiptPopup extends StatefulWidget {
  final String buttonText;
  final bool isNewReceipt; 
  final String popupText;


  ReceiptPopup({Key? key, required this.buttonText, this.popupText = '', this.isNewReceipt = false}) : super(key: key);

  @override
  _ReceiptPopupState createState() => _ReceiptPopupState();
}

class _ReceiptPopupState extends State<ReceiptPopup> {
  late Map<String, dynamic> result;
  late TextEditingController shopNameController;
  late TextEditingController typeController;
  late TextEditingController dateController;
  late TextEditingController totalController;
  late Map<String, TextEditingController> nameControllersDict;
  late Map<String, TextEditingController> qtyControllersDict;
  late Map<String, TextEditingController> priceControllersDict;
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    
    if (widget.isNewReceipt) {
      _initNewReceipt();
    } else {
      _initFromExistingReceipt();
    }
  }

  void _initNewReceipt() {
    shopNameController = TextEditingController();
    typeController = TextEditingController();
    dateController = TextEditingController();
    totalController = TextEditingController();
    
    result = {"receipt_id": Uuid().v1().toString()};
    nameControllersDict = {};
    qtyControllersDict = {};
    priceControllersDict = {};
  }

  void _initFromExistingReceipt() {
    Map<String, dynamic> response = json.decode(widget.popupText);
    result = response['results'] ?? {};
    shopNameController = TextEditingController(text: result["shop_information"] != null ? result["shop_information"].toString() : "");
    typeController = TextEditingController(text: result["type"].toString());
    dateController = TextEditingController(text: (result["time"] != null || result["time"] != "null") ? result["time"].toString() : "");
    totalController = TextEditingController(text: result["total"] != null ? result["total"].toString() : "");

    nameControllersDict = {};
    qtyControllersDict = {};
    priceControllersDict = {};
    _initItemFields();
  }


  void _initItemFields() {
    result["item_purchase"]?.forEach((key, value) {
      nameControllersDict[key] = TextEditingController(text: key.toString());
      qtyControllersDict[key] = TextEditingController(text: value['qty'] != null ? value['qty'].toString() : "");
      priceControllersDict[key] = TextEditingController(text: value['price'] != null ? value['price'].toString() : "");
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
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              height: 48, // Set a fixed height for consistency
              alignment: Alignment.center, // Centers the text vertically
              padding: EdgeInsets.symmetric(horizontal: 8), // Horizontal padding
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.grey, width: 2),
              //   borderRadius: BorderRadius.circular(5),
              // ),
              child: Text(
                '$category: ',
                key: Key("${category} text"),
                style: TextStyle(
                  fontSize: _fontSize+5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 48, // Set the same fixed height for consistency
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  key: Key("${category} field"),
                  controller: textController,
                  decoration: InputDecoration(
                    border: InputBorder.none, // Remove internal border
                    hintText: category,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10), // Padding to center text
                  ),
                  style: TextStyle(fontSize: _fontSize),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter $category';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      Divider(
        color: Color.fromARGB(255, 84, 69, 50), // Optionally adjust the color
        thickness: 1.5,
        height: 15,
      ),
    ],
  );
}



 Widget _buildItemRow(String key, double _fontSize) {
  return Padding( // Add padding around the entire row
    padding: EdgeInsets.only(bottom: 8.0), // Adjust as needed for vertical spacing between rows
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.only(right: 8.0), // Padding between this field and the next
            child: TextField(
              key: Key("$key Name Field"),
              controller: nameControllersDict[key],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Name',
                contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding for height
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: TextStyle(
                fontSize: _fontSize,
              ),
              maxLines: null,
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(right: 8.0), // Padding between this field and the next
            child: TextField(
              key: Key("$key Qty Field"),
              controller: qtyControllersDict[key],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'QTY',
                contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding for height
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: TextStyle(
                fontSize: _fontSize,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: TextField(
            key: Key("$key Price Field"),
            textAlign: TextAlign.center,
            controller: priceControllersDict[key],
            decoration: InputDecoration(
              hintText: 'Price',
              contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding for height
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                gapPadding: 2.0,
              ),
            ),
            style: TextStyle(fontSize: _fontSize,),
          ),
        ),
        IconButton(
          key: Key("$key delete button"),
          icon: Icon(Icons.delete),
          onPressed: () {
            // Remove item row and associated controllers
            setState(() {
              nameControllersDict[key]?.dispose(); // Dispose of name controller
              qtyControllersDict[key]?.dispose(); // Dispose of quantity controller
              priceControllersDict[key]?.dispose(); // Dispose of price controller

              nameControllersDict.remove(key);
              qtyControllersDict.remove(key);
              priceControllersDict.remove(key);
            });
          },
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final double _fontSize = 13;

    return AlertDialog(
      key: Key('Receipt Popup'),
      title: Text('Popup'),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Your existing buildBasicResponseField calls...
              buildBasicResponseField(shopNameController, "Shop", _fontSize),
              buildBasicResponseField(typeController, "Type", _fontSize),
              buildBasicResponseField(dateController, "Date", _fontSize),
              buildBasicResponseField(totalController, "Total", _fontSize),
              ..._buildItemFields(_fontSize),
              ElevatedButton(
                key: Key('Add Item Button'),
                onPressed: _addItem,
                child: Text('Add Item'),
              ),
            ],
          ),
        )
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
            if (_formKey.currentState!.validate()) {
    // Proceed with the form submission logic if all fields are valid
    
                Map<String, dynamic> updatedResult = {
                "shop_information": shopNameController.text,
                "type": typeController.text, // "type" is a reserved keyword in Dart, consider renaming this field to something like "purchase_type
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

              updatedResult["user_id"] = globals.user_id;
              updatedResult["receipt_id"] = result["receipt_id"];
              updatedResult["type"] = result["type"];

              String updatedJson = json.encode({
                "results": updatedResult
              });

              // Here, you can use updatedJson as you need
              print(updatedJson); // For debugging
              // Handle the submission logic here
              DataService().sendReviewedData(json.decode(updatedJson));
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}


void showPopup(BuildContext context, String buttonText, String popupText, bool isNewReceipt) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ReceiptPopup(buttonText: buttonText ,popupText: popupText, isNewReceipt: isNewReceipt);
    },
  );
}
