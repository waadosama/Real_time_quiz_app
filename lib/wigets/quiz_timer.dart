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
      // First third: Green (0-33%)
      return const Color(0xFF0D4726);
    } else if (_remainingSeconds > thirdDuration) {
      // Second third: Yellow/Orange (33-66%)
      return const Color(0xFFF59E0B);
    } else {
      // Final third: Red (66-100%)
      return const Color(0xFFDC2626);
    }
  }

  // Border color follows the same phase as the timer: green -> orange -> red
  Color _getBorderColor() {
    final totalSeconds = widget.durationMinutes * 60;
    final thirdDuration = totalSeconds ~/ 3;

    if (_remainingSeconds > thirdDuration * 2) {
      // plenty: green
      return const Color(0xFF0D4726);
    } else if (_remainingSeconds > thirdDuration) {
      // mid: orange
      return const Color(0xFFF59E0B);
    } else {
      // final: red
      return const Color(0xFFDC2626);
    }
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
        ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
        : const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
    final iconSize = widget.compact ? 18.0 : 24.0;
    final fontSizeMain = widget.compact ? 14.0 : 20.0;
    final fontSizeSub = widget.compact ? 10.0 : 12.0;
    final borderWidth = widget.compact ? 1.6 : 2.5;
    final radius = widget.compact ? 10.0 : 16.0;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(radius),
        // Fill the whole timer container with the phase color (stronger opacity)
        color: borderColor.withOpacity(widget.compact ? 0.12 : 0.18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            color: timerColor,
            size: iconSize,
          ),
          if (!widget.compact)
            const SizedBox(width: 12)
          else
            const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time text: highlight when in the final phase
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.compact ? 4 : 6,
                    vertical: widget.compact ? 2 : 4),
                decoration: BoxDecoration(
                  color: timerColor.withOpacity(
                      _remainingSeconds <= (widget.durationMinutes * 60) ~/ 3
                          ? 0.12
                          : 0.0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _formatTime(),
                  style: TextStyle(
                    fontSize: fontSizeMain,
                    fontWeight:
                        _remainingSeconds <= (widget.durationMinutes * 60) ~/ 3
                            ? FontWeight.w800
                            : FontWeight.bold,
                    color: timerColor,
                    letterSpacing: 1,
                  ),
                ),
              ),
              if (!widget.compact)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    phase,
                    style: TextStyle(
                      fontSize: fontSizeSub,
                      // use a light beige highlight color for the phase text
                      color: const Color(0xFFF5E6D3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
