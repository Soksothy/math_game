import 'package:flutter/material.dart';
import 'package:math_game/models/user_model.dart';

class GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel user;

  const GameAppBar({
    super.key,
    required this.user,
  });

  @override
  Size get preferredSize => const Size.fromHeight(140);

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
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Row(
                      children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Hero(
                        tag: 'avatar_${user.avatarIndex}',
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: const Color(0xFFFFAF57),
                          child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            backgroundColor: const Color(0xFFFFAF57),
                            radius: 30,
                            backgroundImage: AssetImage(
                            'lib/asset/avatar/${user.avatarIndex + 1}.png',
                            ),
                          ),
                          ),
                        ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF525252),
                          ),
                          overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                          'Level ${user.level}',
                          style: const TextStyle(
                            fontSize: 16,
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
                      flex: 3,
                      child: Container(
                        height: 100,
                        margin: const EdgeInsets.only(left: 0, right: 7),
                        alignment: Alignment.centerLeft,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Image.asset(
                              'lib/asset/medal.png',
                              height: 90,
                              width: 90,
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                              top: 30,
                              child: Text(
                                '${user.level}',
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECECEC).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('lib/asset/coin.png', width: 38, height: 38),
                            const SizedBox(width: 8),
                            Text(
                              '${user.stars}',
                              style: const TextStyle(
                                fontSize: 28,
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
