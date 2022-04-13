class BoardController {
  final String color;
  bool suggestionShowing = false;

  BoardController(this.color);

  Map<int, String> pieceSquareMap = {};

  void onPressed(String position) {
    if (suggestionShowing) {
      // if second click is on valid suggestion then play the move
    } else {
      // if click is on player's piece then show suggestions
    }
  }
}
