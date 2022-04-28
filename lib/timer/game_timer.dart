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
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.075,
        // width: MediaQuery.of(context).size.width * 0.175,
        // color background
        color: const Color(0xff3f2c2d),
        child: Row(
          children: <Widget>[
            // TextButton(
            //   onPressed: () {
            //     startTimer();
            //   },
            //   child: const Text(
            //     "start",
            //     style: TextStyle(color: Colors.green),
            //   ),
            // ),
            // display the current value of the timer in hours:minutes
            Text(
              "  Timer:         ",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.025,
                color: Color(0xcc8e6d58),
              ),
            ),
            Center(
              child: Text(
                '${_start ~/ 60}:${_start % 60}',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.025 * 2,
                  color: Color(0xcc8e6d58),
                ),
              ),
            ),
            // pause button
            // TextButton(
            //   onPressed: () {
            //     _timer.cancel();
            //   },
            //   child: const Text(
            //     "pause",
            //     style: TextStyle(color: Colors.red),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
