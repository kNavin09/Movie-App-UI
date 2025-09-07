import 'package:flutter/material.dart';
import 'package:movie_app/data/repository/movie_repository.dart';
import 'package:movie_app/utils/app_routes/page_routes.dart';
import 'package:movie_app/utils/constant/images.dart';
import 'package:movie_app/utils/theme/theme_colors.dart';

class SplashScreen extends StatefulWidget {
  final MovieRepository movieRepository;

  const SplashScreen({required this.movieRepository, super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.base);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            AllImage.splashLogo,
            width: 200,
            height: 200,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
