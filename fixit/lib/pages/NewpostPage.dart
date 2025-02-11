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
    if (_uploadedImage == null || _selectedGroup == null || _titleController.text.isEmpty || _contentController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    try {

      User? user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not logged in')));
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

 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post uploaded successfully!')));
      Navigator.pop(context); 

    } catch (e) {
      print("Error uploading post: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading post')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color(0xFF090A0E),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: _uploadPost,
                  child: Text("Post"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

           
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

            
            GestureDetector(
              onTap: () async {
              
                final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                
                if (pickedFile != null) {
                  setState(() {
                    _uploadedImage = File(pickedFile.path); 
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
                        fit: BoxFit.cover, 
                      ),
              ),
            ),
            SizedBox(height: 20),

           
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Post Title",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF090A0E),
              ),
            ),
            SizedBox(height: 20),

           
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: TextField(
                controller: _contentController,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: "Write your post",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFF090A0E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
