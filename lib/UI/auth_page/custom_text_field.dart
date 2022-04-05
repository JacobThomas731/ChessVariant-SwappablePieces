import 'package:flutter/material.dart';

class CustomTextField {
  Color theme1 = const Color(0xff5f433f);
  Color theme2 = const Color(0xff8e6d58);
  late double screenHeight;
  late double screenWidth;
  late String text;
  TextEditingController textEditingController;

  CustomTextField(BuildContext context, this.textEditingController, this.text) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }

  Widget tField() {
    return MediaQuery(
        data: const MediaQueryData(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(screenHeight * 0.07,
              screenHeight * 0.007, screenHeight * 0.07, screenHeight * 0.007),
          child: TextField(
            controller: textEditingController,
            cursorColor: theme2,
            style: TextStyle(
                color: const Color(0xff8e6d58),
                fontFamily: 'ol',
                fontSize: screenHeight * 0.03),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical: 0, horizontal: screenHeight * 0.024),
                enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(screenHeight * 0.002)),
                    borderSide:
                    BorderSide(color: theme2, width: screenHeight * 0.002)),
                focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(screenHeight * 0.002)),
                    borderSide:
                    BorderSide(color: theme2, width: screenHeight * 0.002)),
                labelText: text,
                labelStyle: TextStyle(
                    color: const Color(0xff8e6d58),
                    fontFamily: 'ol',
                    fontSize: screenHeight * 0.02)),
          ),
        ));
  }
}
