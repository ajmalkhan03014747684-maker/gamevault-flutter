import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/neon_button.dart';
import '../../core/models/game.dart';

class WithdrawScreen extends StatefulWidget {
  final List<Game> games;

  const WithdrawScreen({super.key, required this.games});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  late Game _selectedGame;
  final _uidController = TextEditingController();
  bool _submitting = false;

  static const int _walletBalance = 260;
  static const int _currencyPerWithdraw = 26;

  @override
  void initState() {
    super.initState();
    _selectedGame = widget.games.first;
  }

  @override
  void dispose() {
    _uidController.dispose();
    super.dispose();
  }

  int get _availableWithdraws => _walletBalance ~/ _currencyPerWithdraw;

  Future<void> _submit() async {
    if (_uidController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your in-game UID'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _submitting = false);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 56),
              const SizedBox(height: 16),
              Text('Request Submitted', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              Text(
                'Your withdraw request is pending admin review.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: NeonButton(
                  label: 'OK',
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
                      Text('Withdraw Currency', style: AppTextStyles.heading3),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 80),
                  child: Text('Select Game', style: AppTextStyles.bodySecondary),
                ),
                const SizedBox(height: 8),
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Game>(
                        value: _selectedGame,
                        isExpanded: true,
                        dropdownColor: AppColors.surface,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: AppColors.muted),
                        items: widget.games.map((g) {
                          return DropdownMenuItem(
                            value: g,
                            child: Row(
                              children: [
                                Icon(g.icon, color: g.accentColor, size: 20),
                                const SizedBox(width: 10),
                                Text(g.name, style: AppTextStyles.body),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (g) {
                          if (g != null) setState(() => _selectedGame = g);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 140),
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Your Balance', style: AppTextStyles.bodySecondary),
                            Row(
                              children: [
                                const Icon(Icons.diamond_rounded,
                                    color: AppColors.primary, size: 18),
                                const SizedBox(width: 4),
                                Text('$_walletBalance', style: AppTextStyles.number),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$_currencyPerWithdraw balance = 1 ${_selectedGame.currencyName} withdraw'
                            '  ·  $_availableWithdraws available',
                            style: AppTextStyles.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 180),
                  child: Text('Enter Your ${_selectedGame.name} UID',
                      style: AppTextStyles.bodySecondary),
                ),
                const SizedBox(height: 8),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: TextField(
                    controller: _uidController,
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.body,
                    decoration: InputDecoration(
                      hintText: 'e.g. 1234567890',
                      prefixIcon: const Icon(Icons.badge_outlined,
                          color: AppColors.muted),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                FadeInUp(
                  delay: const Duration(milliseconds: 240),
                  child: NeonButton(
                    label: 'SUBMIT REQUEST',
                    onPressed: _availableWithdraws > 0 ? _submit : null,
                    loading: _submitting,
                    height: 58,
                  ),
                ),
                const SizedBox(height: 10),
                FadeInUp(
                  delay: const Duration(milliseconds: 260),
                  child: Text(
                    'Withdraw requests are reviewed by an admin before currency is sent.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption,
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
