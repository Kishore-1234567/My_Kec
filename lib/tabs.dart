import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:my_kec/screens/profilescreen.dart';
import '/screens/allstudentsap.dart';
import '/screens/home.dart';
import '/screens/sapscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabScreen extends StatefulWidget {
  VoidCallback func;
  TabScreen({Key? key, required this.func}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Object>> _pageList = [];
  int _selectedIndex = 1;
  String? designation = '';

  @override
  void initState() {
    _pageList = [
      {'tab': SapScreen(), 'title': 'SAP'},
      {'tab': const HomeScreen(), 'title': 'Home'},
      {'tab': const ProfileScreen(), 'title': 'Profile'},
    ];
    super.initState();
  }

  Future<void> getData() async {
    final pref = await SharedPreferences.getInstance();
    designation = pref.getString('designation');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageList[_selectedIndex]['title'] as String),
        actions: designation == '1'
            ? _selectedIndex == 2
                ? [Logout(widget: widget)]
                : _selectedIndex == 0
                    ? [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AllStudentsSAP(),
                                  ));
                            },
                            icon: const Icon(Icons.all_inbox))
                      ]
                    : null
            : [Logout(widget: widget)],
      ),
      body: _pageList[_selectedIndex]['tab'] as Widget,
      bottomNavigationBar: FutureBuilder(
          future: getData(),
          builder: (ctx, ss) {
            return designation == '1'
                ? CurvedNavigationBar(
                    index: 1,
                    color: Colors.cyan,
                    buttonBackgroundColor:
                        const Color.fromARGB(255, 54, 193, 228),
                    backgroundColor: Colors.transparent,
                    height: 50,
                    animationDuration: const Duration(milliseconds: 200),
                    animationCurve: Curves.easeInCirc,
                    items: const [
                      Icon(Icons.card_membership),
                      Icon(Icons.home),
                      Icon(Icons.account_circle),
                    ],
                    onTap: (i) {
                      setState(() {
                        _selectedIndex = i;
                      });
                    },
                  )
                : const SizedBox(height: 10);
          }),
    );
  }
}

class Logout extends StatelessWidget {
  const Logout({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final TabScreen widget;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          final pref = await SharedPreferences.getInstance();
          pref.clear();
          widget.func();
        },
        icon: const Icon(Icons.logout));
  }
}
