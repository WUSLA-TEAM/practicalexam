import 'package:e_commerce/src/productListing.dart';
import 'package:e_commerce/src/profile.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final String userEmail;

  MainScreen({required this.userEmail});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      ProductListingPage(),
      ProfileScreen(userEmail: widget.userEmail),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: BottomAppBar(
            color: Theme.of(context).colorScheme.tertiary,
            shape: CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Products',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
              onTap: _onItemTapped,
            ),
          ),
        ),
      )
    );
  }
}
