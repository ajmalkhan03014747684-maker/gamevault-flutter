import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Home Dashboard', style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text(
                'Login successful! Full dashboard arrives in Phase 2.',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 24),
              GlassCard(
                child: Row(
                  children: [
                    const Icon(Icons.diamond_rounded,
                        color: AppColors.primary, size: 32),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Wallet Balance', style: AppTextStyles.caption),
                        Text('260', style: AppTextStyles.numberLarge),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
