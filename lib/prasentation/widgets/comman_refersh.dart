import 'package:flutter/material.dart';
import 'package:movie_app/utils/theme/theme_colors.dart';

class CustomRefresher extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const CustomRefresher({
    Key? key,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      displacement: 10.0,
      color: AppColors.white,
      backgroundColor: AppColors.background,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: child,
    );
  }
}
