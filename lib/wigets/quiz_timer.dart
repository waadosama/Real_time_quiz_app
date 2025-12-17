import 'package:flutter/material.dart';
import 'dart:async';

class QuizTimer extends StatefulWidget {
  final int durationMinutes;
  final VoidCallback? onTimeUp;
  final bool compact;

  const QuizTimer({
    super.key,
    required this.durationMinutes,
    this.onTimeUp,
    this.compact = false,
  });

  @override
  State<QuizTimer> createState() => _QuizTimerState();
}

class _QuizTimerState extends State<QuizTimer> {
  late Timer _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationMinutes * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        _timer.cancel();
        return;
      }
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
          widget.onTimeUp?.call();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Color _getTimerColor() {
    final totalSeconds = widget.durationMinutes * 60;
    final thirdDuration = totalSeconds ~/ 3;

    if (_remainingSeconds > thirdDuration * 2) {
      return const Color(0xFF0D4726);
    } else if (_remainingSeconds > thirdDuration) {
      return const Color(0xFFF59E0B);
    } else {
      return const Color(0xFFDC2626);
    }
  }

  Color _getBorderColor() {
    return _getTimerColor();
  }

  String _formatTime() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getTimerPhase() {
    final totalSeconds = widget.durationMinutes * 60;
    final thirdDuration = totalSeconds ~/ 3;

    if (_remainingSeconds > thirdDuration * 2) {
      return 'Plenty of time';
    } else if (_remainingSeconds > thirdDuration) {
      return 'Hurry up';
    } else {
      return 'Time running out!';
    }
  }


  @override
  Widget build(BuildContext context) {
    final timerColor = _getTimerColor();
    final phase = _getTimerPhase();
    final borderColor = _getBorderColor();
    final padding = widget.compact
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0)
        : const EdgeInsets.symmetric(horizontal: 11, vertical: 6.0);
    final iconSize = widget.compact ? 16.0 : 13.0;
    final fontSizeMain = widget.compact ? 16.0 : 13.0;
    final fontSizeSub = widget.compact ? 16.0 : 15.0;

    final borderWidth = widget.compact ? 0.5 : 0.8;
    final radius = widget.compact ? 6.0 : 8.0;

    final timeTextStyle = TextStyle(
      fontSize: fontSizeMain,
      fontWeight: FontWeight.bold,
      color: timerColor,
      letterSpacing: 0.5,
    );

    final timeTextContainer = Container(
      padding: EdgeInsets.symmetric(
          horizontal: widget.compact ? 2 : 3, vertical: widget.compact ? 0 : 1),
      decoration: BoxDecoration(
        color: timerColor.withOpacity(
            _remainingSeconds <= (widget.durationMinutes * 60) ~/ 3
                ? 0.15
                : 0.0),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(_formatTime(), style: timeTextStyle),
    );

    return Container(
      padding: padding, // Uses the smallest vertical padding
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(radius),
        color: borderColor.withOpacity(widget.compact ? 0.2 : 0.1),
      ),
      // The main Row contains all elements
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.center, // Align items vertically in the center
        children: [
          // 1. Icon
          Icon(
            Icons.schedule,
            color: timerColor,
            size: iconSize,
          ),

          // Minimal spacing
          const SizedBox(width: 4),

          timeTextContainer,

          if (!widget.compact) ...[
            const SizedBox(width: 8), // Spacing between time and phase
            Text(
              '(${phase})', // Wrapped in parentheses to look cleaner next to time
              style: TextStyle(
                fontSize: fontSizeSub,
                color: timerColor.withOpacity(0.7), // Slightly dimmer color
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
