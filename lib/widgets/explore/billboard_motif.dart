import 'package:flutter/material.dart';

/// Abstract billboard silhouette: a frame on two legs. Used as a quiet
/// textural motif, never as a literal illustration.
class BillboardMotif extends StatelessWidget {
  const BillboardMotif({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.08,
      child: SizedBox(
        width: size,
        height: size * 0.82,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: size * 0.58,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size * 0.08),
                  border: Border.all(color: Colors.white, width: size * 0.045),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: size * 0.22,
              child: Container(
                width: size * 0.05,
                height: size * 0.34,
                margin: EdgeInsets.zero,
                color: Colors.white,
              ),
            ),
            Positioned(
              bottom: 0,
              right: size * 0.22,
              child: Container(
                width: size * 0.05,
                height: size * 0.34,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
