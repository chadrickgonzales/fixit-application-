import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixit/wrapper.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBEE6ikLIwJFxqwpqUTTfawsXXVIDosMak",
      appId: "1:227454389599:android:f8e2160d8f90aadf213aea",
      messagingSenderId: "227454389599",
      projectId: "fixit-6a7a1",
      storageBucket: "fixit-6a7a1.appspot.com",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if a user is already signed in using FirebaseAuth.
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the snapshot has data, it means the user is signed in.
       
          // If there is no user, show the authentication wrapper.
          return const MaterialApp(
            home: Wrapper(),
          );
        }
      
    );
  }
}