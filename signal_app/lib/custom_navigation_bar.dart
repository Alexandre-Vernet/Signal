import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoute { dashboard, stats }

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    int currentIndex = switch (location) {
      "/" => 0,
      "/news-saved" => 1,
      _ => 0,
    };

    return BottomNavigationBar(
      currentIndex: currentIndex,

      onTap: (index) {
        switch (index) {
          case 0:
            context.go("/");
            break;

          case 1:
            context.go("/news-saved");
            break;
        }
      },

      items: [
        BottomNavigationBarItem(
          label: "Actualités",
          icon: Icon(Icons.sensors_rounded),
        ),
        BottomNavigationBarItem(label: "Favoris", icon: Icon(Icons.bookmark)),
      ],
    );
  }
}
