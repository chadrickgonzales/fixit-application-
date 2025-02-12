import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String? postId = ModalRoute.of(context)?.settings.arguments as String?;

    if (postId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Post Not Found')),
        body: Center(child: Text('Invalid post link.')),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('posts').doc(postId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(title: Text('Post Not Found')),
            body: Center(child: Text('This post does not exist.')),
          );
        }

        var postData = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(title: Text(postData['title'] ?? 'Post Details')),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.network(postData['imageUrl']),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    postData['title'], 
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(postData['content'] ?? 'No content available.'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
