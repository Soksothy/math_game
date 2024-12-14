import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_game/models/user_model.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class GameTimerBar extends StatefulWidget implements PreferredSizeWidget {
  final UserModel user;
  final int stars;
  final int remainingSeconds;

  const GameTimerBar({
    super.key,
    required this.user,
    required this.stars,
    required this.remainingSeconds,
  });

  @override
  Size get preferredSize => const Size.fromHeight(110); // Reduced from 140

  @override
  State<GameTimerBar> createState() => _GameTimerBarState();
}

class _GameTimerBarState extends State<GameTimerBar> {
  final CountDownController _controller = CountDownController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFBF2),
                  Color(0xFFFFF9E8),
                  Color(0xFFFFF0D6),
                ],
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
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.03,
                  vertical: 4, // Reduced from 8
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4, // Changed back from 3
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0), // Reduced from 4.0
                            child: Hero(
                              tag: 'avatar_${widget.user.avatarIndex}',
                              child: CircleAvatar(
                                radius: 26, // Reduced from 32
                                backgroundColor: const Color(0xFFFFAF57),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xFFFFAF57),
                                    radius: 24, // Reduced from 30
                                    backgroundImage: AssetImage(
                                      'lib/asset/avatar/${widget.user.avatarIndex + 1}.png',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8), // Reduced from 12
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.user.name,
                                  style: const TextStyle(
                                    fontSize: 18, // Reduced from 20
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF525252),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Level ${widget.user.level}',
                                  style: const TextStyle(
                                    fontSize: 14, // Reduced from 16
                                    color: Color(0xFFFFC239),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4, // Changed back from 5
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0), // Reduced from 12.0 to move timer left
                          child: CircularCountDownTimer(
                            duration: 10, // Fixed duration of 20 seconds instead of widget.remainingSeconds
                            initialDuration: 0, // Start from 0 (will count 20,19,18...)
                            controller: _controller,
                            width: 80, // Reduced from 95
                            height: 80, // Reduced from 95
                            ringColor: const Color(0xFFFFAF57),
                            fillColor: Colors.white,
                            backgroundColor: Colors.white,
                            strokeWidth: 5.0,
                            strokeCap: StrokeCap.round,
                            textStyle: const TextStyle(
                              fontSize: 24, // Reduced from 28
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFAF57),
                            ),
                            textFormat: CountdownTextFormat.S,
                            isReverse: true,
                            isReverseAnimation: true,
                            autoStart: true,
                            onComplete: () {
                              // Handle timer completion if needed
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4, // Changed back from 3
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10, // Reduced from 12
                          vertical: 6, // Reduced from 8
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECECEC).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'lib/asset/star.png',
                              height: 32, // Reduced from 38
                              width: 32, // Reduced from 38
                            ),
                            const SizedBox(width: 6), // Reduced from 8
                            Text(
                              '${widget.stars}',
                              style: const TextStyle(
                                fontSize: 24, // Reduced from 28
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFAF57),
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
      },
    );
  }
}
