import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/graph_page.dart';
import 'package:flutter_application_1/services/network_service.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_application_1/models/app_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_1/widgets/big_card.dart';
import 'package:flutter_application_1/pages/camera_page.dart';
import 'package:flutter_application_1/pages/graph_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _endpointController = TextEditingController(text: "http://${dotenv.env['CURRENT_IP']}:8000/users/");
  final TextEditingController _bodyController = TextEditingController(text: '{"user_id" : "f0a39253-df87-4f42-b8da-a9c893544b2c"}');
  String _responseBody = '';

  @override
  void dispose() {
    _endpointController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      appBar: AppBar(
        title: Text('Namer App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('A random idea:'),
          BigCard(pair: pair),
          TextField(
            controller: _endpointController,
            decoration: InputDecoration(
              labelText: 'Endpoint',
            ),
          ),
          TextField(
            controller: _bodyController,
            decoration: InputDecoration(
              labelText: 'Body',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>CameraPage()),
              );
            },
            child: Text('Go to camera Page'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>GraphPage()),
              );
            },
            child: Text('Go to graph Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              print('button pressed!');
              appState.getNext();
              String endpoint = _endpointController.text;
              print("error check:");
              print(_bodyController.text);
              Map<String, dynamic> body = jsonDecode(_bodyController.text);
              _responseBody = await sendData(endpoint, body);
              setState(() {}); // Update the UI
            },
            child: Text('Send'),
          ),
          Text('Response: $_responseBody'),
        ],
      ),
    );
  }
}