import 'package:flutter/material.dart';
import 'UI/home_page.dart';
import 'startup.dart';
// import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return const Startup();
  }
}