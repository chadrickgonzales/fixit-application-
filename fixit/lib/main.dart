import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fixit/pages/postinfo.dart';
import 'package:fixit/wrapper.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBrgKOubqCnnkTnotw99yIxSXltmu5NqYo",
      appId: "1:69614301418:android:c327166576842474f46793",
      messagingSenderId: "69614301418",
      projectId: "outopiadatabase",
      storageBucket: "outopiadatabase.appspot.com",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initDynamicLinks();
  }

  void _initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? dynamicLinkData) {
      if (dynamicLinkData?.link != null) {
        _handleDeepLink(dynamicLinkData!.link);
      }
    }).onError((error) {
      print("Error handling dynamic link: $error");
    });

    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink?.link != null) {
      _handleDeepLink(initialLink!.link);
    }
  }

 void _handleDeepLink(Uri deepLink) {
  print("Deep link received: ${deepLink.toString()}");

  String? postId = deepLink.queryParameters['id'];
  if (postId != null && postId.isNotEmpty) {
    navigatorKey.currentState?.pushNamed('/post', arguments: postId);
  } else {
    print("Error: postId is null or empty");
  }
}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          routes: {
            '/post': (context) => PostScreen1(),
          },
          home: Wrapper(),
        );
      },
    );
  }
}

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String postId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('Post Details')),
      body: Center(child: Text('Showing post: $postId')),
    );
  }
}
