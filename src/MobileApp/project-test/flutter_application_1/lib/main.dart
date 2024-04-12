import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_1/pages/camera_page.dart';

void main() async {
  await dotenv.load(fileName: "lib/.env");
  runApp(MyApp());
}


class MyAppState extends ChangeNotifier {
  // var current = WordPair.random();
  // void getNext() {
  //   current = WordPair.random();
  //   notifyListeners();
  // }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 83, 116, 126)),
        ),
        home: CameraPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
