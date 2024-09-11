import 'package:flutter/material.dart';
import 'dart:math' show pi;

class Example1 extends StatefulWidget {
  const Example1({super.key});

  @override
  State<Example1> createState() => _Example1State();
}

class _Example1State extends State<Example1>
    with SingleTickerProviderStateMixin {
  /// Animation controller - Animation
  /// 0.0 - 0 degree
  /// 0.5 - 180 degree
  /// 1.0 - 360 degree

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Tween() is sth that goes from one value to another
    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Transform is a widget
  /// Canvas is flipped to x-axis

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              // origin: const Offset(50, 50),
              // Reset the rotation, translation, reset the matrix, Offset(0, 0) then rotate to Z
              transform: Matrix4.identity()..rotateY(_animation.value),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
