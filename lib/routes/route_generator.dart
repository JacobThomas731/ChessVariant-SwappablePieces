import 'package:chess_variant_swappable_pieces/UI/board/chess_board_ui.dart';
import 'package:chess_variant_swappable_pieces/UI/play_friend.dart';
import 'package:chess_variant_swappable_pieces/board/board_controller.dart';
import 'package:chess_variant_swappable_pieces/board/chess_board.dart';
import 'package:flutter/material.dart';
import '../UI/auth_page/auth_page.dart';
import '../UI/homepage/home_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AuthPage());

      case '/boardController':
        return MaterialPageRoute(
            builder: (_) =>
                BoardController('white', 'swappable').getChessBoardUiObj());

      case '/homepage':
        return MaterialPageRoute(builder: (_) => const HomePage());

      case '/board':
        return MaterialPageRoute(builder: (_) => const Board());

      case '/board2':
        return MaterialPageRoute(builder: (_) => const Board());

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
