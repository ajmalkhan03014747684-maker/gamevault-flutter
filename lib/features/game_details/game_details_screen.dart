import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/neon_button.dart';
import '../../core/models/game.dart';
import '../cooldown/cooldown_screen.dart';

enum _ScreenState { details, watching, success }

const int _cooldownDurationSeconds = 75;

class GameDetailsScreen extends StatefulWidget {
  final Game game;

  const GameDetailsScreen({super.key, required this.game});

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  _ScreenState _state = _ScreenState.details;
  late int _adsWatched;
  DateTime? _cooldownEndsAt;
  Timer? _tickTimer;

  @override
  void initState() {
    super.initState();
    _adsWatched = widget.game.adsWatched;
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  int get _cooldownSecondsLeft {
    if (_cooldownEndsAt == null) return 0;
    final diff = _cooldownEndsAt!.difference(DateTime.now()).inSeconds;
    return diff > 0 ? diff : 0;
  }

  bool get _inCooldown => _cooldownSecondsLeft > 0;

  void _startTickTimerIfNeeded() {
    _tickTimer?.cancel();
    if (!_inCooldown) return;
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (!_inCooldown) {
        timer.cancel();
      }
      setState(() {});
    });
  }

  Future<void> _watchAd() async {
    if (_inCooldown) return;
    setState(() => _state = _ScreenState.watching);
    // Simulated ad playback — replaced with real HMS/Mintegral SDK call later.
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _adsWatched = (_adsWatched + 1).clamp(0, widget.game.adsRequired);
      _cooldownEndsAt =
          DateTime.now().add(const Duration(seconds: _cooldownDurationSeconds));
      _state = _ScreenState.success;
    });
    _startTickTimerIfNeeded();
  }

  Future<void> _continue() async {
    setState(() => _state = _ScreenState.details);
    if (_cooldownEndsAt != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CooldownScreen(cooldownEndsAt: _cooldownEndsAt!),
        ),
      );
      if (!mounted) return;
      setState(() {});
    }
  }

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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: switch (_state) {
              _ScreenState.details => _DetailsView(
                  key: const ValueKey('details'),
                  game: widget.game,
                  adsWatched: _adsWatched,
                  cooldownSecondsLeft: _cooldownSecondsLeft,
                  onWatchAd: _watchAd,
                ),
              _ScreenState.watching => _WatchingView(
                  key: const ValueKey('watching'),
                  game: widget.game,
                ),
              _ScreenState.success => _SuccessView(
                  key: const ValueKey('success'),
                  game: widget.game,
                  adsWatched: _adsWatched,
                  onContinue: _continue,
                ),
            },
          ),
        ),
      ),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final Game game;
  final int adsWatched;
  final int cooldownSecondsLeft;
  final VoidCallback onWatchAd;

  const _DetailsView({
    super.key,
    required this.game,
    required this.adsWatched,
    required this.cooldownSecondsLeft,
    required this.onWatchAd,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (game.adsRequired - adsWatched).clamp(0, game.adsRequired);
    final progress = game.adsRequired == 0 ? 0.0 : adsWatched / game.adsRequired;
    final isComplete = adsWatched >= game.adsRequired;
    final inCooldown = cooldownSecondsLeft > 0;

    String buttonLabel;
    if (isComplete) {
      buttonLabel = 'GOAL REACHED';
    } else if (inCooldown) {
      final m = (cooldownSecondsLeft ~/ 60).toString().padLeft(2, '0');
      final s = (cooldownSecondsLeft % 60).toString().padLeft(2, '0');
      buttonLabel = 'NEXT AD IN $m:$s';
    } else {
      buttonLabel = 'WATCH REWARDED AD';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 400),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary, size: 20),
                ),
                const SizedBox(width: 4),
                Text(game.name, style: AppTextStyles.heading3),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FadeInUp(
            delay: const Duration(milliseconds: 80),
            child: GlassCard(
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: game.accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: game.accentColor.withOpacity(0.4)),
                    ),
                    child: Icon(game.icon, color: game.accentColor, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(game.name, style: AppTextStyles.heading3),
                      const SizedBox(height: 2),
                      Text(game.currencyName, style: AppTextStyles.bodySecondary),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 130),
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Your Progress', style: AppTextStyles.body),
                      Text('$adsWatched / ${game.adsRequired} Ads',
                          style: AppTextStyles.bodySecondary),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: progress),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) => LinearProgressIndicator(
                        value: value,
                        minHeight: 10,
                        backgroundColor: AppColors.surface,
                        valueColor: AlwaysStoppedAnimation(game.accentColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isComplete
                        ? 'Goal reached! You can withdraw now.'
                        : '$remaining more ads to reach ${game.rewardAmount} ${game.currencyName}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 180),
            child: GlassCard(
              backgroundColor: game.accentColor.withOpacity(0.08),
              child: Row(
                children: [
                  Icon(game.icon, color: game.accentColor, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Reward Preview',
                      style: AppTextStyles.bodySecondary,
                    ),
                  ),
                  Text(
                    '${game.rewardAmount} ${game.currencyName}',
                    style: AppTextStyles.number.copyWith(color: game.accentColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          FadeInUp(
            delay: const Duration(milliseconds: 220),
            child: NeonButton(
              label: buttonLabel,
              icon: isComplete
                  ? Icons.check_circle_rounded
                  : (inCooldown
                      ? Icons.timer_rounded
                      : Icons.play_circle_fill_rounded),
              onPressed: (isComplete || inCooldown) ? null : onWatchAd,
              height: 60,
            ),
          ),
          const SizedBox(height: 12),
          FadeInUp(
            delay: const Duration(milliseconds: 260),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.card),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text('Withdraw', style: AppTextStyles.body),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.card),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text('History', style: AppTextStyles.body),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WatchingView extends StatelessWidget {
  final Game game;

  const _WatchingView({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('watching-center'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeIn(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.5),
                    blurRadius: 50,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(30),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text('Watching Ad...', style: AppTextStyles.heading3),
          const SizedBox(height: 6),
          Text('Please don\'t close the app', style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final Game game;
  final int adsWatched;
  final VoidCallback onContinue;

  const _SuccessView({
    super.key,
    required this.game,
    required this.adsWatched,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElasticIn(
              duration: const Duration(milliseconds: 700),
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withOpacity(0.15),
                  border: Border.all(color: AppColors.success, width: 2),
                ),
                child: const Icon(Icons.check_rounded,
                    color: AppColors.success, size: 56),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Text('Reward Received!', style: AppTextStyles.heading2),
            ),
            const SizedBox(height: 6),
            FadeInUp(
              delay: const Duration(milliseconds: 250),
              child: Text(
                '+1 Progress',
                style: AppTextStyles.body.copyWith(color: AppColors.success),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: GlassCard(
                child: Column(
                  children: [
                    Text('Your Progress', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(
                      '$adsWatched / ${game.adsRequired} Ads',
                      style: AppTextStyles.numberLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            FadeInUp(
              delay: const Duration(milliseconds: 350),
              child: NeonButton(
                label: 'CONTINUE',
                onPressed: onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
