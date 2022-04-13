import 'package:chess_variant_swappable_pieces/UI/board/square_ui.dart';
import 'package:chess_variant_swappable_pieces/board/board_controller.dart';
import 'package:flutter/material.dart';

class SquareHolder extends StatefulWidget {
  final BoardController boardController;

  const SquareHolder(this.boardController, {Key? key}) : super(key: key);

  @override
  State<SquareHolder> createState() => _SquareHolderState();
}

class _SquareHolderState extends State<SquareHolder> {
  Color whitePlayer = const Color(0xcc8e6d58);
  Color blackPlayer = const Color(0x618e6d58);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < 8; i++)
          Row(
            children: [
              for (int j = 0; j < 8; j++)
                if ((i + j) % 2 == 1)
                  SquareUI(whitePlayer, i.toString() + j.toString(),
                      widget.boardController)
                else
                  SquareUI(blackPlayer, i.toString() + j.toString(),
                      widget.boardController)
            ],
          )
      ],
    );
  }
}
