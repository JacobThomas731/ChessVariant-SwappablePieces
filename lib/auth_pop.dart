import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthPop extends StatefulWidget {
  const AuthPop({Key? key}) : super(key: key);

  @override
  _AuthPopState createState() => _AuthPopState();
}

class _AuthPopState extends State<AuthPop> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
            height: screenHeight / 2,
            width: screenWidth / 2,
            color: Colors.brown,
            child: Localizations(
              locale: const Locale('en', 'US'),
              delegates: const <LocalizationsDelegate<dynamic>>[
                DefaultWidgetsLocalizations.delegate,
                DefaultMaterialLocalizations.delegate,
              ],
              child: Column(children: [
                const SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(
                      'Register/Sign-In',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                MediaQuery(
                  data: const MediaQueryData(),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                        width: (screenWidth - 500) / 2,
                        decoration: (BoxDecoration(
                            border:
                                Border.all(width: 1, color: Colors.yellow))),
                        child: const TextField()),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                MediaQuery(
                  data: const MediaQueryData(),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                        width: (screenWidth - 500) / 2,
                        decoration: (BoxDecoration(
                            border:
                                Border.all(width: 1, color: Colors.yellow))),
                        child: const TextField()),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                MediaQuery(
                  data: const MediaQueryData(),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                        width: (screenWidth - 500) / 2,
                        decoration: (BoxDecoration(
                            border:
                                Border.all(width: 1, color: Colors.yellow))),
                        child: const TextField()),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 20,
                  width: (screenWidth - 500) / 2,
                  child: const Text(
                    'Forget Password',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.yellow),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 50,
                        width: 60,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.yellow)),
                        child: const Center(
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.yellow),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 60,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.yellow)),
                        child: const Center(
                          child: Text('Sign-In',
                              style: TextStyle(color: Colors.yellow)),
                        ),
                      ),
                    ])
              ]),
            )),
      ),
    );
  }
}
