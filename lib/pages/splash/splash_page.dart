import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:flixora/app/app_routes.dart';
import 'package:flixora/resources/colors_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeInAnim;
  late final Animation<double> _fadeOutAnim;

  @override
  void initState() {
    super.initState();

    // Dismiss native splash — in-app animation takes over
    FlutterNativeSplash.remove();

    // Hide status bar for full immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5500),
    );

    // Phase 1: fade in + scale up (0ms → 550ms)
    _fadeInAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.10, curve: Curves.easeIn),
      ),
    );

    // Slight scale punch like Netflix logo reveal
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.80,
          end: 1.06,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 12,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.06,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 8,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 80),
    ]).animate(_controller);

    // Phase 2: fade out at the end (90% → 100%)
    _fadeOutAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.90, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward().then((_) {
      if (mounted) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeOutAnim,
            child: Opacity(
              opacity: _fadeInAnim.value,
              child: Transform.scale(scale: _scaleAnim.value, child: child),
            ),
          );
        },
        child: Center(
          child: Image.asset(
            'assets/gif/animation-logo.gif',
            width: MediaQuery.of(context).size.width * 0.55,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
