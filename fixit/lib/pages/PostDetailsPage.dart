import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailsPage extends StatefulWidget {
  final String postId;
  final String username;
  final String title;
  final String content;
  final String imageUrl;
  final int upvotes;
  final int downvotes;

  PostDetailsPage({
    required this.postId,
    required this.username,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.upvotes,
    required this.downvotes,
  });

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  final TextEditingController _commentController = TextEditingController();
  int upvotes = 0;
  int downvotes = 0;
  bool isBookmarked = false;
  String? _selectedPostId;

  @override
  void initState() {
    super.initState();
    upvotes = widget.upvotes;
    downvotes = widget.downvotes;
    _checkIfBookmarked();
  }

  

  void _checkIfBookmarked() async {
    // Example check for bookmark status (replace with your user logic)
    var doc = await FirebaseFirestore.instance
        .collection('bookmarks')
        .doc(widget.postId)
        .get();
    setState(() {
      isBookmarked = doc.exists;
    });
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

  void _sharePost(String postId, String title, String content,String imageUrl) async {
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

  void _bookmarkPost() async {
    var bookmarkRef = FirebaseFirestore.instance
        .collection('bookmarks')
        .doc(widget.postId);

    if (isBookmarked) {
      await bookmarkRef.delete();
    } else {
      await bookmarkRef.set({
        'postId': widget.postId,
        'title': widget.title,
        'content': widget.content,
        'imageUrl': widget.imageUrl,
      });
    }

    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  void _copyPost() {
    Clipboard.setData(ClipboardData(text: '${widget.title}, ${widget.content}\n${widget.imageUrl}'));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied to clipboard')));
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

  

  @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
  backgroundColor: Color(0xFF090A0E),
  iconTheme: IconThemeData(
    color: Color(0xFF959EB9), // Set the color of the back icon
  ),
),
    body: SingleChildScrollView(
      child: Container(
        width: double.infinity, // Full width of the screen // Outer margin for spacing
        padding: EdgeInsets.all(16), // Inner padding for spacing
        decoration: BoxDecoration(
          color: Color(0xFF010409), // Background color for the content area
          borderRadius: BorderRadius.circular(12), // Rounded corners
          border: Border.all(color: Color.fromARGB(57, 149, 158, 185), width: 1), // Border color and width
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            // Actions Row at the top
           Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // Username on the left
    Text(
      widget.username,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
    ),
    
    // Icons on the right
    Row(
      children: [
        IconButton(
          icon: Icon(Icons.share, color: Color(0xFF959EB9)),
          onPressed: () => _sharePost(widget.postId, widget.title, widget.content, widget.imageUrl),
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Color(0xFF959EB9)),
          onSelected: (value) {
            if (value == 'bookmark') {
              _bookmarkPost();
            } else if (value == 'copy') {
              _copyPost();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'bookmark',
              child: Text(isBookmarked ? 'Remove Bookmark' : 'Bookmark'),
            ),
            PopupMenuItem(
              value: 'copy',
              child: Text('Copy'),
            ),
          ],
        ),
      ],
    ),
  ],
),
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            SizedBox(height: 16),
            Image.network(
              widget.imageUrl,
              width: 400,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.content,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_upward, color: Color(0xFF959EB9)),
                        onPressed: () => _updateVote(widget.postId, true),
                      ),
                      Text('$upvotes', style: TextStyle(color: Color(0xFF959EB9))),
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.arrow_downward, color: Color(0xFF959EB9)),
                        onPressed: () => _updateVote(widget.postId, false),
                      ),
                      Text('$downvotes', style: TextStyle(color: Color(0xFF959EB9))),
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.comment, color: Color(0xFF959EB9)),
                        onPressed: () {
                          setState(() {
                            _selectedPostId = (_selectedPostId == widget.postId) ? null : widget.postId;
                          });
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.postId)
                            .collection('comments')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text('0', style: TextStyle(color: Color(0xFF959EB9)));
                          }
                          int commentCount = snapshot.data!.docs.length;
                          return Text('$commentCount', style: TextStyle(color: Color(0xFF959EB9)));
                        },
                      ),
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: Color(0xFF959EB9),
                        ),
                        onPressed: _bookmarkPost,
                      ),
                      IconButton(
                        icon: Icon(Icons.content_copy, color: Color(0xFF959EB9)),
                        onPressed: _copyPost,
                      ),
                    ],
                  ),
                  if (_selectedPostId == widget.postId) _buildCommentsSection(widget.postId),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    backgroundColor: Color(0xFF090A0E),
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