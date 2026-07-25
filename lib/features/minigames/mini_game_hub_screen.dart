import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import 'reaction_tap_game.dart';

class _MiniGameEntry {
  final String name;
  final IconData icon;
  final Color color;
  final bool playable;

  const _MiniGameEntry(this.name, this.icon, this.color, {this.playable = false});
}

const List<_MiniGameEntry> _games = [
  _MiniGameEntry('Reaction Tap', Icons.touch_app_rounded, AppColors.primary,
      playable: true),
  _MiniGameEntry('Fast Runner', Icons.directions_run_rounded, Color(0xFFFF6B35)),
  _MiniGameEntry('Memory Match', Icons.grid_view_rounded, Color(0xFF3D5AFE)),
  _MiniGameEntry('Color Switch', Icons.palette_rounded, Color(0xFF00C853)),
  _MiniGameEntry('Bubble Pop', Icons.bubble_chart_rounded, Color(0xFFAB47BC)),
  _MiniGameEntry('Space Dodge', Icons.rocket_launch_rounded, Color(0xFF546E7A)),
  _MiniGameEntry('Knife Hit', Icons.gps_fixed_rounded, Color(0xFFF4A300)),
  _MiniGameEntry('Simple Puzzle', Icons.extension_rounded, AppColors.gold),
  _MiniGameEntry('Endless Jump', Icons.moving_rounded, AppColors.success),
];

class MiniGameHubScreen extends StatelessWidget {
  const MiniGameHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.6,
            colors: [Color(0xFF1A1533), AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: AppColors.textPrimary, size: 20),
                      ),
                      const SizedBox(width: 4),
                      Text('Mini Games', style: AppTextStyles.heading3),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'Entertainment only — no rewards or ad progress',
                    style: AppTextStyles.caption,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: _games.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, i) {
                      final g = _games[i];
                      return FadeInUp(
                        delay: Duration(milliseconds: 60 * i),
                        child: GlassCard(
                          onTap: () {
                            if (g.playable) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ReactionTapGame(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${g.name} — coming soon!'),
                                  backgroundColor: AppColors.surface2,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(g.icon, color: g.color, size: 34),
                              const SizedBox(height: 10),
                              Text(
                                g.name,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodySecondary,
                              ),
                              if (g.playable) ...[
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('Play Now',
                                      style: AppTextStyles.caption.copyWith(
                                          color: AppColors.success, fontSize: 10)),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
