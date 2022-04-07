import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  var first_click = '';
  var second_click = '';
  var whites_turn = true;
  var possible_moves = {};
  var possible_swap_moves = {};
  var castle = true;
  var swap_white = 3;
  var swap_black = 3;
  var curr_status = {
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
  var boardPadding = 100.0;
  var textStream;
  var counter = 0;
  var flag = 0;

  @override
  void initState() {
    print('called once');
    initialize();
  }

  void initialize() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        var ij = (i).toString() + (j).toString();
        game2firebase(ij, ij);
      }
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
          if (curr_status[ij] != event.data()![ij]) {
            curr_status[ij] = event.data()![ij];
            setState(() {});
          }
        }
      }
    });
  }

  void game2firebase(String ij1, ij2) {
    FirebaseFirestore.instance
        .collection('test')
        .doc('game')
        .update({ij1: curr_status[ij1], ij2: curr_status[ij2]});
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    boardLength = screenHeight < screenWidth ? screenHeight : screenWidth;
    boardLength = boardLength - boardPadding;
    boardSquare = boardLength / 8;

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
                          // if (whites_turn) {
                          if (whites_turn || !whites_turn) {
                            if (curr_status[ij]! > 0) {
                              setState(() {
                                if (first_click == ij) {
                                  first_click = '';
                                  possible_moves = {};
                                  possible_swap_moves = {};
                                  print("moved1");
                                } else if (possible_swap_moves[ij] == 1) {
                                  swap_white--;
                                  var temp = curr_status[ij]!;
                                  curr_status[ij] = curr_status[first_click]!;
                                  curr_status[first_click] = temp;
                                  game2firebase(ij, first_click);
                                  first_click = '';
                                  second_click = '';
                                  possible_moves = {};
                                  possible_swap_moves = {};
                                  whites_turn = !whites_turn;
                                  print("moved2");
                                } else {
                                  first_click = ij;
                                  possible_moves = {};
                                  possible_swap_moves = {};
                                  update_suggestions(i, j);
                                  print("moved3");
                                }
                              });
                            } else if (first_click != '' &&
                                possible_moves[ij] != null) {
                              setState(() {
                                second_click = ij;
                                curr_status[second_click] =
                                    curr_status[first_click]!;
                                curr_status[first_click] = 0;
                                game2firebase(ij, first_click);
                                first_click = '';
                                whites_turn = false;
                                possible_moves = {};
                                possible_swap_moves = {};
                                print("moved4");
                              });
                            } else {
                              setState(() {
                                first_click = '';
                                second_click = '';
                                possible_moves = {};
                                possible_swap_moves = {};
                                print("moved5");
                              });
                            }
                            // } else {
                          }
                          if (whites_turn || !whites_turn) {
                            //black's turn
                            if (curr_status[ij]! < 0) {
                              setState(() {
                                if (first_click == ij) {
                                  first_click = '';
                                  possible_moves = {};
                                  possible_swap_moves = {};
                                } else if (possible_swap_moves[ij] == 1) {
                                  swap_black--;
                                  var temp = curr_status[ij]!;
                                  curr_status[ij] = curr_status[first_click]!;
                                  curr_status[first_click] = temp;
                                  game2firebase(ij, first_click);
                                  first_click = '';
                                  second_click = '';
                                  possible_moves = {};
                                  possible_swap_moves = {};
                                  whites_turn = !whites_turn;
                                } else {
                                  first_click = ij;
                                  possible_moves = {};
                                  possible_swap_moves = {};
                                  update_suggestions(i, j);
                                }
                              });
                            } else if (first_click != '' &&
                                possible_moves[ij] != null) {
                              setState(() {
                                second_click = ij;
                                curr_status[second_click] =
                                    curr_status[first_click]!;
                                curr_status[first_click] = 0;
                                game2firebase(ij, first_click);
                                first_click = '';
                                whites_turn = true;
                                possible_moves = {};
                                possible_swap_moves = {};
                              });
                            } else {
                              setState(() {
                                first_click = '';
                                second_click = '';
                                possible_moves = {};
                                possible_swap_moves = {};
                              });
                            }
                          }
                        },
                        child: Container(
                          height: boardSquare,
                          width: boardSquare,
                          color: tile_color(i, j),
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
  }

  String piece(int i, int j) {
    var ij = i.toString() + j.toString();
    if (curr_status[ij] == 8) {
      return 'assets/piro/wR.png';
    } else if (curr_status[ij] == 4) {
      return 'assets/piro/wN.png';
    } else if (curr_status[ij] == 6) {
      return 'assets/piro/wB.png';
    } else if (curr_status[ij] == 9) {
      return 'assets/piro/wQ.png';
    } else if (curr_status[ij] == 7) {
      return 'assets/piro/wK.png';
    } else if (curr_status[ij] == 1) {
      return 'assets/piro/wP.png';
    } else if (curr_status[ij] == -8) {
      return 'assets/piro/bR.png';
    } else if (curr_status[ij] == -4) {
      return 'assets/piro/bN.png';
    } else if (curr_status[ij] == -6) {
      return 'assets/piro/bB.png';
    } else if (curr_status[ij] == -9) {
      return 'assets/piro/bQ.png';
    } else if (curr_status[ij] == -7) {
      return 'assets/piro/bK.png';
    } else if (curr_status[ij] == -1) {
      return 'assets/piro/bP.png';
    } else {
      return 'assets/images/empty.png';
    }
  }

  Color tile_color(int i, int j) {
    var ij = i.toString() + j.toString();
    if ((possible_moves[ij] == 1) && curr_status[ij] != 0) {
      return Colors.red;
    } else if (possible_moves[ij] == 1 || possible_swap_moves[ij] == 1) {
      return Colors.green;
    }
    // make current click yellow
    else if (ij == first_click) {
      return Colors.yellow;
    } else if ((i + j) % 2 == 0) {
      return Colors.brown.shade700;
    } else {
      return Colors.brown.shade300;
    }
  }

  void reset_suggestions() {}

  void update_suggestions(int i, int j) {
    var ij = i.toString() + j.toString();

    if (curr_status[ij]! == 1) {
      //white pawn
      if (curr_status[(i + 1).toString() + j.toString()]! == 0) {
        possible_moves[(i + 1).toString() + j.toString()] = 1;
        if (i == 1 && curr_status[(i + 2).toString() + j.toString()]! == 0) {
          possible_moves[(i + 2).toString() + j.toString()] = 1;
        }
      }
      if (j + 1 < 8 &&
          curr_status[(i + 1).toString() + (j + 1).toString()]! < 0) {
        //right
        possible_moves[(i + 1).toString() + (j + 1).toString()] = 1;
      }
      if (j - 1 > -1 &&
          curr_status[(i + 1).toString() + (j - 1).toString()]! < 0) {
        //left
        possible_moves[(i + 1).toString() + (j - 1).toString()] = 1;
      }
    }
    if (curr_status[ij]! == -1) {
      //black pawn
      if (curr_status[(i - 1).toString() + j.toString()]! == 0) {
        //up
        possible_moves[(i - 1).toString() + j.toString()] = 1;
        if (i == 6 && curr_status[(i - 2).toString() + j.toString()]! == 0) {
          possible_moves[(i - 2).toString() + j.toString()] = 1;
        }
      }
      if (j + 1 < 8 &&
          curr_status[(i - 1).toString() + (j + 1).toString()]! > 0) {
        //right
        possible_moves[(i - 1).toString() + (j + 1).toString()] = 1;
      }
      if (j - 1 > -1 &&
          curr_status[(i - 1).toString() + (j - 1).toString()]! > 0) {
        //left
        possible_moves[(i - 1).toString() + (j - 1).toString()] = 1;
      }
    }
    if (curr_status[ij] == 6) {
      //white bishop
      // add rook and knite positions to possible moves
      if (swap_white > 0) {
        for (int k1 = 0; k1 < 8; k1++) {
          for (int k2 = 0; k2 < 8; k2++) {
            if (curr_status[k1.toString() + k2.toString()] == 8 ||
                curr_status[k1.toString() + k2.toString()] == 4) {
              possible_swap_moves[k1.toString() + k2.toString()] = 1;
            }
          }
        }
      }
      for (int k = 1; k < 8; k++) {
        //up right
        if ((i + k > 7 ||
            j + k > 7 ||
            curr_status[(i + k).toString() + (j + k).toString()]! > 0)) {
          //out of bounds
          break;
        }
        if (curr_status[(i + k).toString() + (j + k).toString()]! < 0) {
          possible_moves[(i + k).toString() + (j + k).toString()] = 1;
          break;
        }
        possible_moves[(i + k).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            j - k < 0 ||
            curr_status[(i - k).toString() + (j - k).toString()]! > 0)) {
          break;
        } else if (curr_status[(i - k).toString() + (j - k).toString()]! < 0) {
          possible_moves[(i - k).toString() + (j - k).toString()] = 1;
          break;
        }
        possible_moves[(i - k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((j - k < 0 ||
            i + k > 7 ||
            curr_status[(i + k).toString() + (j - k).toString()]! > 0)) {
          break;
        } else if (curr_status[(i + k).toString() + (j - k).toString()]! < 0) {
          possible_moves[(i + k).toString() + (j - k).toString()] = 1;
          break;
        }
        possible_moves[(i + k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((i - k < 0 ||
            j + k > 7 ||
            curr_status[(i - k).toString() + (j + k).toString()]! > 0)) {
          break;
        } else if (curr_status[(i - k).toString() + (j + k).toString()]! < 0) {
          possible_moves[(i - k).toString() + (j + k).toString()] = 1;
          break;
        }
        possible_moves[(i - k).toString() + (j + k).toString()] = 1;
      }
    }
    if (curr_status[ij] == -6) {
      //black bishop
      // add rook positions to possible moves
      if (swap_black > 0) {
        for (int k1 = 0; k1 < 8; k1++) {
          for (int k2 = 0; k2 < 8; k2++) {
            if (curr_status[k1.toString() + k2.toString()] == -8 ||
                curr_status[k1.toString() + k2.toString()] == -4) {
              possible_swap_moves[k1.toString() + k2.toString()] = 1;
            }
          }
        }
      }
      for (int k = 1; k < 8; k++) {
        if ((i + k > 7 ||
            j + k > 7 ||
            curr_status[(i + k).toString() + (j + k).toString()]! < 0)) {
          break;
        }
        if (curr_status[(i + k).toString() + (j + k).toString()]! > 0) {
          possible_moves[(i + k).toString() + (j + k).toString()] = 1;
          break;
        }
        possible_moves[(i + k).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            j - k < 0 ||
            curr_status[(i - k).toString() + (j - k).toString()]! < 0)) {
          break;
        } else if (curr_status[(i - k).toString() + (j - k).toString()]! > 0) {
          possible_moves[(i - k).toString() + (j - k).toString()] = 1;
          break;
        }
        possible_moves[(i - k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((j - k < 0 ||
            i + k > 7 ||
            curr_status[(i + k).toString() + (j - k).toString()]! < 0)) {
          break;
        } else if (curr_status[(i + k).toString() + (j - k).toString()]! > 0) {
          possible_moves[(i + k).toString() + (j - k).toString()] = 1;
          break;
        }
        possible_moves[(i + k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((i - k < 0 ||
            j + k > 7 ||
            curr_status[(i - k).toString() + (j + k).toString()]! < 0)) {
          break;
        } else if (curr_status[(i - k).toString() + (j + k).toString()]! > 0) {
          possible_moves[(i - k).toString() + (j + k).toString()] = 1;
          break;
        }
        possible_moves[(i - k).toString() + (j + k).toString()] = 1;
      }
    }
    if (curr_status[ij] == 8) {
      //white rook
      // add bishop positions to possible moves
      if (swap_white > 0) {
        for (int k1 = 0; k1 < 8; k1++) {
          for (int k2 = 0; k2 < 8; k2++) {
            if (curr_status[k1.toString() + k2.toString()] == 6 ||
                curr_status[k1.toString() + k2.toString()] == 4) {
              possible_swap_moves[k1.toString() + k2.toString()] = 1;
            }
          }
        }
      }
      for (int k = 1; k < 8; k++) {
        if ((i + k > 7 ||
            curr_status[(i + k).toString() + (j).toString()]! > 0)) {
          break;
        } else if (curr_status[(i + k).toString() + (j).toString()]! < 0) {
          possible_moves[(i + k).toString() + (j).toString()] = 1;
          break;
        }
        possible_moves[(i + k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            curr_status[(i - k).toString() + (j).toString()]! > 0)) {
          break;
        } else if (curr_status[(i - k).toString() + (j).toString()]! < 0) {
          possible_moves[(i - k).toString() + (j).toString()] = 1;
          break;
        }
        possible_moves[(i - k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j + k > 7 ||
            curr_status[(i).toString() + (j + k).toString()]! > 0)) {
          break;
        } else if (curr_status[(i).toString() + (j + k).toString()]! < 0) {
          possible_moves[(i).toString() + (j + k).toString()] = 1;
          break;
        }
        possible_moves[(i).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j - k < 0 ||
            curr_status[(i).toString() + (j - k).toString()]! > 0)) {
          break;
        } else if (curr_status[(i).toString() + (j - k).toString()]! < 0) {
          possible_moves[(i).toString() + (j - k).toString()] = 1;
          break;
        }
        possible_moves[(i).toString() + (j - k).toString()] = 1;
      }
    }
    if (curr_status[ij] == -8) {
      //black rook
      // add bishop positions to possible moves
      if (swap_black > 0) {
        for (int k1 = 0; k1 < 8; k1++) {
          for (int k2 = 0; k2 < 8; k2++) {
            if (curr_status[k1.toString() + k2.toString()] == -6 ||
                curr_status[k1.toString() + k2.toString()] == -4) {
              possible_swap_moves[k1.toString() + k2.toString()] = 1;
            }
          }
        }
      }
      for (int k = 1; k < 8; k++) {
        if ((i + k > 7 ||
            curr_status[(i + k).toString() + (j).toString()]! < 0)) {
          break;
        } else if (curr_status[(i + k).toString() + (j).toString()]! < 0) {
          possible_moves[(i + k).toString() + (j).toString()] = 1;
          break;
        }
        possible_moves[(i + k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            curr_status[(i - k).toString() + (j).toString()]! < 0)) {
          break;
        } else if (curr_status[(i - k).toString() + (j).toString()]! < 0) {
          possible_moves[(i - k).toString() + (j).toString()] = 1;
          break;
        }
        possible_moves[(i - k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j + k > 7 ||
            curr_status[(i).toString() + (j + k).toString()]! < 0)) {
          break;
        } else if (curr_status[(i).toString() + (j + k).toString()]! < 0) {
          possible_moves[(i).toString() + (j + k).toString()] = 1;
          break;
        }
        possible_moves[(i).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j - k < 0 ||
            curr_status[(i).toString() + (j - k).toString()]! < 0)) {
          break;
        } else if (curr_status[(i).toString() + (j - k).toString()]! < 0) {
          possible_moves[(i).toString() + (j - k).toString()] = 1;
          break;
        }
        possible_moves[(i).toString() + (j - k).toString()] = 1;
      }
    }
    if (curr_status[ij] == 9) {
      //white queen
      for (int k = 1; k < 8; k++) {
        if ((i + k > 7 ||
            j + k > 7 ||
            curr_status[(i + k).toString() + (j + k).toString()]! > 0)) {
          break;
        }
        if (curr_status[(i + k).toString() + (j + k).toString()]! < 0) {
          possible_moves[(i + k).toString() + (j + k).toString()] = 1;
          break;
        }
        possible_moves[(i + k).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            j - k < 0 ||
            curr_status[(i - k).toString() + (j - k).toString()]! > 0)) {
          break;
        } else if (curr_status[(i - k).toString() + (j - k).toString()]! < 0) {
          possible_moves[(i - k).toString() + (j - k).toString()] = 1;
          break;
        }
        possible_moves[(i - k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((j - k < 0 ||
            i + k > 7 ||
            curr_status[(i + k).toString() + (j - k).toString()]! > 0)) {
          break;
        } else if (curr_status[(i + k).toString() + (j - k).toString()]! < 0) {
          possible_moves[(i + k).toString() + (j - k).toString()] = 1;
          break;
        }
        possible_moves[(i + k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((i - k < 0 ||
            j + k > 7 ||
            curr_status[(i - k).toString() + (j + k).toString()]! > 0)) {
          break;
        } else if (curr_status[(i - k).toString() + (j + k).toString()]! < 0) {
          possible_moves[(i - k).toString() + (j + k).toString()] = 1;
          break;
        }
        possible_moves[(i - k).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i + k > 7 ||
            curr_status[(i + k).toString() + (j).toString()]! > 0)) {
          break;
        } else if (curr_status[(i + k).toString() + (j).toString()]! < 0) {
          possible_moves[(i + k).toString() + (j).toString()] = 1;
          break;
        }
        possible_moves[(i + k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            curr_status[(i - k).toString() + (j).toString()]! > 0)) {
          break;
        } else if (curr_status[(i - k).toString() + (j).toString()]! < 0) {
          possible_moves[(i - k).toString() + (j).toString()] = 1;
          break;
        }
        possible_moves[(i - k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j + k > 7 ||
            curr_status[(i).toString() + (j + k).toString()]! > 0)) {
          break;
        } else if (curr_status[(i).toString() + (j + k).toString()]! < 0) {
          possible_moves[(i).toString() + (j + k).toString()] = 1;
          break;
        }
        possible_moves[(i).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j - k < 0 ||
            curr_status[(i).toString() + (j - k).toString()]! > 0)) {
          break;
        } else if (curr_status[(i).toString() + (j - k).toString()]! < 0) {
          possible_moves[(i).toString() + (j - k).toString()] = 1;
          break;
        }
        possible_moves[(i).toString() + (j - k).toString()] = 1;
      }
    }
    if (curr_status[ij] == -9) {
      //black queen
      for (int k = 1; k < 8; k++) {
        if ((i + k > 7 ||
            j + k > 7 ||
            curr_status[(i + k).toString() + (j + k).toString()]! < 0)) {
          break;
        }
        if (curr_status[(i + k).toString() + (j + k).toString()]! > 0) {
          possible_moves[(i + k).toString() + (j + k).toString()] = 1;
          break;
        }
        possible_moves[(i + k).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            j - k < 0 ||
            curr_status[(i - k).toString() + (j - k).toString()]! < 0)) {
          break;
        } else if (curr_status[(i - k).toString() + (j - k).toString()]! > 0) {
          possible_moves[(i - k).toString() + (j - k).toString()] = 1;
          break;
        }
        possible_moves[(i - k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((j - k < 0 ||
            i + k > 7 ||
            curr_status[(i + k).toString() + (j - k).toString()]! < 0)) {
          break;
        } else if (curr_status[(i + k).toString() + (j - k).toString()]! > 0) {
          possible_moves[(i + k).toString() + (j - k).toString()] = 1;
          break;
        }
        possible_moves[(i + k).toString() + (j - k).toString()] = 1;
      }
      for (int k = 1; k <= 7; k++) {
        if ((j + k > 7 ||
            i - k < 0 ||
            curr_status[(i - k).toString() + (j + k).toString()]! < 0)) {
          break;
        } else if (curr_status[(i - k).toString() + (j + k).toString()]! > 0) {
          possible_moves[(i - k).toString() + (j + k).toString()] = 1;
          break;
        }
        possible_moves[(i - k).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i + k > 7 ||
            curr_status[(i + k).toString() + (j).toString()]! < 0)) {
          break;
        } else if (curr_status[(i + k).toString() + (j).toString()]! > 0) {
          possible_moves[(i + k).toString() + (j).toString()] = 1;
          break;
        }
        possible_moves[(i + k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((i - k < 0 ||
            curr_status[(i - k).toString() + (j).toString()]! < 0)) {
          break;
        } else if (curr_status[(i - k).toString() + (j).toString()]! > 0) {
          possible_moves[(i - k).toString() + (j).toString()] = 1;
          break;
        }
        possible_moves[(i - k).toString() + (j).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j + k > 7 ||
            curr_status[(i).toString() + (j + k).toString()]! < 0)) {
          break;
        } else if (curr_status[(i).toString() + (j + k).toString()]! > 0) {
          possible_moves[(i).toString() + (j + k).toString()] = 1;
          break;
        }
        possible_moves[(i).toString() + (j + k).toString()] = 1;
      }
      for (int k = 1; k < 8; k++) {
        if ((j - k < 0 ||
            curr_status[(i).toString() + (j - k).toString()]! < 0)) {
          break;
        } else if (curr_status[(i).toString() + (j - k).toString()]! > 0) {
          possible_moves[(i).toString() + (j - k).toString()] = 1;
          break;
        }
        possible_moves[(i).toString() + (j - k).toString()] = 1;
      }
    }
    if (curr_status[ij] == 7) {
      //white king
      if (i + 1 < 8 &&
          j - 1 > -1 &&
          curr_status[(i + 1).toString() + (j - 1).toString()]! < 1) {
        possible_moves[(i + 1).toString() + (j - 1).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j + 1 > 8 &&
          curr_status[(i - 1).toString() + (j + 1).toString()]! < 1) {
        possible_moves[(i - 1).toString() + (j + 1).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j - 1 < -1 &&
          curr_status[(i - 1).toString() + (j - 1).toString()]! < 1) {
        possible_moves[(i - 1).toString() + (j - 1).toString()] = 1;
      }
      if (i + 1 < 8 &&
          j + 1 > 8 &&
          curr_status[(i + 1).toString() + (j + 1).toString()]! < 1) {
        possible_moves[(i + 1).toString() + (j + 1).toString()] = 1;
      }
      if (i + 1 < 8 && curr_status[(i + 1).toString() + j.toString()]! < 1) {
        possible_moves[(i + 1).toString() + j.toString()] = 1;
      }
      if (i - 1 > -1 && curr_status[(i - 1).toString() + j.toString()]! < 1) {
        possible_moves[(i - 1).toString() + j.toString()] = 1;
      }
      if (j + 1 < 8 && curr_status[i.toString() + (j + 1).toString()]! < 1) {
        possible_moves[i.toString() + (j + 1).toString()] = 1;
      }
      if (j - 1 > -1 && curr_status[i.toString() + (j - 1).toString()]! < 1) {
        possible_moves[i.toString() + (j - 1).toString()] = 1;
      }
    }
    if (curr_status[ij] == -7) {
      if (i + 1 < 8 &&
          j - 1 > -1 &&
          curr_status[(i + 1).toString() + (j - 1).toString()]! > 1) {
        possible_moves[(i + 1).toString() + (j - 1).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j + 1 > 8 &&
          curr_status[(i - 1).toString() + (j + 1).toString()]! > 1) {
        possible_moves[(i - 1).toString() + (j + 1).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j - 1 < -1 &&
          curr_status[(i - 1).toString() + (j - 1).toString()]! > 1) {
        possible_moves[(i - 1).toString() + (j - 1).toString()] = 1;
      }
      if (i + 1 < 8 &&
          j + 1 > 8 &&
          curr_status[(i + 1).toString() + (j + 1).toString()]! > 1) {
        possible_moves[(i + 1).toString() + (j + 1).toString()] = 1;
      }
      if (i + 1 < 8 && curr_status[(i + 1).toString() + j.toString()]! > 1) {
        possible_moves[(i + 1).toString() + j.toString()] = 1;
      }
      if (i - 1 > -1 && curr_status[(i - 1).toString() + j.toString()]! > 1) {
        possible_moves[(i - 1).toString() + j.toString()] = 1;
      }
      if (j + 1 < 8 && curr_status[i.toString() + (j + 1).toString()]! > 1) {
        possible_moves[i.toString() + (j + 1).toString()] = 1;
      }
      if (j - 1 > -1 && curr_status[i.toString() + (j - 1).toString()]! > 1) {
        possible_moves[i.toString() + (j - 1).toString()] = 1;
      }
    }
    if (curr_status[ij] == 4) {
      //white knight
      if (swap_white > 0) {
        for (int k1 = 0; k1 < 8; k1++) {
          for (int k2 = 0; k2 < 8; k2++) {
            if (curr_status[k1.toString() + k2.toString()] == 8 ||
                curr_status[k1.toString() + k2.toString()] == 6) {
              possible_swap_moves[k1.toString() + k2.toString()] = 1;
            }
          }
        }
      }

      if (i + 2 < 8 &&
          j + 1 < 8 &&
          curr_status[(i + 2).toString() + (j + 1).toString()]! < 1) {
        possible_moves[(i + 2).toString() + (j + 1).toString()] = 1;
      }
      if (i + 2 < 8 &&
          j - 1 > -1 &&
          curr_status[(i + 2).toString() + (j - 1).toString()]! < 1) {
        possible_moves[(i + 2).toString() + (j - 1).toString()] = 1;
      }
      if (i - 2 > -1 &&
          j + 1 < 8 &&
          curr_status[(i - 2).toString() + (j + 1).toString()]! < 1) {
        possible_moves[(i - 2).toString() + (j + 1).toString()] = 1;
      }
      if (i - 2 > -1 &&
          j - 1 > -1 &&
          curr_status[(i - 2).toString() + (j - 1).toString()]! < 1) {
        possible_moves[(i - 2).toString() + (j - 1).toString()] = 1;
      }
      if (i + 1 < 8 &&
          j + 2 < 8 &&
          curr_status[(i + 1).toString() + (j + 2).toString()]! < 1) {
        possible_moves[(i + 1).toString() + (j + 2).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j + 2 < 8 &&
          curr_status[(i - 1).toString() + (j + 2).toString()]! < 1) {
        possible_moves[(i - 1).toString() + (j + 2).toString()] = 1;
      }
      if (i + 1 < 8 &&
          j - 2 > -1 &&
          curr_status[(i + 1).toString() + (j - 2).toString()]! < 1) {
        possible_moves[(i + 1).toString() + (j - 2).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j - 2 > -1 &&
          curr_status[(i - 1).toString() + (j - 2).toString()]! < 1) {
        possible_moves[(i - 1).toString() + (j - 2).toString()] = 1;
      }
    }
    if (curr_status[ij] == -4) {
      //black knight

      if (swap_black > 0) {
        for (int k1 = 0; k1 < 8; k1++) {
          for (int k2 = 0; k2 < 8; k2++) {
            if (curr_status[k1.toString() + k2.toString()] == -8 ||
                curr_status[k1.toString() + k2.toString()] == -6) {
              possible_swap_moves[k1.toString() + k2.toString()] = 1;
            }
          }
        }
      }
      if (i + 2 < 8 &&
          j + 1 < 8 &&
          curr_status[(i + 2).toString() + (j + 1).toString()]! > -1) {
        possible_moves[(i + 2).toString() + (j + 1).toString()] = 1;
      }
      if (i + 2 < 8 &&
          j - 1 > -1 &&
          curr_status[(i + 2).toString() + (j - 1).toString()]! > -1) {
        possible_moves[(i + 2).toString() + (j - 1).toString()] = 1;
      }
      if (i - 2 > -1 &&
          j + 1 < 8 &&
          curr_status[(i - 2).toString() + (j + 1).toString()]! > -1) {
        possible_moves[(i - 2).toString() + (j + 1).toString()] = 1;
      }
      if (i - 2 > -1 &&
          j - 1 > -1 &&
          curr_status[(i - 2).toString() + (j - 1).toString()]! > -1) {
        possible_moves[(i - 2).toString() + (j - 1).toString()] = 1;
      }
      if (i + 1 < 8 &&
          j + 2 < 8 &&
          curr_status[(i + 1).toString() + (j + 2).toString()]! > -1) {
        possible_moves[(i + 1).toString() + (j + 2).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j + 2 < 8 &&
          curr_status[(i - 1).toString() + (j + 2).toString()]! > -1) {
        possible_moves[(i - 1).toString() + (j + 2).toString()] = 1;
      }
      if (i + 1 < 8 &&
          j - 2 > -1 &&
          curr_status[(i + 1).toString() + (j - 2).toString()]! > -1) {
        possible_moves[(i + 1).toString() + (j - 2).toString()] = 1;
      }
      if (i - 1 > -1 &&
          j - 2 > -1 &&
          curr_status[(i - 1).toString() + (j - 2).toString()]! > -1) {
        possible_moves[(i - 1).toString() + (j - 2).toString()] = 1;
      }
    }
  }
}
