import 'package:flutter/material.dart';

class StylizedMap extends StatelessWidget {
  const StylizedMap({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: _MapGridPainter());
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFF9FAFB), BlendMode.src);

    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;

    // Draw subtle grid across the oversized map
    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Draw thick stylized "roads" relative to the center of the oversized map
    final cx = size.width / 2;
    final cy = size.height / 2;

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final borderPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    void drawRoad(Offset p1, Offset p2) {
      canvas.drawLine(p1, p2, borderPaint);
      canvas.drawLine(p1, p2, roadPaint);
    }

    drawRoad(Offset(cx + 40, cy - 200), Offset(cx + 300, cy + 800));
    drawRoad(Offset(cx - 200, cy + 320), Offset(cx + 600, cy + 480));
    drawRoad(Offset(cx + 200, cy + 400), Offset(cx + 400, cy - 100));
    drawRoad(Offset(cx - 500, cy - 100), Offset(cx + 300, cy - 300));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MiniMap extends StatelessWidget {
  const MiniMap({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: _MiniMapPainter());
  }
}

class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFF9FAFB), BlendMode.src);

    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final borderPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    void drawRoad(Offset p1, Offset p2) {
      canvas.drawLine(p1, p2, borderPaint);
      canvas.drawLine(p1, p2, roadPaint);
    }

    drawRoad(const Offset(20, -50), const Offset(150, 200));
    drawRoad(const Offset(-50, 100), const Offset(300, 150));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
