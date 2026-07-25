import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/neon_button.dart';

enum _GameState { waiting, ready, tooSoon, result }

class ReactionTapGame extends StatefulWidget {
  const ReactionTapGame({super.key});

  @override
  State<ReactionTapGame> createState() => _ReactionTapGameState();
}

class _ReactionTapGameState extends State<ReactionTapGame> {
  _GameState _state = _GameState.waiting;
  Timer? _delayTimer;
  DateTime? _readyAt;
  int? _reactionMs;
  int _bestMs = 0;

  @override
  void initState() {
    super.initState();
    _startRound();
  }

  void _startRound() {
    setState(() => _state = _GameState.waiting);
    final delay = Duration(milliseconds: 1000 + Random().nextInt(2500));
    _delayTimer = Timer(delay, () {
      if (!mounted) return;
      setState(() {
        _state = _GameState.ready;
        _readyAt = DateTime.now();
      });
    });
  }

  void _onTap() {
    switch (_state) {
      case _GameState.waiting:
        _delayTimer?.cancel();
        setState(() => _state = _GameState.tooSoon);
        break;
      case _GameState.ready:
        final ms = DateTime.now().difference(_readyAt!).inMilliseconds;
        setState(() {
          _reactionMs = ms;
          if (_bestMs == 0 || ms < _bestMs) _bestMs = ms;
          _state = _GameState.result;
        });
        break;
      case _GameState.tooSoon:
      case _GameState.result:
        _startRound();
        break;
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bg = switch (_state) {
      _GameState.waiting => AppColors.background,
      _GameState.ready => AppColors.success,
      _GameState.tooSoon => AppColors.error,
      _GameState.result => AppColors.background,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Reaction Tap', style: AppTextStyles.heading3),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
        ),
      ),
      body: GestureDetector(
        onTap: _onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: double.infinity,
          color: bg,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    switch (_state) {
                      _GameState.waiting => Icons.hourglass_top_rounded,
                      _GameState.ready => Icons.bolt_rounded,
                      _GameState.tooSoon => Icons.close_rounded,
                      _GameState.result => Icons.check_circle_rounded,
                    },
                    color: Colors.white,
                    size: 72,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    switch (_state) {
                      _GameState.waiting => 'Wait for green...',
                      _GameState.ready => 'TAP NOW!',
                      _GameState.tooSoon => 'Too soon! Tap to retry',
                      _GameState.result => '${_reactionMs}ms',
                    },
                    style: AppTextStyles.heading1.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  if (_state == _GameState.result) ...[
                    const SizedBox(height: 8),
                    Text('Best: ${_bestMs}ms',
                        style: AppTextStyles.body
                            .copyWith(color: Colors.white70)),
                    const SizedBox(height: 28),
                    NeonButton(
                      label: 'PLAY AGAIN',
                      onPressed: _startRound,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
