import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  final String text;
  final String pageRoute;

  const MenuButton({
    Key? key,
    required this.text,
    required this.pageRoute,
  }) : super(key: key);

  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  Color defaultButColor = const Color(0x618e6d58);
  Color pressButColor = const Color(0xcc8e6d58);
  Color hoverButColor = const Color(0xcc8e6d58);
  Color butColor = const Color(0x618e6d58);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = const Color(0xff372a2c);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTapDown: (f) {
        setState(() {
          butColor = pressButColor;
        });
        Navigator.of(context).pushNamed(widget.pageRoute);
      },
      onTapUp: (f) {
        setState(() {
          butColor = defaultButColor;
        });
      },
      onTapCancel: () {
        setState(() {
          butColor = defaultButColor;
        });
      },
      child: MouseRegion(
        onHover: (e) {
          setState(() {
            butColor = hoverButColor;
          });
        },
        onExit: (e) {
          setState(() {
            butColor = defaultButColor;
          });
        },
        child: Container(
          height: screenHeight * 0.083,
          width: screenWidth * 0.21,
          color: butColor,
          child: Center(
              child: Text(
            widget.text,
            style: TextStyle(
                color: textColor,
                fontFamily: 'om',
                fontSize: screenWidth * 0.018,
                letterSpacing: -0.5),
          )),
        ),
      ),
    );
  }
}
