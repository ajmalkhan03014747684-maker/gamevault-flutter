import 'package:flutter/material.dart';

class Game {
  final String id;
  final String name;
  final String currencyName;
  final IconData icon;
  final Color accentColor;
  final int adsWatched;
  final int adsRequired;
  final int rewardAmount;
  final bool isActive;

  const Game({
    required this.id,
    required this.name,
    required this.currencyName,
    required this.icon,
    required this.accentColor,
    required this.adsWatched,
    required this.adsRequired,
    required this.rewardAmount,
    this.isActive = false,
  });

  double get progress => adsRequired == 0 ? 0 : adsWatched / adsRequired;

  static const List<Game> demoGames = [
    Game(
      id: 'free_fire',
      name: 'Free Fire',
      currencyName: 'Diamonds',
      icon: Icons.local_fire_department_rounded,
      accentColor: Color(0xFFFF6B35),
      adsWatched: 42,
      adsRequired: 60,
      rewardAmount: 26,
      isActive: true,
    ),
    Game(
      id: 'pubg_mobile',
      name: 'PUBG Mobile',
      currencyName: 'UC',
      icon: Icons.military_tech_rounded,
      accentColor: Color(0xFFF4A300),
      adsWatched: 12,
      adsRequired: 60,
      rewardAmount: 26,
    ),
    Game(
      id: 'mobile_legends',
      name: 'Mobile Legends',
      currencyName: 'Diamonds',
      icon: Icons.diamond_rounded,
      accentColor: Color(0xFF3D5AFE),
      adsWatched: 8,
      adsRequired: 60,
      rewardAmount: 26,
    ),
    Game(
      id: 'cod_mobile',
      name: 'Call of Duty',
      currencyName: 'CP',
      icon: Icons.gps_fixed_rounded,
      accentColor: Color(0xFF546E7A),
      adsWatched: 0,
      adsRequired: 60,
      rewardAmount: 26,
    ),
    Game(
      id: 'roblox',
      name: 'Roblox',
      currencyName: 'Robux',
      icon: Icons.smart_toy_rounded,
      accentColor: Color(0xFF00C853),
      adsWatched: 0,
      adsRequired: 60,
      rewardAmount: 26,
    ),
    Game(
      id: 'brawl_stars',
      name: 'Brawl Stars',
      currencyName: 'Gems',
      icon: Icons.stars_rounded,
      accentColor: Color(0xFFAB47BC),
      adsWatched: 0,
      adsRequired: 60,
      rewardAmount: 26,
    ),
  ];
}
