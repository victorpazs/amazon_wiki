import 'package:flutter/material.dart';
import 'package:amazon_wiki_app/features/home/presentation/home_screen.dart';
import 'package:amazon_wiki_app/features/trees/presentation/trees_screen.dart';
import 'package:amazon_wiki_app/features/tree/presentation/tree_screen.dart';

class AppRoutes {
  static const home = '/';
  static const trees = '/trees';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');

    if (uri.path == '/') {
      return MaterialPageRoute(builder: (_) => HomeScreen());
    } else if (uri.path == '/trees') {
      return MaterialPageRoute(builder: (_) => TreesScreen());
    } else if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'trees') {
      final id = int.tryParse(uri.pathSegments[1]);
      if (id != null) {
        return MaterialPageRoute(builder: (_) => TreeDetailScreen(treeId: id));
      }
    }

    return MaterialPageRoute(builder: (_) => HomeScreen());
  }
}
