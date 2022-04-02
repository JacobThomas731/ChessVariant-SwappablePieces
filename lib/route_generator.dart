import 'package:chess_variant_swappable_pieces/chess_board.dart';
import 'package:chess_variant_swappable_pieces/auth_pop.dart';
import 'package:flutter/material.dart';
import 'UI/home_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());

      case '/board':
        return MaterialPageRoute(builder: (_) {
          return const Board();
        });
      case '/auth':
        return MaterialPageRoute(builder: (_){
          return const AuthPop();
        });
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
