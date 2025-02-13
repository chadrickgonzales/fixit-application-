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
  File? _uploadedImage;

  final ImagePicker _picker = ImagePicker();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _uploadPost() async {
    if (_uploadedImage == null ||
        _selectedGroup == null ||
        _titleController.text.isEmpty ||
        _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all fields')));
      return;
    }

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not logged in')));
        return;
      }

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child('post_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(_uploadedImage!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      Map<String, dynamic> postData = {
        'title': _titleController.text,
        'content': _contentController.text,
        'group': _selectedGroup,
        'imageUrl': imageUrl,
        'userId': user.uid,
        'username': user.displayName ?? 'Anonymous',
        'createdAt': Timestamp.now(),
        'upvotes': 0,
        'downvotes': 0,
        'upvotedBy': [],
        'downvotedBy': [],
      };

      await _firestore.collection('posts').add(postData);

      setState(() {
        _uploadedImage = null;
        _titleController.clear();
        _contentController.clear();
        _selectedGroup = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post uploaded successfully!')));
      Navigator.pop(context);
    } catch (e) {
      print("Error uploading post: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error uploading post')));
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF010409),
    resizeToAvoidBottomInset: true, 
    body: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel",
                      style: TextStyle(color: Colors.redAccent)),
                ),
                ElevatedButton(
                  onPressed: _uploadPost,
                  child: Text("Post",
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF959EB9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            DropdownButton<String>(
              dropdownColor: Color(0xFF2C2C2E),
              value: _selectedGroup,
              hint: Text("Select Group",
                  style: TextStyle(color: Colors.white)),
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

            GestureDetector(
              onTap: () async {
                final XFile? pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  setState(() {
                    _uploadedImage = File(pickedFile.path);
                  });
                }
              },
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xFF010409),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: Color.fromARGB(57, 149, 158, 185), width: 1),
                  image: _uploadedImage != null
                      ? DecorationImage(
                          image: FileImage(_uploadedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _uploadedImage == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate,
                                color: Colors.white70, size: 40),
                            Text(
                              "Tap to upload image",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(height: 20),

            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Post Title",
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Color(0xFF010409),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Color.fromARGB(57, 149, 158, 185), 
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Color(0xFF959EB9), 
                    width: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            TextField(
              controller: _contentController,
              style: TextStyle(color: Colors.white),
              maxLines: 10,
              decoration: InputDecoration(
                labelText: "Write your post",
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Color(0xFF010409),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Color.fromARGB(57, 149, 158, 185), 
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Color(0xFF959EB9), 
                    width: 1.5,
                  )
                )
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}
}
