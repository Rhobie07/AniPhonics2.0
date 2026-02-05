import 'package:flutter/material.dart';

import '../../features/games/games_hub_screen.dart';
import '../../features/games/games_dashboard_screen.dart';
import '../../features/games/match/match_name_screen.dart';
import '../../features/games/match/match_sound_screen.dart';
import '../../features/games/memory/memory_level1_screen.dart';
import '../../features/games/memory/memory_level2_screen.dart';
import '../../features/games/memory/memory_level3_screen.dart';
import '../../features/games/memory/memory_level_select_screen.dart';
import '../../features/games/puzzle/puzzle_hub_screen.dart';
import '../../features/games/puzzle/puzzle_play_screen.dart';
import '../../features/loading/loading_screen.dart';
import '../../features/names/names_sounds_screen.dart';
import '../../features/start/start_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    late final Widget page;
    switch (settings.name) {
      case AppRoutes.loading:
        page = const LoadingScreen();
        break;
      case AppRoutes.start:
        page = const StartScreen();
        break;
      case AppRoutes.namesSounds:
        page = const NamesSoundsScreen();
        break;
      case AppRoutes.games:
        page = const GamesHubScreen();
        break;
      case AppRoutes.gamesDashboard:
        page = const GamesDashboardScreen();
        break;
      case AppRoutes.memoryHub:
        page = const MemoryLevelSelectScreen();
        break;
      case AppRoutes.memoryLevel1:
        page = const MemoryLevel1Screen();
        break;
      case AppRoutes.memoryLevel2:
        page = const MemoryLevel2Screen();
        break;
      case AppRoutes.memoryLevel3:
        page = const MemoryLevel3Screen();
        break;
      case AppRoutes.puzzleHub:
        page = const PuzzleHubScreen();
        break;
      case AppRoutes.puzzlePlay:
        page = const PuzzlePlayScreen();
        break;
      case AppRoutes.matchName:
        page = const MatchNameScreen();
        break;
      case AppRoutes.matchSound:
        page = const MatchSoundScreen();
        break;
      default:
        page = const StartScreen();
        break;
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.06, 0.02),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
