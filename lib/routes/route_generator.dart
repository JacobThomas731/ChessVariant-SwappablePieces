import 'package:chess_variant_swappable_pieces/UI/board/chess_board_ui.dart';
import 'package:chess_variant_swappable_pieces/UI/play_friend.dart';
import 'package:chess_variant_swappable_pieces/UI/rules/game_rules.dart';
import 'package:chess_variant_swappable_pieces/board/board_controller.dart';
import 'package:chess_variant_swappable_pieces/board/chess_board.dart';
import 'package:flutter/material.dart';
import '../UI/auth_page/auth_page.dart';
import '../UI/homepage/home_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    dynamic arguments = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AuthPage());

      case '/boardController':
        return MaterialPageRoute(
            builder: (_) => BoardController(
                    'white', 'swappable', 500, 'games', 'ab2@gmail.com')
                .getChessBoardUiObj());

      case '/boardControllerArgs':
        List args = arguments as List;
        return MaterialPageRoute(
            builder: (_) => BoardController(
                    args[0], args[1], int.parse(args[2]), args[3], args[4])
                .getChessBoardUiObj());
      case '/homepage':
        return MaterialPageRoute(builder: (_) => HomePage());

      case '/board':
        return MaterialPageRoute(builder: (_) => const Board());

      case '/board2':
        return MaterialPageRoute(builder: (_) => const Board());

      case '/gamerules':
        return MaterialPageRoute(builder: (_) => const GameRules());

      case '/playFriend':
        return MaterialPageRoute(builder: (_) => PlayFriend());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
