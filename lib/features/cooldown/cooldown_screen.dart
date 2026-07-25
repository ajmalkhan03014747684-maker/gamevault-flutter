import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/neon_button.dart';
import '../minigames/mini_game_hub_screen.dart';

class CooldownScreen extends StatefulWidget {
  final int cooldownSeconds;

  const CooldownScreen({super.key, this.cooldownSeconds = 75});

  @override
  State<CooldownScreen> createState() => _CooldownScreenState();
}

class _CooldownScreenState extends State<CooldownScreen> {
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.cooldownSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formatted {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final bool ready = _secondsLeft == 0;
    final double progress = widget.cooldownSeconds == 0
        ? 1
        : 1 - (_secondsLeft / widget.cooldownSeconds);

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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 12),
                FadeInDown(
                  child: Text(
                    ready ? 'Ad Available Now' : 'Next Ad Available In',
                    style: AppTextStyles.heading3,
                  ),
                ),
                const SizedBox(height: 28),
                FadeIn(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 170,
                        height: 170,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 400),
                          builder: (context, value, _) => CircularProgressIndicator(
                            value: value,
                            strokeWidth: 8,
                            backgroundColor: AppColors.surface,
                            valueColor: AlwaysStoppedAnimation(
                              ready ? AppColors.success : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            ready
                                ? Icons.check_circle_rounded
                                : Icons.timer_rounded,
                            color: ready ? AppColors.success : AppColors.primary,
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            ready ? 'Ready!' : _formatted,
                            style: AppTextStyles.numberLarge.copyWith(fontSize: 26),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    ready
                        ? 'You can watch another ad now.'
                        : 'Play mini games or explore the app while you wait.',
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 28),
                if (!ready)
                  FadeInUp(
                    delay: const Duration(milliseconds: 150),
                    child: NeonButton(
                      label: 'PLAY MINI GAMES',
                      icon: Icons.sports_esports_rounded,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MiniGameHubScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                if (ready)
                  FadeInUp(
                    delay: const Duration(milliseconds: 150),
                    child: NeonButton(
                      label: 'CONTINUE',
                      icon: Icons.arrow_forward_rounded,
                      gradient: const LinearGradient(
                        colors: [AppColors.success, Color(0xFF16A34A)],
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                const SizedBox(height: 12),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      side: const BorderSide(color: AppColors.card),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text('Go to Home', style: AppTextStyles.body),
                  ),
                ),
                const SizedBox(height: 20),
                if (!ready)
                  FadeInUp(
                    delay: const Duration(milliseconds: 250),
                    child: GlassCard(
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              color: AppColors.muted, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Cooldown helps keep ad rewards fair for everyone.',
                              style: AppTextStyles.caption,
                            ),
                          ),
                        ],
                      ),
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
