import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A12),
      body: Stack(
        children: [
          // ── Background glow top-center ──
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: 0, right: 0,
            child: Center(
              child: Container(
                width: 300, height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF6C5CE7).withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Background glow bottom-right ──
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            right: -40,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00CEC9).withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Center content ──
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo icon
                  Container(
                    width: 88, height: 88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF6C5CE7), Color(0xFFa29bfe)],
                      ),
                    ),
                    child: const Icon(
                      Icons.grid_view_rounded,
                      color: Colors.white, size: 42,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // App name
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                      children: [
                        TextSpan(text: 'My'),
                        TextSpan(
                          text: 'App',
                          style: TextStyle(color: Color(0xFFa29bfe)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tagline
                  const Text(
                    'YOUR EVERYDAY COMPANION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF8888aa),
                      letterSpacing: 2.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Loading dots ──
          Positioned(
            bottom: 80,
            left: 0, right: 0,
            child: Center(
              child: _LoadingDots(),
            ),
          ),

          // ── Version ──
          const Positioned(
            bottom: 28,
            left: 0, right: 0,
            child: Center(
              child: Text(
                'v1.0.0',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF44445a),
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animated loading dots ──────────────────────────────
class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) {
      final c = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) c.repeat(reverse: true);
      });
      return c;
    });
    _animations = _controllers
        .map((c) => Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: c, curve: Curves.easeInOut),
    ))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, __) => Transform.translate(
            offset: Offset(0, _animations[i].value),
            child: Container(
              width: 7, height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7)
                    .withOpacity(0.4 + 0.6 * (_animations[i].value.abs() / 10)),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}