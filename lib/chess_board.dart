import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  var firstClick = '';
  var secondClick = '';
  var whitesTurn = true;
  var possibleMoves = {};
  var possibleSwapMoves = {};
  var castle = true;
  var swapWhite = 3;
  var swapBlack = 3;
  var currStatus = {
    '00': 8,
    '01': 4,
    '02': 6,
    '03': 9,
    '04': 7,
    '05': 6,
    '06': 4,
    '07': 8,
    '10': 1,
    '11': 1,
    '12': 1,
    '13': 1,
    '14': 1,
    '15': 1,
    '16': 1,
    '17': 1,
    '20': 0,
    '21': 0,
    '22': 0,
    '23': 0,
    '24': 0,
    '25': 0,
    '26': 0,
    '27': 0,
    '30': 0,
    '31': 0,
    '32': 0,
    '33': 0,
    '34': 0,
    '35': 0,
    '36': 0,
    '37': 0,
    '40': 0,
    '41': 0,
    '42': 0,
    '43': 0,
    '44': 0,
    '45': 0,
    '46': 0,
    '47': 0,
    '50': 0,
    '51': 0,
    '52': 0,
    '53': 0,
    '54': 0,
    '55': 0,
    '56': 0,
    '57': 0,
    '60': -1,
    '61': -1,
    '62': -1,
    '63': -1,
    '64': -1,
    '65': -1,
    '66': -1,
    '67': -1,
    '70': -8,
    '71': -4,
    '72': -6,
    '73': -9,
    '74': -7,
    '75': -6,
    '76': -4,
    '77': -8,
  };
  var screenHeight;
  var screenWidth;
  var boardLength;
  var boardSquare;
  var textStream;
  var boardPadding = 100.0;
  var counter = 0;

  // var count = 0;

  @override
  void initState() {
    if (kDebugMode) {
      print('called once');
    }
    initialize();
    super.initState();
  }

  void initialize() async {
    //data fetches the data to compare and avoid unnecessary duplicate writes
    var data = await FirebaseFirestore.instance
        .collection('test')
        .doc('game')
        .get()
        .then((value) => value.data());
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        var ij = (i).toString() + (j).toString();
        if (data![ij] != currStatus[ij]) {
          if (kDebugMode) {
            print('updated');
          }
          game2firebase(ij, ij);
        }
      }
    }
    if (kDebugMode) {
      print('Initialize');
    }
  }

  void firebase2game() {
    FirebaseFirestore.instance
        .collection('test')
        .doc('game')
        .snapshots()
        .listen((event) {
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          var ij = i.toString() + j.toString();
          if (currStatus[ij] != event.data()![ij]) {
            currStatus[ij] = event.data()![ij];
          }
        }
      }
      if (kDebugMode) {
        print('firebase2game');
      }
      // setState(() {});
    });
  }

  void game2firebase(String ij1, ij2) {
    var db = FirebaseFirestore.instance.collection('test').doc('game');
    if (ij1 == ij2) {
      db.update({ij1: currStatus[ij1]});
    } else {
      db.update({ij1: currStatus[ij1], ij2: currStatus[ij2]});
    }
    if (kDebugMode) {
      print('game2firebase');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Rebuild');
    }
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    boardLength = screenHeight < screenWidth ? screenHeight : screenWidth;
    boardLength = boardLength - boardPadding;
    boardSquare = boardLength / 8;

    // firebase2game();
    return TimerBuilder.periodic(
        const Duration(seconds: 1), //updates every second
        builder: (context) {
      firebase2game();
      return Stack(children: [
        const Image(
          image: AssetImage('assets/homepage/homeScreen_background.png'),
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        Center(
          child: Container(
            color: Colors.brown[700],
            height: boardLength,
            width: boardLength,
            child: Column(
              children: [
                for (int i = 0; i < 8; i++)
                  Row(
                    children: [
                      for (int j = 0; j < 8; j++)
                        GestureDetector(
                          onTap: () {
                            var ij = i.toString() + j.toString();
                            if (firstClick == '') {
                              if (currStatus[ij]! > 0) {
                                whitesTurn = true;
                              } else if (currStatus[ij]! < 0) {
                                whitesTurn = false;
                              }
                            }
                            if (whitesTurn) {
                              if (currStatus[ij]! > 0) {
                                // if (currStatus[ij]! > 0 || currStatus[ij]! < 0) {
                                setState(() {
                                  if (firstClick == ij) {
                                    firstClick = '';
                                    possibleMoves = {};
                                    possibleSwapMoves = {};
                                  } else if (possibleSwapMoves[ij] == 1) {
                                    swapWhite--;
                                    var temp = currStatus[ij]!;
                                    currStatus[ij] = currStatus[firstClick]!;
                                    currStatus[firstClick] = temp;
                                    game2firebase(ij, firstClick);
                                    firstClick = '';
                                    secondClick = '';
                                    possibleMoves = {};
                                    possibleSwapMoves = {};
                                    whitesTurn = !whitesTurn;
                                  } else {
                                    firstClick = ij;
                                    possibleMoves = {};
                                    possibleSwapMoves = {};
                                    updateSuggestions(i, j);
                                  }
                                });
                              } else if (firstClick != '' &&
                                  possibleMoves[ij] != null) {
                                setState(() {
                                  secondClick = ij;
                                  currStatus[secondClick] =
                                      currStatus[firstClick]!;
                                  currStatus[firstClick] = 0;
                                  game2firebase(ij, firstClick);
                                  firstClick = '';
                                  whitesTurn = false;
                                  possibleMoves = {};
                                  possibleSwapMoves = {};
                                });
                              } else {
                                setState(() {
                                  firstClick = '';
                                  secondClick = '';
                                  possibleMoves = {};
                                  possibleSwapMoves = {};
                                  if (kDebugMode) {
                                    print("moved5");
                                  }
                                });
                              }
                            } else {
                              //black's turn
                              if (currStatus[ij]! < 0) {
                                setState(() {
                                  if (firstClick == ij) {
                                    firstClick = '';
                                    possibleMoves = {};
                                    possibleSwapMoves = {};
                                  } else if (possibleSwapMoves[ij] == 1) {
                                    swapBlack--;
                                    var temp = currStatus[ij]!;
                                    currStatus[ij] = currStatus[firstClick]!;
                                    currStatus[firstClick] = temp;
                                    game2firebase(ij, firstClick);
                                    firstClick = '';
                                    secondClick = '';
                                    possibleMoves = {};
                                    possibleSwapMoves = {};
                                    whitesTurn = !whitesTurn;
                                  } else {
                                    firstClick = ij;
                                    possibleMoves = {};
                                    possibleSwapMoves = {};
                                    updateSuggestions(i, j);
                                  }
                                });
                              } else if (firstClick != '' &&
                                  possibleMoves[ij] != null) {
                                setState(() {
                                  secondClick = ij;
                                  currStatus[secondClick] =
                                      currStatus[firstClick]!;
                                  currStatus[firstClick] = 0;
                                  game2firebase(ij, firstClick);
                                  firstClick = '';
                                  whitesTurn = true;
                                  possibleMoves = {};
                                  possibleSwapMoves = {};
                                });
                              } else {
                                setState(() {
                                  firstClick = '';
                                  secondClick = '';
                                  possibleMoves = {};
                                  possibleSwapMoves = {};
                                });
                              }
                            }
                          },
                          child: Container(
                            height: boardSquare,
                            width: boardSquare,
                            color: tileColor(i, j),
                            alignment: Alignment.center,
                            child: Image(
                              image: AssetImage(
                                piece(i, j),
                              ),
                              height: boardSquare / 1.45,
                              width: boardSquare / 1.45,
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ]);
    });
  }

  String piece(int i, int j) {
    var ij = i.toString() + j.toString();
    if (currStatus[ij] == 8) {
      return 'assets/pro/wR.png';
    } else if (currStatus[ij] == 4) {
      return 'assets/pro/wN.png';
    } else if (currStatus[ij] == 6) {
      return 'assets/pro/wB.png';
    } else if (currStatus[ij] == 9) {
      return 'assets/pro/wQ.png';
    } else if (currStatus[ij] == 7) {
      return 'assets/pro/wK.png';
    } else if (currStatus[ij] == 1) {
      return 'assets/pro/wP.png';
    } else if (currStatus[ij] == -8) {
      return 'assets/pro/bR.png';
    } else if (currStatus[ij] == -4) {
      return 'assets/pro/bN.png';
    } else if (currStatus[ij] == -6) {
      return 'assets/pro/bB.png';
    } else if (currStatus[ij] == -9) {
      return 'assets/pro/bQ.png';
    } else if (currStatus[ij] == -7) {
      return 'assets/pro/bK.png';
    } else if (currStatus[ij] == -1) {
      return 'assets/pro/bP.png';
    } else {
      return 'assets/images/empty.png';
    }
  }

  Color tileColor(int i, int j) {
    var ij = i.toString() + j.toString();
    if ((possibleMoves[ij] == 1) && currStatus[ij] != 0) {
      return Colors.red;
    } else if (possibleMoves[ij] == 1 || possibleSwapMoves[ij] == 1) {
      return Colors.green;
    }
    // make current click yellow
    else if (ij == firstClick) {
      return Colors.yellow;
    } else if ((i + j) % 2 == 0) {
      return Colors.brown.shade700;
    } else {
      return Colors.brown.shade300;
    }
  }

  void resetSuggestions() {}

  void updateSuggestions(int i, int j) {
    var ij = i.toString() + j.toString();

    if (currStatus[ij]! == 1) {
      //white pawn
      if (currStatus[(i + 1).toString() + j.toString()]! == 0) {
        possibleMoves[(i + 1).toString() + j.toString()] = 1;
        if (i == 1 && currStatus[(i + 2).toString() + j.toString()]! == 0) {
          possibleMoves[(i + 2).toString() + j.toString()] = 1;
        }
      }
      if (j + 1 < 8 &&
          currStatus[(i + 1).toString() + (j + 1).toString()]! < 0) {
        //right
        possibleMoves[(i + 1).toString() + (j + 1).toString()] = 1;
      }
      if (j - 1 > -1 &&
          currStatus[(i + 1).toString() + (j - 1).toString()]! < 0) {
        //left
        possibleMoves[(i + 1).toString() + (j - 1).toString()] = 1;
      }
    }
    if (currStatus[ij]! == -1) {
      //black pawn
      if (currStatus[(i - 1).toString() + j.toString()]! == 0) {
        //up
        possibleMoves[(i - 1).toString() + j.toString()] = 1;
        if (i == 6 && currStatus[(i - 2).toString() + j.toString()]! == 0) {
          possibleMoves[(i - 2).toString() + j.toString()] = 1;
        }
      }
      if (j + 1 < 8 &&
          currStatus[(i - 1).toString() + (j + 1).toString()]! > 0) {
        //right
        possibleMoves[(i - 1).toString() + (j + 1).toString()] = 1;
      }
      if (j - 1 > -1 &&
          currStatus[(i - 1).toString() + (j - 1).toString()]! > 0) {
        //left
        possibleMoves[(i - 1).toString() + (j - 1).toString()] = 1;
      }
    }
    if (currStatus[ij] == 6) {
      //white bishop
      // add rook and knite positions to possible moves
      if (swapWhite > 0) {
        for (int k1 = 0; k1 < 8; k1++) {
          for (int k2 = 0; k2 < 8; k2++) {
            if (currStatus[k1.toString() + k2.toString()] == 8 ||
                currStatus[k1.toString() + k2.toString()] == 4) {
              possibleSwapMoves[k1.toString() + k2.toString()] = 1;
            }
          }
        }
      }
      for (int k = 1; k < 8; k++) {
        //up right
        if ((i + k > 7 ||
            j + k > 7 ||
            currStatus[(i + k).toString() + (j + k).toString()]! > 0)) {
          //out of bounds
          break;
        }
        if (currStatus[(i + k).toString() + (j + k).toString()]! < 0) {
          possibleMoves[(i + k).toString() + (j + k).toString()] = 1;
          break;
        }
        possibleMoves[(i + k).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            j - k < 0 ||
            currStatus[(i - k).toString() + (j - k).toString()]! > 0)) {
          break;
        } else if (currStatus[(i - k).toString() + (j - k).toString()]! < 0) {
          possibleMoves[(i - k).toString() + (j - k).toString()] = 1;
          break;
        }
        possibleMoves[(i - k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((j - k < 0 ||
            i + k > 7 ||
            currStatus[(i + k).toString() + (j - k).toString()]! > 0)) {
          break;
        } else if (currStatus[(i + k).toString() + (j - k).toString()]! < 0) {
          possibleMoves[(i + k).toString() + (j - k).toString()] = 1;
          break;
        }
        possibleMoves[(i + k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((i - k < 0 ||
            j + k > 7 ||
            currStatus[(i - k).toString() + (j + k).toString()]! > 0)) {
          break;
        } else if (currStatus[(i - k).toString() + (j + k).toString()]! < 0) {
          possibleMoves[(i - k).toString() + (j + k).toString()] = 1;
          break;
        }
        possibleMoves[(i - k).toString() + (j + k).toString()] = 1;
      }
    }
    if (currStatus[ij] == -6) {
      //black bishop
      // add rook positions to possible moves
      if (swapBlack > 0) {
        for (int k1 = 0; k1 < 8; k1++) {
          for (int k2 = 0; k2 < 8; k2++) {
            if (currStatus[k1.toString() + k2.toString()] == -8 ||
                currStatus[k1.toString() + k2.toString()] == -4) {
              possibleSwapMoves[k1.toString() + k2.toString()] = 1;
            }
          }
        }
      }
      for (int k = 1; k < 8; k++) {
        if ((i + k > 7 ||
            j + k > 7 ||
            currStatus[(i + k).toString() + (j + k).toString()]! < 0)) {
          break;
        }
        if (currStatus[(i + k).toString() + (j + k).toString()]! > 0) {
          possibleMoves[(i + k).toString() + (j + k).toString()] = 1;
          break;
        }
        possibleMoves[(i + k).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            j - k < 0 ||
            currStatus[(i - k).toString() + (j - k).toString()]! < 0)) {
          break;
        } else if (currStatus[(i - k).toString() + (j - k).toString()]! > 0) {
          possibleMoves[(i - k).toString() + (j - k).toString()] = 1;
          break;
        }
        possibleMoves[(i - k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((j - k < 0 ||
            i + k > 7 ||
            currStatus[(i + k).toString() + (j - k).toString()]! < 0)) {
          break;
        } else if (currStatus[(i + k).toString() + (j - k).toString()]! > 0) {
          possibleMoves[(i + k).toString() + (j - k).toString()] = 1;
          break;
        }
        possibleMoves[(i + k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((i - k < 0 ||
            j + k > 7 ||
            currStatus[(i - k).toString() + (j + k).toString()]! < 0)) {
          break;
        } else if (currStatus[(i - k).toString() + (j + k).toString()]! > 0) {
          possibleMoves[(i - k).toString() + (j + k).toString()] = 1;
          break;
        }
        possibleMoves[(i - k).toString() + (j + k).toString()] = 1;
      }
    }
    if (currStatus[ij] == 8) {
      //white rook
      // add bishop positions to possible moves
      if (swapWhite > 0) {
        for (int k1 = 0; k1 < 8; k1++) {
          for (int k2 = 0; k2 < 8; k2++) {
            if (currStatus[k1.toString() + k2.toString()] == 6 ||
                currStatus[k1.toString() + k2.toString()] == 4) {
              possibleSwapMoves[k1.toString() + k2.toString()] = 1;
            }
          }
        }
      }
      for (int k = 1; k < 8; k++) {
        if ((i + k > 7 ||
            currStatus[(i + k).toString() + (j).toString()]! > 0)) {
          break;
        } else if (currStatus[(i + k).toString() + (j).toString()]! < 0) {
          possibleMoves[(i + k).toString() + (j).toString()] = 1;
          break;
        }
        possibleMoves[(i + k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            currStatus[(i - k).toString() + (j).toString()]! > 0)) {
          break;
        } else if (currStatus[(i - k).toString() + (j).toString()]! < 0) {
          possibleMoves[(i - k).toString() + (j).toString()] = 1;
          break;
        }
        possibleMoves[(i - k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j + k > 7 ||
            currStatus[(i).toString() + (j + k).toString()]! > 0)) {
          break;
        } else if (currStatus[(i).toString() + (j + k).toString()]! < 0) {
          possibleMoves[(i).toString() + (j + k).toString()] = 1;
          break;
        }
        possibleMoves[(i).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j - k < 0 ||
            currStatus[(i).toString() + (j - k).toString()]! > 0)) {
          break;
        } else if (currStatus[(i).toString() + (j - k).toString()]! < 0) {
          possibleMoves[(i).toString() + (j - k).toString()] = 1;
          break;
        }
        possibleMoves[(i).toString() + (j - k).toString()] = 1;
      }
    }
    if (currStatus[ij] == -8) {
      //black rook
      // add bishop positions to possible moves
      if (swapBlack > 0) {
        for (int k1 = 0; k1 < 8; k1++) {
          for (int k2 = 0; k2 < 8; k2++) {
            if (currStatus[k1.toString() + k2.toString()] == -6 ||
                currStatus[k1.toString() + k2.toString()] == -4) {
              possibleSwapMoves[k1.toString() + k2.toString()] = 1;
            }
          }
        }
      }
      for (int k = 1; k < 8; k++) {
        if ((i + k > 7 ||
            currStatus[(i + k).toString() + (j).toString()]! < 0)) {
          break;
        } else if (currStatus[(i + k).toString() + (j).toString()]! < 0) {
          possibleMoves[(i + k).toString() + (j).toString()] = 1;
          break;
        }
        possibleMoves[(i + k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            currStatus[(i - k).toString() + (j).toString()]! < 0)) {
          break;
        } else if (currStatus[(i - k).toString() + (j).toString()]! < 0) {
          possibleMoves[(i - k).toString() + (j).toString()] = 1;
          break;
        }
        possibleMoves[(i - k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j + k > 7 ||
            currStatus[(i).toString() + (j + k).toString()]! < 0)) {
          break;
        } else if (currStatus[(i).toString() + (j + k).toString()]! < 0) {
          possibleMoves[(i).toString() + (j + k).toString()] = 1;
          break;
        }
        possibleMoves[(i).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j - k < 0 ||
            currStatus[(i).toString() + (j - k).toString()]! < 0)) {
          break;
        } else if (currStatus[(i).toString() + (j - k).toString()]! < 0) {
          possibleMoves[(i).toString() + (j - k).toString()] = 1;
          break;
        }
        possibleMoves[(i).toString() + (j - k).toString()] = 1;
      }
    }
    if (currStatus[ij] == 9) {
      //white queen
      for (int k = 1; k < 8; k++) {
        if ((i + k > 7 ||
            j + k > 7 ||
            currStatus[(i + k).toString() + (j + k).toString()]! > 0)) {
          break;
        }
        if (currStatus[(i + k).toString() + (j + k).toString()]! < 0) {
          possibleMoves[(i + k).toString() + (j + k).toString()] = 1;
          break;
        }
        possibleMoves[(i + k).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            j - k < 0 ||
            currStatus[(i - k).toString() + (j - k).toString()]! > 0)) {
          break;
        } else if (currStatus[(i - k).toString() + (j - k).toString()]! < 0) {
          possibleMoves[(i - k).toString() + (j - k).toString()] = 1;
          break;
        }
        possibleMoves[(i - k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((j - k < 0 ||
            i + k > 7 ||
            currStatus[(i + k).toString() + (j - k).toString()]! > 0)) {
          break;
        } else if (currStatus[(i + k).toString() + (j - k).toString()]! < 0) {
          possibleMoves[(i + k).toString() + (j - k).toString()] = 1;
          break;
        }
        possibleMoves[(i + k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((i - k < 0 ||
            j + k > 7 ||
            currStatus[(i - k).toString() + (j + k).toString()]! > 0)) {
          break;
        } else if (currStatus[(i - k).toString() + (j + k).toString()]! < 0) {
          possibleMoves[(i - k).toString() + (j + k).toString()] = 1;
          break;
        }
        possibleMoves[(i - k).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i + k > 7 ||
            currStatus[(i + k).toString() + (j).toString()]! > 0)) {
          break;
        } else if (currStatus[(i + k).toString() + (j).toString()]! < 0) {
          possibleMoves[(i + k).toString() + (j).toString()] = 1;
          break;
        }
        possibleMoves[(i + k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            currStatus[(i - k).toString() + (j).toString()]! > 0)) {
          break;
        } else if (currStatus[(i - k).toString() + (j).toString()]! < 0) {
          possibleMoves[(i - k).toString() + (j).toString()] = 1;
          break;
        }
        possibleMoves[(i - k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j + k > 7 ||
            currStatus[(i).toString() + (j + k).toString()]! > 0)) {
          break;
        } else if (currStatus[(i).toString() + (j + k).toString()]! < 0) {
          possibleMoves[(i).toString() + (j + k).toString()] = 1;
          break;
        }
        possibleMoves[(i).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j - k < 0 ||
            currStatus[(i).toString() + (j - k).toString()]! > 0)) {
          break;
        } else if (currStatus[(i).toString() + (j - k).toString()]! < 0) {
          possibleMoves[(i).toString() + (j - k).toString()] = 1;
          break;
        }
        possibleMoves[(i).toString() + (j - k).toString()] = 1;
      }
    }
    if (currStatus[ij] == -9) {
      //black queen
      for (int k = 1; k < 8; k++) {
        if ((i + k > 7 ||
            j + k > 7 ||
            currStatus[(i + k).toString() + (j + k).toString()]! < 0)) {
          break;
        }
        if (currStatus[(i + k).toString() + (j + k).toString()]! > 0) {
          possibleMoves[(i + k).toString() + (j + k).toString()] = 1;
          break;
        }
        possibleMoves[(i + k).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            j - k < 0 ||
            currStatus[(i - k).toString() + (j - k).toString()]! < 0)) {
          break;
        } else if (currStatus[(i - k).toString() + (j - k).toString()]! > 0) {
          possibleMoves[(i - k).toString() + (j - k).toString()] = 1;
          break;
        }
        possibleMoves[(i - k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((j - k < 0 ||
            i + k > 7 ||
            currStatus[(i + k).toString() + (j - k).toString()]! < 0)) {
          break;
        } else if (currStatus[(i + k).toString() + (j - k).toString()]! > 0) {
          possibleMoves[(i + k).toString() + (j - k).toString()] = 1;
          break;
        }
        possibleMoves[(i + k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((j + k > 7 ||
            i - k < 0 ||
            currStatus[(i - k).toString() + (j + k).toString()]! < 0)) {
          break;
        } else if (currStatus[(i - k).toString() + (j + k).toString()]! > 0) {
          possibleMoves[(i - k).toString() + (j + k).toString()] = 1;
          break;
        }
        possibleMoves[(i - k).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i + k > 7 ||
            currStatus[(i + k).toString() + (j).toString()]! < 0)) {
          break;
        } else if (currStatus[(i + k).toString() + (j).toString()]! > 0) {
          possibleMoves[(i + k).toString() + (j).toString()] = 1;
          break;
        }
        possibleMoves[(i + k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            currStatus[(i - k).toString() + (j).toString()]! < 0)) {
          break;
        } else if (currStatus[(i - k).toString() + (j).toString()]! > 0) {
          possibleMoves[(i - k).toString() + (j).toString()] = 1;
          break;
        }
        possibleMoves[(i - k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j + k > 7 ||
            currStatus[(i).toString() + (j + k).toString()]! < 0)) {
          break;
        } else if (currStatus[(i).toString() + (j + k).toString()]! > 0) {
          possibleMoves[(i).toString() + (j + k).toString()] = 1;
          break;
        }
        possibleMoves[(i).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j - k < 0 ||
            currStatus[(i).toString() + (j - k).toString()]! < 0)) {
          break;
        } else if (currStatus[(i).toString() + (j - k).toString()]! > 0) {
          possibleMoves[(i).toString() + (j - k).toString()] = 1;
          break;
        }
        possibleMoves[(i).toString() + (j - k).toString()] = 1;
      }
    }
    if (currStatus[ij] == 7) {
      //white king
      if (i + 1 < 8 &&
          j - 1 > -1 &&
          currStatus[(i + 1).toString() + (j - 1).toString()]! < 1) {
        possibleMoves[(i + 1).toString() + (j - 1).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j + 1 > 8 &&
          currStatus[(i - 1).toString() + (j + 1).toString()]! < 1) {
        possibleMoves[(i - 1).toString() + (j + 1).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j - 1 < -1 &&
          currStatus[(i - 1).toString() + (j - 1).toString()]! < 1) {
        possibleMoves[(i - 1).toString() + (j - 1).toString()] = 1;
      }
      if (i + 1 < 8 &&
          j + 1 > 8 &&
          currStatus[(i + 1).toString() + (j + 1).toString()]! < 1) {
        possibleMoves[(i + 1).toString() + (j + 1).toString()] = 1;
      }
      if (i + 1 < 8 && currStatus[(i + 1).toString() + j.toString()]! < 1) {
        possibleMoves[(i + 1).toString() + j.toString()] = 1;
      }
      if (i - 1 > -1 && currStatus[(i - 1).toString() + j.toString()]! < 1) {
        possibleMoves[(i - 1).toString() + j.toString()] = 1;
      }
      if (j + 1 < 8 && currStatus[i.toString() + (j + 1).toString()]! < 1) {
        possibleMoves[i.toString() + (j + 1).toString()] = 1;
      }
      if (j - 1 > -1 && currStatus[i.toString() + (j - 1).toString()]! < 1) {
        possibleMoves[i.toString() + (j - 1).toString()] = 1;
      }
    }
    if (currStatus[ij] == -7) {
      if (i + 1 < 8 &&
          j - 1 > -1 &&
          currStatus[(i + 1).toString() + (j - 1).toString()]! > 1) {
        possibleMoves[(i + 1).toString() + (j - 1).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j + 1 > 8 &&
          currStatus[(i - 1).toString() + (j + 1).toString()]! > 1) {
        possibleMoves[(i - 1).toString() + (j + 1).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j - 1 < -1 &&
          currStatus[(i - 1).toString() + (j - 1).toString()]! > 1) {
        possibleMoves[(i - 1).toString() + (j - 1).toString()] = 1;
      }
      if (i + 1 < 8 &&
          j + 1 > 8 &&
          currStatus[(i + 1).toString() + (j + 1).toString()]! > 1) {
        possibleMoves[(i + 1).toString() + (j + 1).toString()] = 1;
      }
      if (i + 1 < 8 && currStatus[(i + 1).toString() + j.toString()]! > 1) {
        possibleMoves[(i + 1).toString() + j.toString()] = 1;
      }
      if (i - 1 > -1 && currStatus[(i - 1).toString() + j.toString()]! > 1) {
        possibleMoves[(i - 1).toString() + j.toString()] = 1;
      }
      if (j + 1 < 8 && currStatus[i.toString() + (j + 1).toString()]! > 1) {
        possibleMoves[i.toString() + (j + 1).toString()] = 1;
      }
      if (j - 1 > -1 && currStatus[i.toString() + (j - 1).toString()]! > 1) {
        possibleMoves[i.toString() + (j - 1).toString()] = 1;
      }
    }
    if (currStatus[ij] == 4) {
      //white knight
      if (swapWhite > 0) {
        for (int k1 = 0; k1 < 8; k1++) {
          for (int k2 = 0; k2 < 8; k2++) {
            if (currStatus[k1.toString() + k2.toString()] == 8 ||
                currStatus[k1.toString() + k2.toString()] == 6) {
              possibleSwapMoves[k1.toString() + k2.toString()] = 1;
            }
          }
        }
      }

      if (i + 2 < 8 &&
          j + 1 < 8 &&
          currStatus[(i + 2).toString() + (j + 1).toString()]! < 1) {
        possibleMoves[(i + 2).toString() + (j + 1).toString()] = 1;
      }
      if (i + 2 < 8 &&
          j - 1 > -1 &&
          currStatus[(i + 2).toString() + (j - 1).toString()]! < 1) {
        possibleMoves[(i + 2).toString() + (j - 1).toString()] = 1;
      }
      if (i - 2 > -1 &&
          j + 1 < 8 &&
          currStatus[(i - 2).toString() + (j + 1).toString()]! < 1) {
        possibleMoves[(i - 2).toString() + (j + 1).toString()] = 1;
      }
      if (i - 2 > -1 &&
          j - 1 > -1 &&
          currStatus[(i - 2).toString() + (j - 1).toString()]! < 1) {
        possibleMoves[(i - 2).toString() + (j - 1).toString()] = 1;
      }
      if (i + 1 < 8 &&
          j + 2 < 8 &&
          currStatus[(i + 1).toString() + (j + 2).toString()]! < 1) {
        possibleMoves[(i + 1).toString() + (j + 2).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j + 2 < 8 &&
          currStatus[(i - 1).toString() + (j + 2).toString()]! < 1) {
        possibleMoves[(i - 1).toString() + (j + 2).toString()] = 1;
      }
      if (i + 1 < 8 &&
          j - 2 > -1 &&
          currStatus[(i + 1).toString() + (j - 2).toString()]! < 1) {
        possibleMoves[(i + 1).toString() + (j - 2).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j - 2 > -1 &&
          currStatus[(i - 1).toString() + (j - 2).toString()]! < 1) {
        possibleMoves[(i - 1).toString() + (j - 2).toString()] = 1;
      }
    }
    if (currStatus[ij] == -4) {
      //black knight

      if (swapBlack > 0) {
        for (int k1 = 0; k1 < 8; k1++) {
          for (int k2 = 0; k2 < 8; k2++) {
            if (currStatus[k1.toString() + k2.toString()] == -8 ||
                currStatus[k1.toString() + k2.toString()] == -6) {
              possibleSwapMoves[k1.toString() + k2.toString()] = 1;
            }
          }
        }
      }
      if (i + 2 < 8 &&
          j + 1 < 8 &&
          currStatus[(i + 2).toString() + (j + 1).toString()]! > -1) {
        possibleMoves[(i + 2).toString() + (j + 1).toString()] = 1;
      }
      if (i + 2 < 8 &&
          j - 1 > -1 &&
          currStatus[(i + 2).toString() + (j - 1).toString()]! > -1) {
        possibleMoves[(i + 2).toString() + (j - 1).toString()] = 1;
      }
      if (i - 2 > -1 &&
          j + 1 < 8 &&
          currStatus[(i - 2).toString() + (j + 1).toString()]! > -1) {
        possibleMoves[(i - 2).toString() + (j + 1).toString()] = 1;
      }
      if (i - 2 > -1 &&
          j - 1 > -1 &&
          currStatus[(i - 2).toString() + (j - 1).toString()]! > -1) {
        possibleMoves[(i - 2).toString() + (j - 1).toString()] = 1;
      }
      if (i + 1 < 8 &&
          j + 2 < 8 &&
          currStatus[(i + 1).toString() + (j + 2).toString()]! > -1) {
        possibleMoves[(i + 1).toString() + (j + 2).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j + 2 < 8 &&
          currStatus[(i - 1).toString() + (j + 2).toString()]! > -1) {
        possibleMoves[(i - 1).toString() + (j + 2).toString()] = 1;
      }
      if (i + 1 < 8 &&
          j - 2 > -1 &&
          currStatus[(i + 1).toString() + (j - 2).toString()]! > -1) {
        possibleMoves[(i + 1).toString() + (j - 2).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j - 2 > -1 &&
          currStatus[(i - 1).toString() + (j - 2).toString()]! > -1) {
        possibleMoves[(i - 1).toString() + (j - 2).toString()] = 1;
      }
    }
  }
}
