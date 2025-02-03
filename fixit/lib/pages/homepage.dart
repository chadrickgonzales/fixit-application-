import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fixit/pages/NewpostPage.dart';
import 'package:fixit/pages/ShareLinkPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _topSelectedIndex = 0;
  int _bottomSelectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090A0E),
      body: Stack(
        children: [
 
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(height: 161),

                _buildContent(),


                SizedBox(height: 70), 
              ],
            ),
          ),

 
          Positioned(
            top: 60,  
            left: 20,  
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/profile_picture.jpg'), 
            ),
          ),
          

          Positioned(
            top: 140, 
            left: 0, 
            right: 0, 
            child: Container(
              height: 50, 
              color: const Color(0xFF090A0E), 
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
                    color: Color.fromARGB(57, 149, 158, 185), 
                    thickness: 1, 
                    indent: 0, 
                    endIndent: 0, 
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
                        _showBottomSheet(context); 
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
                  _showBottomSheet(context); 
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewPostPage()),
                      );
                    },
                    child: Text('New Post'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShareLinkPage()),
                      );
                    },
                    child: Text('Share a Link'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); 
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

  Widget _buildContent() {
    Color containerColor;
    String contentText;

    switch (_topSelectedIndex) {
      case 0:
        containerColor = Color(0xFF090A0E); 
        contentText = 'You Page';
       return Expanded(
  child: SingleChildScrollView(
    child: Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var posts = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                var post = posts[index];
                var username = post['username'];
                var title = post['title'];
                var imageUrl = post['imageUrl'];


                int upvotes = 120;
                int downvotes = 35;
                int comments = 15;

               

                return Container(
                   width: double.infinity,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFF090A0E),
                    borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                      color:Color.fromARGB(57, 149, 158, 185), 
                      width: 1, 
    )                 ,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(username, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF959EB9))),
                          SizedBox(height: 8),
                          Text(
                            title,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF959EB9)),
                          ),
                          SizedBox(height: 8),
                          Image.network(
                            imageUrl,
                            width: 400,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_upward, color: Color(0xFF959EB9)),
                                    onPressed: () {
                                    },
                                  ),
                                  Text('$upvotes', style: TextStyle(color: Color(0xFF959EB9))),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_downward, color: Color(0xFF959EB9)),
                                    onPressed: () {
                                    },
                                  ),
                                  Text('$downvotes', style: TextStyle(color: Color(0xFF959EB9))),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.comment, color: Color(0xFF959EB9)),
                                    onPressed: () {
                                    },
                                  ),
                                  Text('$comments', style: TextStyle(color: Color(0xFF959EB9))),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.bookmark, color:Color(0xFF959EB9)),
                                onPressed: () {
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.content_copy, color:Color(0xFF959EB9)),
                                onPressed: () {
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.share, color:Color(0xFF959EB9)),
                              onPressed: () {
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.more_vert, color: Color(0xFF959EB9)),
                              onPressed: () {
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    ),
  ),
);
      case 1:
        containerColor = Color(0xFF090A0E); 
        contentText = 'Following Page';
        break;
      case 2:
        containerColor = Color(0xFF090A0E); 
        contentText = 'Discussions Page';
        break;
      case 3:
        containerColor = Color(0xFF090A0E); 
        contentText = 'Tags Page';
        break;
      default:
        containerColor = Color(0xFF090A0E); 
        contentText = 'Welcome to the app';
        break;
    }
    return Center(
      child: Text(contentText, style: TextStyle(color: Colors.white, fontSize: 24)),
    );
  }
}
