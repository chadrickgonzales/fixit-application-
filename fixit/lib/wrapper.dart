import 'package:fixit/authenticate/authenticate.dart';
import 'package:fixit/authenticate/sign_in.dart';
import 'package:fixit/pages/homepage.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     //return Authenticate();
    return HomePage(); 
  }
}
