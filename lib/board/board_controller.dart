import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chess_variant_swappable_pieces/board/square.dart';
import 'package:chess_variant_swappable_pieces/UI/board/chess_board_ui.dart';

// // // // import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/src/painting/image_resolution.dart';
// import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

class BoardController {
  String color; // my game color, white or black
  String whichColorTurn = 'white'; //whose turn it is, black or white
  int swapsAvailable = 3;
  bool suggestionShowing =
      false; // if true, means suggestions are CURRENTLY shown
  Map<String, String> suggestionList = {}; // shows list of move suggestions
  late Square clickedPiece; // previously clicked piece
  late ChessBoardUi chessBoardUi;
  String mode; // normal, swappable, bishop pair
  var pinSuggestion; // for pin detection
  Map<String, Square> pieceSquareMap = {}; // maintains Main square-piece map
  // late var refreshCallback;
  int tempCounter = -1;
  var db = FirebaseFirestore.instance.collection('test').doc('game');
  var snaps =
      FirebaseFirestore.instance.collection('test').doc('game').snapshots();
  bool firstClick = false;
  int firebaseCounter = 1;
  Map<String, String> allAttacksPossible = {};
  var swapCounter = 3;

  BoardController(this.color, this.mode) {
    color = 'white';
    pieceSquareMap = mapPieceSquare();
    if (color == 'black') {
      pieceSquareMap = invertMapPieceSquare();
    }
    initializeMoves();
    chessBoardUi = ChessBoardUi(color, pieceSquareMap, this, 300);
  }

  void delay(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
    await Future.delayed(const Duration(seconds: 5), () {});
  }

  void initializeMoves() async {
    var data = await db.get();
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        String currentKey = i.toString() + j.toString();
        if (color == 'white') {
          if (data[currentKey] != pieceSquareMap[currentKey]?.piece) {
            await db.update({currentKey: pieceSquareMap[currentKey]?.piece});
          }
        } else {
          String currentInvertedKey =
              ((7 - i)).toString() + ((7 - j)).toString();
          if (data[currentKey] != pieceSquareMap[currentInvertedKey]?.piece) {
            await db.update(
                {currentKey: pieceSquareMap[currentInvertedKey]?.piece});
          }
        }
      }
    }
    firebase2game();
  }

  ChessBoardUi getChessBoardUiObj() {
    return chessBoardUi;
  }

  String getInvertedPositions(String position) {
    String invertedPosition = (7 - (int.parse(position[0]))).toString() +
        (7 - (int.parse(position[1]))).toString();

    return invertedPosition;
  }

  bool onPressed(Square square) {
    bool changed = false;
    if (whichColorTurn == color) {
      // then only proceed with the accepting the clicks
      // don't forget to toggle the whichColorTurn
      if (color == 'black') {
        square.position = getInvertedPositions(square.position);
      }
      // print('Hi');
      // print(square.position);
      if (suggestionShowing) {
        if (square.position != clickedPiece.position &&
            suggestionList.containsKey(square.position) &&
            clickedPiece.pieceSide == whichColorTurn) {
          if (suggestionList[square.position] == 'movable' ||
              suggestionList[square.position] == 'swappable') {
            if (color == 'black') {
              db.update({
                getInvertedPositions(square.position): clickedPiece.piece,
                clickedPiece.position: square.piece
              });
            } else {
              db.update({
                square.position: clickedPiece.piece,
                clickedPiece.position: square.piece
              });
            }
            //movePieces(square, clickedPiece);
          } else if (suggestionList[square.position] == 'capturable') {
            if (color == 'black') {
              db.update({
                getInvertedPositions(square.position): clickedPiece.piece,
                clickedPiece.position: 'empty'
              });
            } else {
              // capturePieces(square, clickedPiece);
              db.update({
                square.position: clickedPiece.piece,
                clickedPiece.position: 'empty'
              });
            }
          }
          changed = true;
        } else {}

        suggestionList = {};
        suggestionShowing = suggestionShowing ? false : true;

        //
      } else {
        if (square.pieceSide == whichColorTurn) {
          clickedPiece = square;

          makeSuggestion();
          suggestionList.addAll({square.position: 'self'});
          print(suggestionList);
          suggestionShowing = suggestionShowing ? false : true;
        }
      }

      modifySuggestionUI(); // changes the suggestions in the UI
      if (color == 'black') {
        square.position = getInvertedPositions(square.position);
      }
    }

    return changed;
  }

  void firebase2game() {
    //toggle the turnColor on listening
    snaps.listen((event) {
      if (tempCounter != -1) {
        whichColorTurn = whichColorTurn == 'white' ? 'black' : 'white';
        // print('turn swapped to $whichColorTurn $tempCounter');
      }
      tempCounter++;
      // print(firebaseCounter++);
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          String currentKey = i.toString() + j.toString();
          if (color == 'white') {
            if (pieceSquareMap[currentKey]?.piece !=
                event.data()![currentKey] as String) {
              pieceSquareMap[currentKey]
                  ?.setPiece(event.data()![currentKey] as String);
            }
          } else {
            String currentInvertedKey = (7 - i).toString() + (7 - j).toString();
            if (pieceSquareMap[currentKey]?.piece !=
                event.data()![currentInvertedKey] as String) {
              pieceSquareMap[currentKey]
                  ?.setPiece(event.data()![currentInvertedKey] as String);
            }
          }
        }
      }
      if (tempCounter > 0) {
        print('called');
        if (whichColorTurn == 'white') {
          chessBoardUi.blackTimer.pause();
          chessBoardUi.whiteTimer.start();
        } else {
          if (tempCounter > 1) {
            chessBoardUi.whiteTimer.pause();
          }
          chessBoardUi.blackTimer.start();
        }
      }
      chessBoardUi.refresh();

      print(chessBoardUi.whiteTimer);
    });
  }

  void game2firebase() async {
    var db = FirebaseFirestore.instance.collection('test').doc('game');

    var data = await db.get();
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        String currentKey = i.toString() + j.toString();
        if (data[currentKey] != pieceSquareMap[currentKey]?.piece) {
          db.update({currentKey: pieceSquareMap[currentKey]?.piece});
        }
      }
    }
  }

  void movePieces(Square s1, Square s2) {
    String tempPiece = s1.piece;
    s1.setPiece(s2.piece);
    s2.setPiece(tempPiece);
  }

  void capturePieces(Square s1, Square s2) {
    s1.setPiece(s2.piece);
    s2.setPiece('empty');
  }

  void modifySuggestionUI() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        String currentKey = i.toString() + j.toString();
        Square tempSquare = pieceSquareMap[currentKey]!;
        if (suggestionList.containsKey(currentKey)) {
          tempSquare.suggestionMode = suggestionList[currentKey]!;
        } else {
          tempSquare.suggestionMode = 'null';
        }
      }
    }
  }

  Map<String, Square> invertMapPieceSquare() {
    Map<String, Square> pieceSquareMapInverted = {};
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        String current = i.toString() + j.toString();
        String currentInverted = (7 - i).toString() + (7 - j).toString();
        pieceSquareMapInverted[currentInverted] = pieceSquareMap[current]!;
      }
    }
    return pieceSquareMapInverted;
  }

  Map<String, Square> mapPieceSquare() {
    Map<String, Square> pieceSquareMap = {};
    String color;
    for (int i = 2; i < 6; i++) {
      for (int j = 0; j < 8; j++) {
        color = (i + j) % 2 == 0 ? 'black' : 'white';
        String ij = i.toString() + j.toString();
        pieceSquareMap[ij] = Square(color, ij, 'empty', false,
            const AssetImage('assets/images/empty.png'), 'empty', this);
      }
    }
    pieceSquareMap['00'] = Square('Black', '00', 'bR', true,
        const AssetImage('assets/pro/bR.png'), 'black', this);
    pieceSquareMap['01'] = Square('White', '01', 'bN', true,
        const AssetImage('assets/pro/bN.png'), 'black', this);
    pieceSquareMap['02'] = Square('Black', '02', 'bB', true,
        const AssetImage('assets/pro/bB.png'), 'black', this);
    pieceSquareMap['03'] = Square('White', '03', 'bQ', true,
        const AssetImage('assets/pro/bQ.png'), 'black', this);
    pieceSquareMap['04'] = Square('Black', '04', 'bK', true,
        const AssetImage('assets/pro/bK.png'), 'black', this);
    pieceSquareMap['05'] = Square('White', '05', 'bB', true,
        const AssetImage('assets/pro/bB.png'), 'black', this);
    pieceSquareMap['06'] = Square('Black', '06', 'bN', true,
        const AssetImage('assets/pro/bN.png'), 'black', this);
    pieceSquareMap['07'] = Square('White', '07', 'bR', true,
        const AssetImage('assets/pro/bR.png'), 'black', this);
    pieceSquareMap['10'] = Square('Black', '10', 'bP', true,
        const AssetImage('assets/pro/bP.png'), 'black', this);
    pieceSquareMap['11'] = Square('White', '11', 'bP', true,
        const AssetImage('assets/pro/bP.png'), 'black', this);
    pieceSquareMap['12'] = Square('Black', '12', 'bP', true,
        const AssetImage('assets/pro/bP.png'), 'black', this);
    pieceSquareMap['13'] = Square('White', '13', 'bP', true,
        const AssetImage('assets/pro/bP.png'), 'black', this);
    pieceSquareMap['14'] = Square('Black', '14', 'bP', true,
        const AssetImage('assets/pro/bP.png'), 'black', this);
    pieceSquareMap['15'] = Square('White', '15', 'bP', true,
        const AssetImage('assets/pro/bP.png'), 'black', this);
    pieceSquareMap['16'] = Square('Black', '16', 'bP', true,
        const AssetImage('assets/pro/bP.png'), 'black', this);
    pieceSquareMap['17'] = Square('White', '17', 'bP', true,
        const AssetImage('assets/pro/bP.png'), 'black', this);
    pieceSquareMap['60'] = Square('Black', '60', 'wP', true,
        const AssetImage('assets/pro/wP.png'), 'white', this);
    pieceSquareMap['61'] = Square('White', '61', 'wP', true,
        const AssetImage('assets/pro/wP.png'), 'white', this);
    pieceSquareMap['62'] = Square('Black', '62', 'wP', true,
        const AssetImage('assets/pro/wP.png'), 'white', this);
    pieceSquareMap['63'] = Square('White', '63', 'wP', true,
        const AssetImage('assets/pro/wP.png'), 'white', this);
    pieceSquareMap['64'] = Square('Black', '64', 'wP', true,
        const AssetImage('assets/pro/wP.png'), 'white', this);
    pieceSquareMap['65'] = Square('White', '65', 'wP', true,
        const AssetImage('assets/pro/wP.png'), 'white', this);
    pieceSquareMap['66'] = Square('Black', '66', 'wP', true,
        const AssetImage('assets/pro/wP.png'), 'white', this);
    pieceSquareMap['67'] = Square('White', '67', 'wP', true,
        const AssetImage('assets/pro/wP.png'), 'white', this);
    pieceSquareMap['70'] = Square('Black', '70', 'wR', true,
        const AssetImage('assets/pro/wR.png'), 'white', this);
    pieceSquareMap['71'] = Square('White', '71', 'wN', true,
        const AssetImage('assets/pro/wN.png'), 'white', this);
    pieceSquareMap['72'] = Square('Black', '72', 'wB', true,
        const AssetImage('assets/pro/wB.png'), 'white', this);
    pieceSquareMap['73'] = Square('Black', '73', 'wQ', true,
        const AssetImage('assets/pro/wQ.png'), 'white', this);
    pieceSquareMap['74'] = Square('White', '74', 'wK', true,
        const AssetImage('assets/pro/wK.png'), 'white', this);
    pieceSquareMap['75'] = Square('Black', '75', 'wB', true,
        const AssetImage('assets/pro/wB.png'), 'white', this);
    pieceSquareMap['76'] = Square('White', '76', 'wN', true,
        const AssetImage('assets/pro/wN.png'), 'white', this);
    pieceSquareMap['77'] = Square('Black', '77', 'wR', true,
        const AssetImage('assets/pro/wR.png'), 'white', this);

    return pieceSquareMap;
  }

  void inverseSuggestion() {
    Map<String, String> suggestionListInverse = {};
    suggestionList.forEach((key, value) {
      suggestionListInverse[getInvertedPositions(key)] = value;
    });
    suggestionList = suggestionListInverse;
  }

  void makeSuggestion() {
    if (clickedPiece.piece == 'bP') {
      uPawnSuggestion(clickedPiece);
    }
    if (clickedPiece.piece == 'wP') {
      uPawnSuggestion(clickedPiece);
    }
    if (clickedPiece.piece == 'bR' || clickedPiece.piece == 'wR') {
      rookSuggestion(clickedPiece);
    }
    if (clickedPiece.piece == 'bN' || clickedPiece.piece == 'wN') {
      knightSuggestion(clickedPiece);
    }
    if (clickedPiece.piece == 'bB' || clickedPiece.piece == 'wB') {
      bishopSuggestion(clickedPiece);
    }
    if (clickedPiece.piece == 'bQ' || clickedPiece.piece == 'wQ') {
      queenSuggestion(clickedPiece);
    }
    if (clickedPiece.piece == 'bK' || clickedPiece.piece == 'wK') {
      kingSuggestion(clickedPiece);
    }
    if (mode == 'swappable') {
      swapSuggestion();
    }
  }

  void uPawnSuggestion(clickedPiece) {
    // movable
    if (clickedPiece.position[0] == '6' || clickedPiece.position[0] == '1') {
      var pos = positionChange(clickedPiece.position, -1, 0);
      if (pieceSquareMap[pos]?.piece == 'empty') {
        suggestionList[pos] = 'movable';
        pos = positionChange(clickedPiece.position, -2, 0);
        if (pieceSquareMap[pos]?.piece == 'empty') {
          suggestionList[pos] = 'movable';
        }
      } else {
        pos = positionChange(clickedPiece.position, -1, 0);
        if (pieceSquareMap[pos]?.piece == 'empty') {
          suggestionList[pos] = 'movable';
        }
      }
    } else {
      var pos = positionChange(clickedPiece.position, -1, 0);
      if (pieceSquareMap[pos]?.piece == 'empty') {
        suggestionList[pos] = 'movable';
      }
    }
    // capturable
    var pos = positionChange(clickedPiece.position, -1, 1);
    if (pieceSquareMap[pos]?.piece != 'empty' &&
        pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, -1, -1);
    if (pieceSquareMap[pos]?.piece != 'empty' &&
        pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
  }

  void dPawnSuggestion(clickedPiece) {
    // movable
    if (clickedPiece.position[0] == '6' || clickedPiece.position[0] == '1') {
      var pos = positionChange(clickedPiece.position, 1, 0);
      if (pieceSquareMap[pos]?.piece == 'empty') {
        suggestionList[pos] = 'movable';
        pos = positionChange(clickedPiece.position, 2, 0);
        if (pieceSquareMap[pos]?.piece == 'empty') {
          suggestionList[pos] = 'movable';
        }
      } else {
        pos = positionChange(clickedPiece.position, 1, 0);
        if (pieceSquareMap[pos]?.piece == 'empty') {
          suggestionList[pos] = 'movable';
        }
      }
    } else {
      var pos = positionChange(clickedPiece.position, 1, 0);
      if (pieceSquareMap[pos]?.piece == 'empty') {
        suggestionList[pos] = 'movable';
      }
    }

    // capturable
    var pos = positionChange(clickedPiece.position, 1, 1);
    if (pieceSquareMap[pos]?.piece != 'empty' &&
        pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, 1, -1);
    if (pieceSquareMap[pos]?.piece != 'empty' &&
        pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
  }

  void kingSuggestion(clickedPiece) {
    var pos = positionChange(clickedPiece.position, 1, 1);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, 1, -1);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, -1, 1);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, -1, -1);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, 0, 1);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, 0, -1);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, 1, 0);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, -1, 0);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
  }

  void queenSuggestion(clickedPiece) {
    rookSuggestion(clickedPiece);
    bishopSuggestion(clickedPiece);
  }

  void knightSuggestion(clickedPiece) {
    var pos = positionChange(clickedPiece.position, 1, 2);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, 1, -2);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, -1, 2);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, -1, -2);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, 2, 1);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, 2, -1);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, -2, 1);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, -2, -1);
    if (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
    } else if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
  }

  void bishopSuggestion(clickedPiece) {
    var pos = positionChange(clickedPiece.position, 1, 1);
    while (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
      pos = positionChange(pos, 1, 1);
    }
    if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, 1, -1);
    while (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
      pos = positionChange(pos, 1, -1);
    }
    if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, -1, 1);
    while (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
      pos = positionChange(pos, -1, 1);
    }
    if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, -1, -1);
    while (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
      pos = positionChange(pos, -1, -1);
    }
    if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
  }

  void rookSuggestion(clickedPiece) {
    var pos = positionChange(clickedPiece.position, 1, 0);
    while (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
      pos = positionChange(pos, 1, 0);
    }
    if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, -1, 0);
    while (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
      pos = positionChange(pos, -1, 0);
    }
    if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, 0, 1);
    while (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
      pos = positionChange(pos, 0, 1);
    }
    if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
    pos = positionChange(clickedPiece.position, 0, -1);
    while (pieceSquareMap[pos]?.piece == 'empty') {
      suggestionList[pos] = 'movable';
      pos = positionChange(pos, 0, -1);
    }
    if (pieceSquareMap[pos]?.piece[0] != clickedPiece.piece[0]) {
      suggestionList[pos] = 'capturable';
    }
  }

  String positionChange(pos, r, c) {
    pos =
        (int.parse(pos[0]) + r).toString() + (int.parse(pos[1]) + c).toString();
    return pos;
  }

  void allAttackable(colorTurn) {
    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        var pos = i.toString() + j.toString();
        if (pieceSquareMap[pos]?.piece[0] != colorTurn[0]) {
          if (pieceSquareMap[pos]?.piece[1] == 'P') {
            dPawnSuggestion(pieceSquareMap[pos]);
          } else if (pieceSquareMap[pos]?.piece[1] == 'R') {
            rookSuggestion(pieceSquareMap[pos]);
          } else if (pieceSquareMap[pos]?.piece[1] == 'B') {
            bishopSuggestion(pieceSquareMap[pos]);
          } else if (pieceSquareMap[pos]?.piece[1] == 'N') {
            knightSuggestion(pieceSquareMap[pos]);
          } else if (pieceSquareMap[pos]?.piece[1] == 'Q') {
            queenSuggestion(pieceSquareMap[pos]);
          } else if (pieceSquareMap[pos]?.piece[1] == 'K') {
            kingSuggestion(pieceSquareMap[pos]);
          }
        }
      }
    }
    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        var pos = i.toString() + j.toString();
        if (suggestionList[pos] == 'capturable') {
          allAttacksPossible[pos] = 'capturable';
        }
      }
    }
    // print(suggestionList);
    // print(allAttacksPossible);
    suggestionList.clear();
  }

  void ckeckPrint() {
    allAttackable('black');
    allAttackable('white');
    // print(allAttacksPossible);
    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        var pos = i.toString() + j.toString();
        if (pieceSquareMap[pos]?.piece[1] == 'K') {
          if (allAttacksPossible[pos] == 'capturable') {
            print('check');
            allAttacksPossible.clear();
            return;
          }
        }
      }
    }
  }

  void swapSuggestion() {
    if (swapCounter > 0 &&
        (pieceSquareMap[clickedPiece.position]?.piece == color[0] + 'R' ||
            pieceSquareMap[clickedPiece.position]?.piece == color[0] + 'B' ||
            pieceSquareMap[clickedPiece.position]?.piece == color[0] + 'N')) {
      for (var i = 0; i < 8; i++) {
        for (var j = 0; j < 8; j++) {
          var pos = i.toString() + j.toString();
          if (clickedPiece.position != pos &&
              (pieceSquareMap[pos]?.piece == color[0] + 'R' ||
                  pieceSquareMap[pos]?.piece == color[0] + 'B' ||
                  pieceSquareMap[pos]?.piece == color[0] + 'N')) {
            suggestionList[pos] = 'swappable';
          }
        }
      }
    }
  }
}
