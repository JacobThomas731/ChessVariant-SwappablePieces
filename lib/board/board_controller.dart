import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
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
  int tempCounter = -1;
  var db = FirebaseFirestore.instance.collection('test').doc('game');
  bool firstClick = false;
  int firebaseCounter = 1;

  BoardController(this.color, this.mode) {
    // if (color == 'white') {
    pieceSquareMap = mapPieceSquare();
    initializeMoves();
    //print('start time');
    //delay(5200);
    //print('end time');
    //firebase2game();
    // }

    chessBoardUi = ChessBoardUi(color, pieceSquareMap, this);
    // refreshCallback = chessBoardUi.refresh;
    // firebase2game();
    // initialization stuff.
    // 1) Set up the pieceSquareMap Map
    // 2) Update the chess_board_ui with the new board setup
  }

  void delay(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
    await Future.delayed(const Duration(seconds: 5), () {});
  }

  void initializeMoves() async {
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
    if (firstClick == false) {
      firebase2game();
      firstClick = true;
    }
  }

  ChessBoardUi getChessBoardUiObj() {
    return chessBoardUi;
  }

  bool onPressed(Square square) {
    bool changed = false;
    if (whichColorTurn == color) {
      // then only proceed with the accepting the clicks
      // don't forget to toggle the whichColorTurn
      if (suggestionShowing) {
        if (square.position != clickedPiece.position &&
            suggestionList.containsKey(square.position) &&
            clickedPiece.pieceSide == whichColorTurn) {
          if (suggestionList[square.position] == 'movable') {
            //String tempPiece = square.piece;
            db.update({
              square.position: clickedPiece.piece,
              clickedPiece.position: square.piece
            });
            //movePieces(square, clickedPiece);
          } else if (suggestionList[square.position] == 'capturable') {
            capturePieces(square, clickedPiece);
          }
          //game2firebase();
          //whichColorTurn = whichColorTurn == 'white' ? 'black' : 'white';
          //print('turn swapped to $whichColorTurn');
          changed = true;
        } else {
          print('same move pressed');
        }
        suggestionList = {};
        suggestionShowing = suggestionShowing ? false : true;
        //
      } else {
        if (square.pieceSide == whichColorTurn) {
          clickedPiece = square;
          makeSuggestion();
          suggestionShowing = suggestionShowing ? false : true;
        }
      }
      modifySuggestionUI(); // changes the suggestions in the UI

    }
    // else {
    //ignore the clicks as it is not my turn

    // }

    //whichColorTurn = whichColorTurn == 'white' ? 'black' : 'white';

    return changed;
  }

  void firebase2game() {
    //toggle the turnColor on listening
    var snaps =
        FirebaseFirestore.instance.collection('test').doc('game').snapshots();

    snaps.listen((event) {
      tempCounter++;
      if (tempCounter > 0 && tempCounter % 2 == 1) {
        whichColorTurn = whichColorTurn == 'white' ? 'black' : 'white';
        //print('turn swapped to $whichColorTurn $tempCounter');
      }
      print(firebaseCounter++);
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          String currentKey = i.toString() + j.toString();
          if (pieceSquareMap[currentKey]?.piece !=
              event.data()![currentKey] as String) {
            tempCounter++;

            //print(event.data()![currentKey] as String);
            pieceSquareMap[currentKey]
                ?.setPiece(event.data()![currentKey] as String);
            //chessBoardUi.pieceSquareMap[currentKey]
            //?.setPiece(event.data()![currentKey] as String);
          }
        }
      }
      chessBoardUi.refresh();
    });
  }

  // void game2firebase() async {
  //   var db = FirebaseFirestore.instance.collection('test').doc('game');

  //   var data = await db.get();
  //   var key1 = '', key2;
  //   var value1, value2;
  //   for (int i = 0; i < 8; i++) {
  //     for (int j = 0; j < 8; j++) {
  //       String currentKey = i.toString() + j.toString();
  //       if (data[currentKey] != pieceSquareMap[currentKey]?.piece) {
  //         if (key1 == '') {
  //           key1 = currentKey;
  //           value1 = pieceSquareMap[currentKey]?.piece;
  //         } else {
  //           key2 = currentKey;
  //           value2 = pieceSquareMap[currentKey]?.piece;
  //         }
  //       }
  //     }
  //   }
  //   db.update({key1: value1, key2: value2});

  //   // firebase2game();
  // }

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
    //firebase2game();
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
