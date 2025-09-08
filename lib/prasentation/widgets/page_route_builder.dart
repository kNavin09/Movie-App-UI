import 'package:flutter/material.dart';

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Offset beginOffset;
  final Offset reverseBeginOffset;
  final Curve curve;
  SlidePageRoute({
    required this.page,
    this.beginOffset = const Offset(1.0, 0.0),
    this.reverseBeginOffset = const Offset(-1.0, 0.0),
    this.curve = Curves.ease,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final offset = animation.status == AnimationStatus.reverse
               ? reverseBeginOffset
               : beginOffset;
           final tween = Tween(
             begin: offset,
             end: Offset.zero,
           ).chain(CurveTween(curve: curve));
           final offsetAnimation = animation.drive(tween);
           return SlideTransition(position: offsetAnimation, child: child);
         },
       );
}
