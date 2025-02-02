import 'package:fixit/pages/NewpostPage.dart';
import 'package:fixit/pages/ShareLinkPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _topSelectedIndex = -1;  // Separate state for top nav
  int _bottomSelectedIndex = -1;  // Separate state for bottom nav

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090A0E),
      body: Stack(
        children: [
          // Main content of the body
          Center(
            child: Text(
              'Home Page',
              style: TextStyle(color: Colors.white),
            ),
          ),
          // Profile circle on the top left
          Positioned(
            top: 60, // Adjust the vertical position
            left: 20, // Adjust the horizontal position
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[800], // Default color if no image
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage('https://example.com/your-profile-image.jpg'), // Replace with your profile image URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Burger menu icon on the top right
          Positioned(
            top: 60, // Adjust the vertical position
            right: 20, // Adjust the horizontal position
            child: IconButton(
              icon: Icon(
                Icons.menu, // Burger menu icon
                color: Color(0xFF959EB9),
                size: 30,
              ),
              onPressed: () {
                // Action for the burger menu icon
                print("Burger menu pressed");
              },
            ),
          ),
          // Navigation bar below the profile and burger menu with buttons and a bottom border
          Positioned(
            top: 120, // Position below the profile and menu
            left: 20,
            right: 20,
            child: Container(
              width: MediaQuery.of(context).size.width * 1.0,
              height: 100, // Increased height to accommodate the buttons and border
              color: const Color(0xFF090A0E), // Set background color
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTopNavBarItem('You', 0),
                      _buildTopNavBarItem('Following', 1),
                      _buildTopNavBarItem('Discussions', 2),
                      _buildTopNavBarItem('Tags', 3),
                    ],
                  ),
                  Divider(
                    color: Color(0xFF959EB9), // Border color at the bottom
                    thickness: 1, // Border thickness
                    indent: 0, // No indentation from the left side
                    endIndent: 0, // No indentation from the right side
                  ),
                ],
              ),
            ),
          ),
        
          Positioned(
            bottom: 20, 
            left: MediaQuery.of(context).size.width * 0.02, 
            right: MediaQuery.of(context).size.width * 0.02, 
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85, 
              height: 70, 
              decoration: BoxDecoration(
                color: Color(0xFF010409), 
                borderRadius: BorderRadius.circular(40), 
                border: Border.all(
                  color: Color(0xFF959EB9), 
                  width: 1, 
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: _bottomSelectedIndex == 0 ? Colors.white : Color(0xFF959EB9),
                      size: 45,
                    ),
                    onPressed: () {
                      setState(() {
                        _bottomSelectedIndex = 0;
                      });
                      print("Home icon pressed");
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: _bottomSelectedIndex == 1 ? Colors.white : Color(0xFF959EB9),
                      size: 45,
                    ),
                    onPressed: () {
                      setState(() {
                        _bottomSelectedIndex = 1;
                      });
                      print("Search icon pressed");
                    },
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(
                        color: Color(0xFF959EB9),
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 45,
                      ),
                      onPressed: () {
                        _showBottomSheet(context); // Show bottom sheet when the icon is pressed
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: _bottomSelectedIndex == 2 ? Colors.white : Color(0xFF959EB9),
                      size: 45,
                    ),
                    onPressed: () {
                      setState(() {
                        _bottomSelectedIndex = 2;
                      });
                      print("Bell icon pressed");
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.people,
                      color: _bottomSelectedIndex == 3 ? Colors.white : Color(0xFF959EB9),
                      size: 45,
                    ),
                    onPressed: () {
                      setState(() {
                        _bottomSelectedIndex = 3;
                      });
                      print("People icon pressed");
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 50,
            bottom: 10,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: Color(0xFF959EB9),
                  width: 3, 
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 45, 
                ),
                onPressed: () {
                  _showBottomSheet(context); // Show bottom sheet when the icon is pressed
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to show the bottom sheet
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to New Post page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewPostPage()), // Replace with your New Post page
                      );
                    },
                    child: Text('New Post'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Share a Link page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShareLinkPage()), // Replace with your Share Link page
                      );
                    },
                    child: Text('Share a Link'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopNavBarItem(String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _topSelectedIndex = index;
        });
        print("$label button pressed");
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: _topSelectedIndex == index ? Colors.white : Color(0xFF959EB9),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}