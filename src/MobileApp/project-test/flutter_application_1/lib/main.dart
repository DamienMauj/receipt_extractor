import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  await dotenv.load(fileName: "lib/.env");
  runApp(MyApp());
}


class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);  // This will take you back to the previous page
          },
          child: Text('Go Back'),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

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
                MaterialPageRoute(builder: (context) => SecondPage()),
              );
            },
            child: Text('Go to Second Page'),
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


class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Text(pair.asLowerCase,
         style: style,
         semanticsLabel: "${pair.first} ${pair.second}"),
      ),
    );
  }
}
Future<String> sendData(String url, Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response,
    // then parse the JSON.
    print('Data sent successfully');
    return response.body;
  } else {
    // If the server returns an unsuccessful response code,
    // then throw an exception.
    print('Failed to send data');
    return 'Failed to send data';
  }
}