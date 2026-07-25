import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/neon_button.dart';
import '../../core/models/game.dart';
import 'withdraw_screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const totalBalance = 260;
    const todayEarnings = 26;
    const totalEarned = 520;
    const totalWithdrawn = 260;

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
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              FadeInDown(
                child: Text('My Wallet', style: AppTextStyles.heading2),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 80),
                child: GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.diamond_rounded,
                          color: AppColors.primary, size: 40),
                      const SizedBox(height: 10),
                      Text('Total Balance', style: AppTextStyles.caption),
                      const SizedBox(height: 4),
                      Text('$totalBalance',
                          style: AppTextStyles.numberLarge.copyWith(fontSize: 40)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.history_rounded, size: 18),
                              label: const Text('History'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                side: const BorderSide(color: AppColors.card),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.receipt_long_rounded, size: 18),
                              label: const Text('Transactions'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                side: const BorderSide(color: AppColors.card),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
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
                      Text('Earning Summary', style: AppTextStyles.body),
                      const SizedBox(height: 14),
                      _SummaryRow(label: "Today's Earnings", value: '$todayEarnings'),
                      const Divider(color: Colors.white10, height: 24),
                      _SummaryRow(label: 'Total Earned', value: '$totalEarned'),
                      const Divider(color: Colors.white10, height: 24),
                      _SummaryRow(label: 'Total Withdrawn', value: '$totalWithdrawn'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                delay: const Duration(milliseconds: 180),
                child: NeonButton(
                  label: 'WITHDRAW CURRENCY',
                  icon: Icons.card_giftcard_rounded,
                  height: 58,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            WithdrawScreen(games: Game.demoGames),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySecondary),
        Row(
          children: [
            const Icon(Icons.diamond_rounded, color: AppColors.primary, size: 16),
            const SizedBox(width: 4),
            Text(value, style: AppTextStyles.number),
          ],
        ),
      ],
    );
  }
}
