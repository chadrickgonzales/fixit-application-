import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fixit/pages/PostDetailsPage.dart';
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

  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initDynamicLinks();
  }

  /// Initializes Firebase Dynamic Links
  void _initDynamicLinks() async {
    // Listen for foreground dynamic link clicks
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? dynamicLinkData) {
      if (dynamicLinkData?.link != null) {
        _handleDeepLink(dynamicLinkData!.link);
      }
    }).onError((error) {
      print("Error handling dynamic link: $error");
    });

    // Handle dynamic links when the app is launched from a link
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink?.link != null) {
      _handleDeepLink(initialLink!.link);
    }
  }

  /// Handles navigation when a deep link is received
  void _handleDeepLink(Uri deepLink) {
    print("Deep link received: ${deepLink.toString()}");

    // Extract postId from the query parameters
    if (deepLink.queryParameters.containsKey('id')) {
      String postId = deepLink.queryParameters['id']!;
      print("Navigating to PostDetailsPage with postId: $postId");

      navigatorKey.currentState?.pushNamed(
        '/postDetails',
        arguments: {
          'postId': postId,
          'username': '',
          'title': '',
          'imageUrl': '',
          'upvotes': 0,
          'downvotes': 0,
        },
      );
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
          onGenerateRoute: (settings) {
            if (settings.name == '/postDetails') {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => PostDetailsPage(
                  postId: args['postId'],
                  username: args['username'] ?? '',
                  title: args['title'] ?? '',
                  content: args['content'] ?? '',
                  imageUrl: args['imageUrl'] ?? '',
                  upvotes: args['upvotes'] ?? 0,
                  downvotes: args['downvotes'] ?? 0,
                ),
              );
            }
            return MaterialPageRoute(builder: (context) => Wrapper());
          },
          home: Wrapper(),
        );
      },
    );
  }
}
