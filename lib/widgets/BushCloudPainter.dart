import 'package:flutter/material.dart';

/// A custom painter that draws a bush-like shape using multiple ovals,
/// allowing a custom [heightShift] to adjust vertical positions.
class BushCloudPainter extends CustomPainter {
  final double heightShift;

  const BushCloudPainter({required this.heightShift});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xfface268)
      ..style = PaintingStyle.fill;

    // Define multiple ovals that form the bush shape.
    final List<Rect> ellipses = [
      Rect.fromCenter(
        center: Offset(size.width * 0.07, size.height * (0.2 + heightShift)),
        width: size.width * 0.3,
        height: size.height * 1.5,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.25, size.height * (0.3 + heightShift)),
        width: size.width * 0.25,
        height: size.height * 0.9,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.4, size.height * (0.3 + heightShift)),
        width: size.width * 0.1,
        height: size.height * 0.35,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * (0.18 + heightShift)),
        width: size.width * 0.15,
        height: size.height * 0.35,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.7, size.height * (0.25 + heightShift)),
        width: size.width * 0.4,
        height: size.height * 1.5,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.95, size.height * (0.2 + heightShift)),
        width: size.width * 0.3,
        height: size.height * 0.8,
      ),
    ];

    // Draw each oval
    for (final ellipse in ellipses) {
      canvas.drawOval(ellipse, paint);
    }

    // Fill the bottom area with a rectangle
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        size.height * (0.3 + heightShift),
        size.width,
        size.height * (0.7 + heightShift),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant BushCloudPainter oldDelegate) {
    // Only repaint if the heightShift changes
    return oldDelegate.heightShift != heightShift;
  }
}
