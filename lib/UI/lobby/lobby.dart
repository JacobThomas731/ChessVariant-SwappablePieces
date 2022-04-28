import 'package:flutter/material.dart';

class Lobby extends StatefulWidget {
  String gameTime; // createGame or playGame
  Lobby(this.gameTime, {Key? key}) : super(key: key);

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
