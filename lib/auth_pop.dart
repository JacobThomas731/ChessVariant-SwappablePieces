import 'package:flutter/material.dart';

class AuthPop extends StatefulWidget {
  const AuthPop({Key? key}) : super(key: key);

  @override
  _AuthPopState createState() => _AuthPopState();
}

class _AuthPopState extends State<AuthPop> {
  var screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
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
                  height: 50,
                  child: Text('Register/Sign-In'),
                ),
                const MediaQuery(
                  data: MediaQueryData(),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: TextField(),
                  ),
                ),
                const MediaQuery(
                  data: MediaQueryData(),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: TextField(),
                  ),
                ),
                const MediaQuery(
                  data: MediaQueryData(),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: TextField(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                  child: Text('Forget Password'),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          height: 50,
                          width: 60,
                          color: Colors.red,
                          child: const Text('Register'),
                      ),
                      Container(
                          height: 50,
                          width: 60,
                          color: Colors.red,
                          child: const Text('Sign-In'))
                    ])
              ]),
            )),
      ),
    );
  }
}
