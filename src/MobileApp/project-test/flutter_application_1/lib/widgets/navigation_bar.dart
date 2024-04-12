import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/camera_page.dart';
import 'package:flutter_application_1/pages/list_page.dart';
import 'package:flutter_application_1/pages/graph_page.dart';



class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;

  CustomBottomNavigationBar({required this.selectedIndex});

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      switch (_selectedIndex) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ReceiptsPage()),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CameraPage()),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GraphPage()),
          );
          break;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(IconData(0xe50d, fontFamily: 'MaterialIcons')),
          label: 'Receipts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: Icon(IconData(0xf59b, fontFamily: 'MaterialIcons')),
          label: 'Analytics',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }
}