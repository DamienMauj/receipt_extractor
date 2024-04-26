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
  late Map<String, bool> validationErrors; 
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

    validationErrors = {
      "Shop": false,
      "Type": false,
      "Date": false,
      "Total": false,
    };
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

    validationErrors = {
      "Shop": false,
      "Type": false,
      "Date": false,
      "Total": false,
    };
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
              height: 48, 
              alignment: Alignment.center, 
              padding: EdgeInsets.symmetric(horizontal: 8), 
              child: Text(
                '$category: ',
                key: Key("${category} text"),
                style: TextStyle(
                  fontSize: _fontSize+5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                constraints: BoxConstraints(minHeight: 48), 
                decoration: BoxDecoration(
                  border: Border.all(
                    color: (validationErrors[category] ?? false) ? Colors.red : Colors.grey,
                    width: 2
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  key: Key("${category} field ${validationErrors[category] ?? false ? 'error' : ''}"),
                  controller: textController,
                  decoration: InputDecoration(
                    border: InputBorder.none, 
                    hintText: category,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  ),
                  style: TextStyle(fontSize: _fontSize),
                  validator: (value) {
                      bool isInvalid = value == null || value.isEmpty;
                      setState(() {
                        validationErrors[category] = isInvalid;
                    });
                    if (!isInvalid) {
                      return null;
                    }
                    return "This field is required";
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      const Divider(
        color: Color.fromARGB(255, 84, 69, 50),
        thickness: 1.5,
        height: 15,
      ),
    ],
  );
}



 Widget _buildItemRow(String key, double _fontSize) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0), 
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0), 
            child: TextField(
              key: Key("$key Name Field"),
              controller: nameControllersDict[key],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Name',
                contentPadding: EdgeInsets.symmetric(vertical: 10.0), 
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
            padding: const EdgeInsets.only(right: 8.0),
            child: TextField(
              key: Key("$key Qty Field"),
              controller: qtyControllersDict[key],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'QTY',
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0), 
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
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0), 
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
          icon: const Icon(Icons.delete),
          onPressed: () {
            setState(() {
              nameControllersDict[key]?.dispose();
              qtyControllersDict[key]?.dispose(); 
              priceControllersDict[key]?.dispose();

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
      key: const Key('Receipt Popup'),
      title: const Text('Popup'),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildBasicResponseField(shopNameController, "Shop", _fontSize),
              buildBasicResponseField(typeController, "Type", _fontSize),
              buildBasicResponseField(dateController, "Date", _fontSize),
              buildBasicResponseField(totalController, "Total", _fontSize),
              ..._buildItemFields(_fontSize),
              ElevatedButton(
                key: const Key('Add Item Button'),
                onPressed: _addItem,
                child: const Text('Add Item'),
              ),
            ],
          ),
        )
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop(); 
          },
        ),
        TextButton(
          child: const Text('Submit'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
    
                Map<String, dynamic> updatedResult = {
                "shop_information": shopNameController.text,
                "type": typeController.text, 
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
              String updatedJson = json.encode({
                "results": updatedResult,
                "new_receipt": widget.isNewReceipt
              });
              print(updatedJson); 
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
