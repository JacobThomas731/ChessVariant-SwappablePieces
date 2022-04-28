import 'dart:async';
import 'package:flutter/material.dart';

class GameTimer extends StatefulWidget {
  int time;
  late var start;
  late var pause;

  GameTimer(this.time, {Key? key}) : super(key: key);

  @override
  State<GameTimer> createState() {
    var object = _GameTimerState();
    object._start = time;
    start = object.startTimer;
    pause = object.dispose;
    return object;
  }
}

class _GameTimerState extends State<GameTimer> {
  late Timer _timer;
  int _start = 180;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
            print(_start);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Color boardColor = const Color(0xcc8e6d58);

    return Text('${_start ~/ 60}:${_start % 60}',
        style: TextStyle(
            fontSize: height * 0.04, fontFamily: 'ol', color: boardColor));
  }
}
