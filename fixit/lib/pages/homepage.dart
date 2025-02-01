import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090A0E),
      body: Center(
        child: Text(
          'Home Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none, // Allow overflow of the circle above the nav bar
        children: [
          Positioned(
            bottom: 50, // Added space to move the nav bar up slightly
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7, // Adjust the width of the nav bar (70% of screen width)
              height: 65, // Adjust the height of the nav bar
              decoration: BoxDecoration(
                color: Colors.green, // Background color of the nav bar
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), // Increased border radius for a more rounded effect
                  topRight: Radius.circular(40), // Increased border radius for a more rounded effect
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 40,
                    offset: Offset(0, 5), // Adjust shadow position
                  ),
                ],
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent, // Make the background of the nav bar transparent
                selectedItemColor: Colors.blue,
                unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: 25), // Icon size without background
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search, size: 25), // Icon size without background
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox.shrink(), // Empty space for the middle icon
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite, size: 25), // Icon size without background
                    label: 'Favorites',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle, size: 25), // Icon size without background
                    label: 'Profile',
                  ),
                ],
                showSelectedLabels: true, // Show the labels
                showUnselectedLabels: true, // Show unselected labels
                selectedLabelStyle: TextStyle(
                  fontSize: 10, // Adjust font size for selected label
                  fontWeight: FontWeight.bold, // Optional: Make selected label bold
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14, // Adjust font size for unselected label
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 50, // Center the circle
            bottom: 35, // Adjust to ensure the circle stays in front of the nav bar
            child: CircleAvatar(
              radius: 50, // Larger circle size
              backgroundColor: Colors.blue, // Circle color
              child: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 35, // Icon size
                ),
                onPressed: () {
                  // Action for the middle icon
                  print("Middle icon pressed");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}