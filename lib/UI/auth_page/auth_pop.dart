import 'package:chess_variant_swappable_pieces/UI/auth_page/custom_text_field.dart';
import 'package:chess_variant_swappable_pieces/UI/auth_page/signin_register_buttons.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart' show Platform;

class AuthPop extends StatefulWidget {
  const AuthPop({Key? key}) : super(key: key);

  @override
  _AuthPopState createState() => _AuthPopState();
}

class _AuthPopState extends State<AuthPop> {
  Color theme1 = const Color(0xff5f433f);
  Color theme2 = const Color(0xff8e6d58);
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(screenHeight * 0.002)),
            border: Border.all(color: theme1, width: screenHeight * 0.002),
          ),

          //height: screenHeight / 1.95,
          height: Platform.isWindows ? screenHeight / 1.95 : double.infinity,
          width: screenWidth / 2.1,
          child: Scaffold(
            backgroundColor: theme1,
            body: Localizations(
              locale: const Locale('en', 'US'),
              delegates: const <LocalizationsDelegate<dynamic>>[
                DefaultWidgetsLocalizations.delegate,
                DefaultMaterialLocalizations.delegate,
              ],
              child: Column(children: [
                SizedBox(
                  height: screenHeight * 0.13,
                  child: Center(
                    child: Text(
                      'Register/Sign-In',
                      style: TextStyle(
                        fontFamily: 'ol',
                        color: theme2,
                        fontSize: screenHeight * 0.038,
                      ),
                    ),
                  ),
                ),
                CustomTextField(context, userNameController, 'User Name')
                    .tField(),
                CustomTextField(context, emailController, 'Email Address')
                    .tField(),
                CustomTextField(context, passwordController, 'Password')
                    .tField(),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      screenHeight * 0.07, 0, screenHeight * 0.07, 0),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forget Password',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontFamily: 'ol', color: theme2),
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SignInRegisterButtons('Register', userNameController,
                      emailController, passwordController),
                  SizedBox(
                    width: screenHeight * 0.015,
                  ),
                  SignInRegisterButtons('Sign-In', userNameController,
                      emailController, passwordController),
                ])
              ]),
            ),
          )),
    );
  }
}
