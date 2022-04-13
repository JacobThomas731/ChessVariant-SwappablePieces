import 'dart:collection';

class BoardState {
  LinkedHashMap coordinates;

  BoardState(this.coordinates);

  //return the map
  LinkedHashMap getBoardMap() {
    return coordinates;
  }

  // check if on check
  bool isCheck() {
    // logic for check
    return false;
  }

  //check if checkmate
  bool isCheckMate() {
    // logic for checkmate
    return false;
  }

  //check if stalemate
  bool isStaleMate() {
    // logic for stalemate
    return false;
  }

  //check is the game is going on
  bool inPlay() {
    //logic for in play
    return true;
  }
}
