import 'package:flutter/material.dart';
import 'dart:math' show pi;

enum CircleSide {
  left,
  right,
}

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();

    late Offset offset;
    late bool clockwise;

    /// Path (Pencil) in normal is at (0, 0)
    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }

    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockwise,
    );

    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) => side.toPath(size);

  /// Something happen, do you want to redraw the path ( To Parent Widget )
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class Example2 extends StatefulWidget {
  const Example2({super.key});

  @override
  State<Example2> createState() => _Example2State();
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

class _Example2State extends State<Example2> with TickerProviderStateMixin {
  /// Clipper, define what shape to keep
  late AnimationController _counterClockWiseRotationController;
  late Animation<double> _counterClockWiseRotationAnimation;

  late AnimationController _flipAnimationController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _counterClockWiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _counterClockWiseRotationAnimation = Tween<double>(
      begin: 0.0,
      end: -(pi / 2),
    ).animate(
      CurvedAnimation(
        parent: _counterClockWiseRotationController,
        curve: Curves.bounceOut,
      ),
    );

    _flipAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: pi,
    ).animate(
      CurvedAnimation(
        parent: _flipAnimationController,
        curve: Curves.bounceOut,
      ),
    );

    // Listen to _counterClockWiseRotationController is finished, animate from current point
    _counterClockWiseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
          begin: _flipAnimation.value,
          end: _flipAnimation.value + pi,
        ).animate(
          CurvedAnimation(
            parent: _flipAnimationController,
            curve: Curves.bounceOut,
          ),
        );

        // Reset the _flipAnimationController
        _flipAnimationController
          ..reset()
          ..forward();
      }
    });

    _flipAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockWiseRotationAnimation = Tween<double>(
          begin: _counterClockWiseRotationAnimation.value,
          end: _counterClockWiseRotationAnimation.value + -(pi / 2),
        ).animate(
          CurvedAnimation(
            parent: _counterClockWiseRotationController,
            curve: Curves.bounceOut,
          ),
        );

        _counterClockWiseRotationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _counterClockWiseRotationController.dispose();
    _flipAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // When the build function is called, reset the animation, start from 0
    _counterClockWiseRotationController
      ..reset()
      ..forward.delayed(const Duration(
        seconds: 1,
      ));

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _counterClockWiseRotationAnimation,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(_counterClockWiseRotationAnimation.value),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _flipAnimationController,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()
                          ..rotateY(_flipAnimation.value),
                        child: ClipPath(
                          clipper: HalfCircleClipper(side: CircleSide.left),
                          child: Container(
                            width: 100,
                            height: 100,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _flipAnimationController,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()
                          ..rotateY(_flipAnimation.value),
                        child: ClipPath(
                          clipper: HalfCircleClipper(side: CircleSide.right),
                          child: Container(
                            width: 100,
                            height: 100,
                            color: Colors.yellow,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
