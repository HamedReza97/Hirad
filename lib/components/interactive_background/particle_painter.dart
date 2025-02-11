import 'dart:math';
import 'package:flutter/material.dart';
import 'particle.dart';

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double connectionDistance;

  ParticlePainter(this.particles, {this.connectionDistance = 200.0});

  @override
  void paint(Canvas canvas, Size size) {
    // Clear the canvas
    canvas.drawColor(Colors.transparent, BlendMode.srcOver);

    final Paint particlePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.2;

    final double connectionDistanceSq = connectionDistance * connectionDistance;

    // Spatial partitioning: divide the canvas into grid cells
    final int gridSize = connectionDistance.toInt();
    final Map<Point<int>, List<Particle>> grid = {};

    for (final particle in particles) {
      final Point<int> gridKey = Point(
        (particle.position.dx ~/ gridSize),
        (particle.position.dy ~/ gridSize),
      );
      grid.putIfAbsent(gridKey, () => []).add(particle);
    }

    for (final particle in particles) {
      canvas.drawCircle(particle.position, particle.size, particlePaint);

      final Point<int> gridKey = Point(
        (particle.position.dx ~/ gridSize),
        (particle.position.dy ~/ gridSize),
      );

      final neighbors = [
        gridKey,
        Point(gridKey.x - 1, gridKey.y),
        Point(gridKey.x + 1, gridKey.y),
        Point(gridKey.x, gridKey.y - 1),
        Point(gridKey.x, gridKey.y + 1),
        Point(gridKey.x - 1, gridKey.y - 1),
        Point(gridKey.x + 1, gridKey.y + 1),
        Point(gridKey.x - 1, gridKey.y + 1),
        Point(gridKey.x + 1, gridKey.y - 1),
      ];

      for (final neighborKey in neighbors) {
        if (!grid.containsKey(neighborKey)) continue;
        
        for (final other in grid[neighborKey]!) {
          if (particle == other) continue;

          final double dx = particle.position.dx - other.position.dx;
          final double dy = particle.position.dy - other.position.dy;
          final double distanceSq = dx * dx + dy * dy;

          if (distanceSq < connectionDistanceSq) {
            final double distance = sqrt(distanceSq);
            final double factor = 1.0 - (distance / connectionDistance);
            final int alpha = (factor * 150).toInt();

            linePaint.color = Colors.white.withAlpha(alpha);
            canvas.drawLine(particle.position, other.position, linePaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
