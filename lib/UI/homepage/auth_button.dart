import 'package:flutter/material.dart';
import 'package:chess_variant_swappable_pieces/authentication/authentication.dart';

class AuthButton extends StatefulWidget {
  final String text;
  final Authentication auth = Authentication();

  AuthButton({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  _AuthButtonState createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  Color defaultTextColor = const Color(0xff8e6d58);
  Color pressTextColor = const Color(0xff8e6d58);
  Color hoverTextColor = const Color(0xff9C8369);
  Color textColor = const Color(0xff8e6d58);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (widget.text == 'Sign-Out') {
          widget.auth.signOut();
          Navigator.of(context).pushNamed('/', arguments: '');
        }
      },
      child: MouseRegion(
        onHover: (e) {
          setState(() {
            if (widget.text != '|') {
              textColor = hoverTextColor;
            }
          });
        },
        onExit: (e) {
          setState(() {
            textColor = defaultTextColor;
          });
        },
        child: Text(
          widget.text,
          style: TextStyle(
            color: textColor,
            fontFamily: 'o',
            fontSize: screenWidth * 0.024,
          ),
        ),
      ),
    );
  }
}
