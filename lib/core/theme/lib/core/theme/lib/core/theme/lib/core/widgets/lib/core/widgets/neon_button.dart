import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Gradient button with neon glow shadow + ripple, used for primary actions
/// like "Watch Rewarded Ad", "Login", "Submit Request".
class NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient? gradient;
  final double height;
  final bool loading;

  const NeonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.gradient,
    this.height = 56,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null && !loading;
    final Gradient effectiveGradient = gradient ?? AppColors.primaryGradient;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1.0 : 0.5,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: effectiveGradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.45),
                    blurRadius: 20,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: enabled ? onPressed : null,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(label, style: AppTextStyles.button),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
