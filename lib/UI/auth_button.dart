import 'package:flutter/material.dart';

class AuthButton extends StatefulWidget {
  final String text;

  const AuthButton({
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return MouseRegion(
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
    );
  }
}
