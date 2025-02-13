import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fixit/pages/NewpostPage.dart';
import 'package:fixit/pages/PostDetailsPage.dart';
import 'package:fixit/pages/ShareLinkPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedPostId;
  final TextEditingController _commentController = TextEditingController();
  int _topSelectedIndex = 0;
  int _bottomSelectedIndex = -1;
  List<String> hiddenPosts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090A0E),
       resizeToAvoidBottomInset: false,
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

   Future<void> _updateVote(String postId, bool isUpvote) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentReference postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    DocumentSnapshot postSnapshot = await postRef.get();

    if (!postSnapshot.exists) return;

    Map<String, dynamic> postData = postSnapshot.data() as Map<String, dynamic>;
    List<dynamic> upvotedBy = postData['upvotedBy'] ?? [];
    List<dynamic> downvotedBy = postData['downvotedBy'] ?? [];

    if (isUpvote) {
      if (upvotedBy.contains(user.uid)) {
        upvotedBy.remove(user.uid);
      } else {
        upvotedBy.add(user.uid);
        downvotedBy.remove(user.uid);
      }
    } else {
      if (downvotedBy.contains(user.uid)) {
        downvotedBy.remove(user.uid);
      } else {
        downvotedBy.add(user.uid);
        upvotedBy.remove(user.uid);
      }
    }

    await postRef.update({
      'upvotedBy': upvotedBy,
      'downvotedBy': downvotedBy,
      'upvotes': upvotedBy.length,
      'downvotes': downvotedBy.length,
    });
  }


void _editComment(String postId, String commentId, String currentText) {
  TextEditingController editController = TextEditingController(text: currentText);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Color(0xFF1E1E2C),
        title: Text('Edit Comment', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: editController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Edit your comment...',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Color(0xFF2A2A3A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Save', style: TextStyle(color: Colors.blue)),
            onPressed: () async {
              String updatedText = editController.text.trim();
              if (updatedText.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('posts')
                    .doc(postId)
                    .collection('comments')
                    .doc(commentId)
                    .update({'text': updatedText});

                Navigator.pop(context); 
              }
            },
          ),
        ],
      );
    },
  );
}

void _deleteComment(String postId, String commentId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Color(0xFF1E1E2C),
        title: Text('Delete Comment?', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to delete this comment?', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('posts')
                  .doc(postId)
                  .collection('comments')
                  .doc(commentId)
                  .delete();

              Navigator.pop(context); 
            },
          ),
        ],
      );
    },
  );
}
void _sharePost(String postId, String title, String imageUrl) async {
  try {
    String link = await _createDynamicLink(postId);
    String message = 'Check out this post: $title\n$link';
    Share.share(message);
  } catch (e) {
    print("Error creating dynamic link: $e");
  }
}

Future<String> _createDynamicLink(String postId) async {
  final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
    uriPrefix: "https://chadrick.page.link",
   link: Uri.parse("https://example.com/post?id=$postId"),
    androidParameters: AndroidParameters(
      packageName: "com.example.fixit", 
      minimumVersion: 0,
    ),
    iosParameters: IOSParameters(
      bundleId: "com.example.fixit",
      minimumVersion: "1.0.0",
    ),
  );

  final ShortDynamicLink shortLink =
      await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
  
  print("Generated Dynamic Link: ${shortLink.shortUrl}");
  return shortLink.shortUrl.toString();
}

void _reportPost(String postId) {
  FirebaseFirestore.instance.collection('reports').add({
    'postId': postId,
    'reportedAt': Timestamp.now(),
  });
  Fluttertoast.showToast(msg: 'Post reported successfully');
}

void _hidePost(String postId) {
  setState(() {
    hiddenPosts.add(postId);
  });
}

void _copyPost(String title, String imageUrl) {
  Clipboard.setData(ClipboardData(text: 'Check out this post: $title\n$imageUrl'));
  Fluttertoast.showToast(msg: 'Post copied to clipboard');
}

void _savePost(String postId) {
  FirebaseFirestore.instance.collection('saved_posts').add({
    'postId': postId,
    'savedAt': Timestamp.now(),
  });
  Fluttertoast.showToast(msg: 'Post saved successfully');
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
                var postId = post.id;
                var username = post['username'];
                var title = post['title'];
                var content = post['content'];  
                var imageUrl = post['imageUrl'];
                int upvotes = post['upvotes'] ?? 0;
                int downvotes = post['downvotes'] ?? 0;

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .collection('comments')
                      .snapshots(),
                  builder: (context, commentSnapshot) {
                    int commentCount =
                        commentSnapshot.hasData ? commentSnapshot.data!.docs.length : 0;
                         return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetailsPage(
                                  postId: postId,         // Add this line to pass postId
                                  username: username,
                                  title: title,
                                  content: content,
                                  imageUrl: imageUrl,
                                  upvotes: upvotes,
                                  downvotes: downvotes,
                                ),
                              ),
                            );
                          },

                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFF090A0E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color.fromARGB(57, 149, 158, 185), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row for Username, Share Button, and 3-dot Menu
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(username,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Color(0xFF959EB9))),

                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.share, color: Color(0xFF959EB9)),
                                    onPressed: () {
                                      _sharePost( postId, title, imageUrl);
                                    },
                                  ),
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert, color: Color(0xFF959EB9)),
                                    onSelected: (value) {
                                      if (value == 'report') {
                                        _reportPost(postId);
                                      } else if (value == 'hide') {
                                        _hidePost(postId);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(value: 'report', child: Text('Report')),
                                      PopupMenuItem(value: 'hide', child: Text('Hide Post')),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF959EB9)),
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
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_upward, color: Color(0xFF959EB9)),
                                onPressed: () => _updateVote(postId, true),
                              ),
                              Text('$upvotes', style: TextStyle(color: Color(0xFF959EB9))),
                              IconButton(
                                icon: Icon(Icons.arrow_downward, color: Color(0xFF959EB9)),
                                onPressed: () => _updateVote(postId, false),
                              ),
                              Text('$downvotes', style: TextStyle(color: Color(0xFF959EB9))),
                              IconButton(
                                icon: Icon(Icons.comment, color: Color(0xFF959EB9)),
                                onPressed: () {
                                  setState(() {
                                    _selectedPostId = (_selectedPostId == postId) ? null : postId;
                                  });
                                },
                              ),
                              Text('$commentCount', style: TextStyle(color: Color(0xFF959EB9))),
                              IconButton(
                                icon: Icon(Icons.bookmark, color: Color(0xFF959EB9)),
                                onPressed: () {
                                  _savePost(postId);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.content_copy, color: Color(0xFF959EB9)),
                                onPressed: () {
                                  _copyPost(title, imageUrl);
                                },
                              ),
                            ],
                          ),

                          // Show comment section if this post is selected
                          if (_selectedPostId == postId) _buildCommentsSection(postId),
                        ],
                      ),
                    ),
                    );
                  },
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

  Widget _buildCommentsSection(String postId) {
  return Column(
    children: [
      Container(
        constraints: BoxConstraints(maxHeight: 250), // Set max height for scrolling
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(postId)
              .collection('comments')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

            var comments = snapshot.data!.docs;
            User? user = FirebaseAuth.instance.currentUser;

            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                var comment = comments[index];
                String commentId = comment.id;
                String commentUserId = comment['userId'];
                String username = comment['username'];
                String text = comment['text'];

                bool isUserComment = (user?.uid == commentUserId);

                return ListTile(
                  title: Text(username, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(text, style: TextStyle(color: Colors.grey)),
                  trailing: isUserComment
                      ? PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: Colors.white),
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editComment(postId, commentId, text);
                            } else if (value == 'delete') {
                              _deleteComment(postId, commentId);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                        )
                      : null,
                );
              },
            );
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF2A2A3A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: Colors.blue),
              onPressed: () async {
                String commentText = _commentController.text.trim();
                if (commentText.isNotEmpty) {
                  User? user = FirebaseAuth.instance.currentUser;
                  await FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .collection('comments')
                      .add({
                    'text': commentText,
                    'username': user?.displayName ?? 'Anonymous',
                    'userId': user?.uid ?? 'unknown',
                    'createdAt': Timestamp.now(),
                  });
                  _commentController.clear();
                }
              },
            ),
          ],
        ),
      ),
    ],
  );
}


}
