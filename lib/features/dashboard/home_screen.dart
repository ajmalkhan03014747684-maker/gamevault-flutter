import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/models/game.dart';
import '../game_details/game_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = Game.demoGames;

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
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const _TopBar(),
                    const SizedBox(height: 20),
                    const _StatsRow(),
                    const SizedBox(height: 16),
                    const _TodayProgress(),
                    const SizedBox(height: 24),
                    const _QuickActionsRow(),
                    const SizedBox(height: 24),
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Your Games', style: AppTextStyles.heading3),
                          TextButton(
                            onPressed: () {},
                            child: Text('View All',
                                style: AppTextStyles.bodySecondary
                                    .copyWith(color: AppColors.primary)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(games.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FadeInUp(
                          delay: Duration(milliseconds: 250 + i * 60),
                          child: _GameCard(game: games[i]),
                        ),
                      );
                    }),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.person_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hi, Player123', style: AppTextStyles.heading3),
                Text('Level 12', style: AppTextStyles.caption),
              ],
            ),
          ),
          GlassCard(
            padding: const EdgeInsets.all(10),
            borderRadius: 14,
            child: const Icon(Icons.notifications_rounded,
                color: AppColors.textPrimary, size: 22),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 100),
      child: GlassCard(
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                icon: Icons.diamond_rounded,
                iconColor: AppColors.primary,
                label: 'Total Balance',
                value: '260',
              ),
            ),
            Container(width: 1, height: 36, color: Colors.white10),
            Expanded(
              child: _StatItem(
                icon: Icons.play_circle_fill_rounded,
                iconColor: AppColors.secondary,
                label: 'Ads Today',
                value: '42',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor, size: 26),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            Text(value, style: AppTextStyles.numberLarge.copyWith(fontSize: 22)),
          ],
        ),
      ],
    );
  }
}

class _TodayProgress extends StatelessWidget {
  const _TodayProgress();

  @override
  Widget build(BuildContext context) {
    const watched = 42;
    const goal = 60;
    const progress = watched / goal;

    return FadeInUp(
      delay: const Duration(milliseconds: 150),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Today's Progress", style: AppTextStyles.body),
                Text('$watched / $goal Ads', style: AppTextStyles.bodySecondary),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor: AppColors.surface,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${goal - watched} ads more to reach next reward',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.calendar_today_rounded, 'Daily\nCheck-In', AppColors.secondary),
      (Icons.checklist_rounded, 'Missions', AppColors.success),
      (Icons.leaderboard_rounded, 'Leader-\nboard', AppColors.gold),
    ];

    return FadeInUp(
      delay: const Duration(milliseconds: 180),
      child: Row(
        children: List.generate(actions.length, (i) {
          final (icon, label, color) = actions[i];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == actions.length - 1 ? 0 : 10),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                onTap: () {},
                child: Column(
                  children: [
                    Icon(icon, color: color, size: 24),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final Game game;

  const _GameCard({required this.game});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GameDetailsScreen(game: game),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: game.accentColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: game.accentColor.withOpacity(0.4)),
            ),
            child: Icon(game.icon, color: game.accentColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(game.name, style: AppTextStyles.body),
                    if (game.isActive) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Active',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.success, fontSize: 10),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text('${game.currencyName} · ${game.adsWatched}/${game.adsRequired} ads',
                    style: AppTextStyles.caption),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: game.progress,
                    minHeight: 5,
                    backgroundColor: AppColors.surface,
                    valueColor: AlwaysStoppedAnimation(game.accentColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, 'Home'),
      (Icons.sports_esports_rounded, 'Games'),
      (Icons.account_balance_wallet_rounded, 'Wallet'),
      (Icons.people_alt_rounded, 'Referral'),
      (Icons.person_rounded, 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface2.withOpacity(0.95),
        border: const Border(top: BorderSide(color: Colors.white10)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final (icon, label) = items[i];
            final selected = i == 0;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    color: selected ? AppColors.primary : AppColors.muted,
                    size: 24),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    color: selected ? AppColors.primary : AppColors.muted,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
