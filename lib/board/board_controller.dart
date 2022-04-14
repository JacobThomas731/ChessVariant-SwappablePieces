import 'package:chess_variant_swappable_pieces/UI/board/chess_board_ui.dart';

class BoardController {
  final String color;
  int swapsAvailable = 3;
  bool suggestionShowing = false;
  late ChessBoardUi chessBoardUi;
  String mode;
  Map<int, String> pieceSquareMap = {};

  BoardController(this.color, this.mode) {
    chessBoardUi = ChessBoardUi(color, this);
    // initialization stuff.
    // 1) Set up the pieceSquareMap Map
    // 2) Update the chess_board_ui with the new board setup
  }

  ChessBoardUi initialize() {
    return chessBoardUi;
  }

  void onPressed(String position) {
    if (suggestionShowing) {
      // if second click is on valid suggestion then play the move
    } else {
      // if click is on player's piece then show suggestions
    }
  }
}
