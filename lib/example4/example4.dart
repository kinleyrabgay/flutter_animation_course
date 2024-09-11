import 'package:flutter/material.dart';

class Example4 extends StatefulWidget {
  const Example4({super.key});

  @override
  State<Example4> createState() => _Example4State();
}

const defaultWidth = 100.0;

class _Example4State extends State<Example4> {
  var _isZoomedIn = false;
  var _width = defaultWidth;
  var _curve =
      Curves.easeInOut; // Changed the curve to easeInOut for a smooth effect

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isZoomedIn = !_isZoomedIn;
                  _width = _isZoomedIn
                      ? MediaQuery.of(context).size.width
                      : defaultWidth;

                  _curve = _isZoomedIn
                      ? Curves.easeInOut
                      : Curves
                          .easeInOut; // Using the same smooth curve for both states
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 370),
                width: _width,
                curve: _curve,
                child: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
