import 'package:flutter/material.dart';
import 'package:math_game/models/user_model.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class GameTimerBar extends StatefulWidget implements PreferredSizeWidget {
  final UserModel user;
  final int stars;
  final int duration;
  final VoidCallback? onTimerComplete;
  final ValueChanged<String>? onTimeChange;

  const GameTimerBar({
    super.key,
    required this.user,
    required this.stars,
    required this.duration,
    this.onTimerComplete,
    this.onTimeChange,
  });

  @override
  State<GameTimerBar> createState() => _GameTimerBarState();

  @override
  Size get preferredSize => const Size.fromHeight(110);
}

class _GameTimerBarState extends State<GameTimerBar> {
  late CountDownController _controller;
  bool _isTimerRunning = false; // Add this flag

  @override
  void initState() {
    super.initState();
    _controller = CountDownController();
    // Initialize the timer as running
    _isTimerRunning = true;
  }

  @override
  void didUpdateWidget(GameTimerBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      // Restart the timer with the new duration
      _controller.restart(duration: widget.duration);
    }
  }

  Color _getTimerColor() {
    final time = _controller.getTime() ?? '0';
    final remainingTime = double.tryParse(time) ?? 0;
    if (remainingTime > 5) return const Color(0xFF4CAF50);
    if (remainingTime > 2) return const Color(0xFFFF9800);
    return const Color(0xFFFF5252);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFBF2), Color(0xFFFFF9E8), Color(0xFFFFF0D6)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // User Profile Section
                Row(
                  children: [
                    Hero(
                      tag: 'avatar_${widget.user.avatarPath}',
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFFFAF57), width: 2),
                        ),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(widget.user.avatarPath),
                          backgroundColor: const Color(0xFFFFAF57),
                          radius: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF525252),
                          ),
                        ),
                        Text(
                          'Level ${widget.user.level}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFFC239),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Timer Section
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 37.0), // Adjust padding to move timer left
                      child: CircularCountDownTimer(
                        duration: widget.duration,
                        initialDuration: 0,
                        controller: _controller,
                        width: 70,
                        height: 70,
                        ringColor: Colors.grey.withOpacity(0.3),
                        fillColor: _getTimerColor(),
                        backgroundColor: Colors.white,
                        strokeWidth: 8.0,
                        strokeCap: StrokeCap.round,
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _getTimerColor(),
                        ),
                        textFormat: CountdownTextFormat.S,
                        isReverse: true,
                        isReverseAnimation: true,
                        autoStart: true, // Set autoStart to true
                        onStart: () {
                          _isTimerRunning = true;
                        },
                        onChange: widget.onTimeChange, // Add this line
                        onComplete: () {
                          _isTimerRunning = false; // Update the flag when timer completes
                          widget.onTimerComplete?.call();
                        },
                      ),
                    ),
                  ],
                ),
                // Stars Score Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECECEC).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('lib/asset/star.png', width: 32, height: 32),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.stars}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFAF57),
                        ),
                      ),
                    ],
                  ),
                ),
              ],            ),          ),
        ),
      ),
    );
  }
}
