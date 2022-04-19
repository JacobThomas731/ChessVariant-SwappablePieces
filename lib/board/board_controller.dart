import 'dart:math';

import 'package:chess_variant_swappable_pieces/UI/board/chess_board_ui.dart';
import 'package:chess_variant_swappable_pieces/board/square.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/painting/image_resolution.dart';

class BoardController {
  final String color; // my game color, white or black
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

  BoardController(this.color, this.mode) {
    // if (color == 'white') {
    pieceSquareMap = mapPieceSquare();
    game2firebase();

    // }

    chessBoardUi = ChessBoardUi(color, pieceSquareMap, this);
    // refreshCallback = chessBoardUi.refresh;
    // firebase2game();
    // initialization stuff.
    // 1) Set up the pieceSquareMap Map
    // 2) Update the chess_board_ui with the new board setup
  }

  void initialize() async {}

  ChessBoardUi getChessBoardUiObj() {
    return chessBoardUi;
  }

  bool onPressed(Square square) {

    bool changed = false;
    // if (whichColorTurn == color) {
    // then only proceed with the accepting the clicks
    // don't forget to toggle the whichColorTurn
    if (suggestionShowing) {
      AssetImage tempImage = square.image;
      String tempPiece = square.piece;
      square.image = clickedPiece.image;
      square.piece = clickedPiece.piece;
      clickedPiece.image = tempImage;
      clickedPiece.piece = tempPiece;

      //swapPieces(square, clickedPiece);
      changed = true;
      suggestionList = {};
      game2firebase();
      //whichColorTurn = whichColorTurn == 'white' ? 'black' : 'white';
    } else {
      clickedPiece = square;
      makeSuggestion();
      
    }
    suggestionShowing = suggestionShowing ? false : true;
    // }
    // else {
    //ignore the clicks as it is not my turn

    // }
    modifySuggestionUI(); // changes the suggestions in the UI

    //whichColorTurn = whichColorTurn == 'white' ? 'black' : 'white';
    if (suggestionShowing) {
      // if second click is on valid suggestion then play the move
    } else {
      // if click is on player's piece then show suggestions
    }
    firebase2game();
    return changed;
  }

  void firebase2game() {
    //toggle the turnColor on listening
    var snaps =
        FirebaseFirestore.instance.collection('test').doc('game').snapshots();

    snaps.listen((event) {
      print('firebase2game');
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          String currentKey = i.toString() + j.toString();
          if (pieceSquareMap[currentKey]?.piece !=
              event.data()![currentKey] as String) {
            pieceSquareMap[currentKey]
                ?.setPiece(event.data()![currentKey] as String);
            chessBoardUi.pieceSquareMap[currentKey]
                ?.setPiece(event.data()![currentKey] as String);
          }
        }
      }
      chessBoardUi.refresh();
    });
  }

  void swapPieces(Square s1, Square s2) {
    AssetImage tempImage = s1.image;
    String tempPiece = s1.piece;
    s1.image = s2.image;
    s1.piece = s2.piece;
    s2.image = tempImage;
    s2.piece = tempPiece;
  }

  void game2firebase() async {
    var db = FirebaseFirestore.instance.collection('test').doc('game');

    var data = await db.get();
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        String currentKey = i.toString() + j.toString();
        if (data[currentKey] != pieceSquareMap[currentKey]?.piece) {
          db.update({currentKey: pieceSquareMap[currentKey]?.piece}
          );
        }
      }
    }
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

  Map<String, Square> mapPieceSquare() {
    Map<String, Square> pieceSquareMap = {};
    String color;
    for (int i = 2; i < 6; i++) {
      for (int j = 0; j < 8; j++) {
        color = (i + j) % 2 == 0 ? 'black' : 'white';
        String ij = i.toString() + j.toString();
        pieceSquareMap[ij] = Square(color, ij, 'empty', false,
            const AssetImage('assets/images/empty.png'), this);
      }
    }
    pieceSquareMap['00'] = Square(
        'Black', '00', 'bR', true, const AssetImage('assets/pro/bR.png'), this);
    pieceSquareMap['01'] = Square(
        'White', '01', 'bN', true, const AssetImage('assets/pro/bN.png'), this);
    pieceSquareMap['02'] = Square(
        'Black', '02', 'bB', true, const AssetImage('assets/pro/bB.png'), this);
    pieceSquareMap['03'] = Square(
        'White', '03', 'bQ', true, const AssetImage('assets/pro/bQ.png'), this);
    pieceSquareMap['04'] = Square(
        'Black', '04', 'bK', true, const AssetImage('assets/pro/bK.png'), this);
    pieceSquareMap['05'] = Square(
        'White', '05', 'bB', true, const AssetImage('assets/pro/bB.png'), this);
    pieceSquareMap['06'] = Square(
        'Black', '06', 'bN', true, const AssetImage('assets/pro/bN.png'), this);
    pieceSquareMap['07'] = Square(
        'White', '07', 'bR', true, const AssetImage('assets/pro/bR.png'), this);
    pieceSquareMap['10'] = Square(
        'Black', '10', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['11'] = Square(
        'White', '11', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['12'] = Square(
        'Black', '12', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['13'] = Square(
        'White', '13', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['14'] = Square(
        'Black', '14', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['15'] = Square(
        'White', '15', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['16'] = Square(
        'Black', '16', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['17'] = Square(
        'White', '17', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['60'] = Square(
        'Black', '60', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['61'] = Square(
        'White', '61', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['62'] = Square(
        'Black', '62', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['63'] = Square(
        'White', '63', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['64'] = Square(
        'Black', '64', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['65'] = Square(
        'White', '65', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['66'] = Square(
        'Black', '66', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['67'] = Square(
        'White', '67', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['70'] = Square(
        'Black', '70', 'wR', true, const AssetImage('assets/pro/wR.png'), this);
    pieceSquareMap['71'] = Square(
        'White', '71', 'wN', true, const AssetImage('assets/pro/wN.png'), this);
    pieceSquareMap['72'] = Square(
        'Black', '72', 'wB', true, const AssetImage('assets/pro/wB.png'), this);
    pieceSquareMap['73'] = Square(
        'Black', '73', 'wQ', true, const AssetImage('assets/pro/wQ.png'), this);
    pieceSquareMap['74'] = Square(
        'White', '74', 'wK', true, const AssetImage('assets/pro/wK.png'), this);
    pieceSquareMap['75'] = Square(
        'Black', '75', 'wB', true, const AssetImage('assets/pro/wB.png'), this);
    pieceSquareMap['76'] = Square(
        'White', '76', 'wN', true, const AssetImage('assets/pro/wN.png'), this);
    pieceSquareMap['77'] = Square(
        'Black', '77', 'wR', true, const AssetImage('assets/pro/wR.png'), this);

    return pieceSquareMap;
  }

  void makeSuggestion() {
    if (clickedPiece.piece == 'bP') {
      bPawnSuggestion();
    }
    if (clickedPiece.piece == 'wP') {
      wPawnSuggestion();
    }
    if (clickedPiece.piece == 'bR' || clickedPiece.piece == 'wR') {
      rookSuggestion();
    }
    if (clickedPiece.piece == 'bN' || clickedPiece.piece == 'wN') {
      knightSuggestion();
    }
    if (clickedPiece.piece == 'bB' || clickedPiece.piece == 'wB') {
      bishopSuggestion();
    }
    if (clickedPiece.piece == 'bQ' || clickedPiece.piece == 'wQ') {
      queenSuggestion();
    }
    if (clickedPiece.piece == 'bK' || clickedPiece.piece == 'wK') {
      kingSuggestion();
    }
  }

  void bPawnSuggestion() {
    // movable
    if (clickedPiece.position[0] == '1') {
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

  void wPawnSuggestion() {
    // movable
    if (clickedPiece.position[0] == '6') {
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

  void kingSuggestion() {
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

  void queenSuggestion() {
    rookSuggestion();
    bishopSuggestion();
  }

  void knightSuggestion() {
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

  void bishopSuggestion() {
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

  void rookSuggestion() {
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
}
