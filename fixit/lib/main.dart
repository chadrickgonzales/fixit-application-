import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixit/wrapper.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBrgKOubqCnnkTnotw99yIxSXltmu5NqYo",
      appId: "1:69614301418:android:aeb1950c9007a71df46793",
      messagingSenderId: "69614301418",
      projectId: "outopiadatabase",
      storageBucket: "outopiadatabase.appspot.com",
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