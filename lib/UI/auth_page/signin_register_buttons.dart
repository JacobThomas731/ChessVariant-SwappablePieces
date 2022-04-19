import 'package:chess_variant_swappable_pieces/authentication/authentication.dart';

import 'package:flutter/cupertino.dart';

class SignInRegisterButtons extends StatefulWidget {
  final String text;
  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Authentication auth = Authentication();

  SignInRegisterButtons(this.text, this.userNameController,
      this.emailController, this.passwordController,
      {Key? key})
      : super(key: key);

  @override
  _SignInRegisterButtonsState createState() => _SignInRegisterButtonsState();
}

class _SignInRegisterButtonsState extends State<SignInRegisterButtons> {
  Color theme1 = const Color(0xff5f433f);
  Color theme2 = const Color(0xff8e6d58);
  Color butUnhovered = const Color(0xff5f433f);
  Color butHovered = const Color(0xff8e6d58);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    String text = widget.text;
    return GestureDetector(
      onTap: () {
        String userName = widget.userNameController.text;
        String email = widget.emailController.text;
        String password = widget.passwordController.text;
        if (widget.text == 'Register') {
          widget.auth.registerUser(userName, email, password);
          Navigator.of(context).pushNamed('/homepage', arguments: '');
        } else {
          widget.auth.signInEmailPass(userName, email, password);
          Navigator.of(context).pushNamed('/homepage', arguments: '');
        }
      },
      child: MouseRegion(
        onEnter: (f) {
          setState(() {
            butUnhovered = theme2;
            butHovered = theme1;
          });
        },
        onExit: (f) {
          setState(() {
            butUnhovered = theme1;
            butHovered = theme2;
          });
        },
        child: Container(
          alignment: Alignment.center,
          height: screenHeight * 0.065,
          width: screenHeight * 0.14,
          decoration: BoxDecoration(
              color: butUnhovered,
              borderRadius:
              BorderRadius.all(Radius.circular(screenHeight * 0.002)),
              border: Border.all(color: theme2, width: screenHeight * 0.002)),
          child: Text(
            text,
            style: TextStyle(
                color: butHovered,
                fontFamily: 'ol',
                fontSize: screenHeight * 0.024),
          ),
        ),
      ),
    );
  }
}
