import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  String? _selectedGroup;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  File? _uploadedImage;  // Changed to File to handle image from gallery

  final ImagePicker _picker = ImagePicker(); // Instance of ImagePicker

  // Firebase storage reference
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _uploadPost() async {
    if (_uploadedImage == null || _selectedGroup == null || _titleController.text.isEmpty || _contentController.text.isEmpty) {
      // Make sure all fields are filled
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    try {
      // Get current user data
      User? user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not logged in')));
        return;
      }

      // Upload image to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child('post_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(_uploadedImage!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      // Create post data
      Map<String, dynamic> postData = {
        'title': _titleController.text,
        'content': _contentController.text,
        'group': _selectedGroup,
        'imageUrl': imageUrl,
        'userId': user.uid,
        'username': user.displayName ?? 'Anonymous', // Using display name or 'Anonymous'
        'createdAt': Timestamp.now(),
      };

      // Add post to Firestore
      await _firestore.collection('posts').add(postData);

      // Clear the fields after posting
      setState(() {
        _uploadedImage = null;
        _titleController.clear();
        _contentController.clear();
        _selectedGroup = null;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post uploaded successfully!')));
      Navigator.pop(context); // Go back to the previous page

    } catch (e) {
      print("Error uploading post: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading post')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Cancel and Post buttons at the top
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Handle cancel action
                  },
                  child: Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: _uploadPost, // Handle post action
                  child: Text("Post"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Dropdown menu to select a group
            DropdownButton<String>(
              value: _selectedGroup,
              hint: Text("Select Group"),
              isExpanded: true,
              items: [
                DropdownMenuItem(value: "Group 1", child: Text("Group 1")),
                DropdownMenuItem(value: "Group 2", child: Text("Group 2")),
                DropdownMenuItem(value: "Group 3", child: Text("Group 3")),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGroup = newValue;
                });
              },
            ),
            SizedBox(height: 20),

            // Thumbnail upload section
            GestureDetector(
              onTap: () async {
                // Pick image from gallery or camera
                final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                
                if (pickedFile != null) {
                  setState(() {
                    _uploadedImage = File(pickedFile.path);  // Update image
                  });
                }
              },
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _uploadedImage == null
                    ? Center(child: Text("Tap to upload image"))
                    : Image.file(
                        _uploadedImage!,
                        fit: BoxFit.cover, // Fit image to container
                      ),
              ),
            ),
            SizedBox(height: 20),

            // Post title input field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Post Title",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),

            // Write your post section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: TextField(
                controller: _contentController,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: "Write your post",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
