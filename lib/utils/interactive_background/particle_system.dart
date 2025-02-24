import 'dart:math';
import 'package:flutter/material.dart';
import 'particle.dart';
import 'particle_painter.dart';

class ParticleSystemWidget extends StatefulWidget {
  final int particleCount;
  const ParticleSystemWidget({
    super.key,
    this.particleCount = 50
    });

  @override
  ParticleSystemWidgetState createState() => ParticleSystemWidgetState();
}

class ParticleSystemWidgetState extends State<ParticleSystemWidget>
    with SingleTickerProviderStateMixin {
  late List<Particle> particles;
  late AnimationController _controller;
  late Size screenSize;
  Offset mousePosition = Offset.zero;
  final double interactionRadius = 200.0;
  final double sqInteractionRadius = 200.0 * 200.0; 
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    
    // Initialize screenSize with a fallback default value
    screenSize = const Size(800, 600); // Default size before MediaQuery is available
    particles = [];
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 365),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        screenSize = MediaQuery.of(context).size;
      });
      generateParticles();
    });
  }

  void generateParticles() {
    particles = List.generate(widget.particleCount, (_) {
      return Particle(
        Offset(
          random.nextDouble() * screenSize.width,
          random.nextDouble() * screenSize.height,
        ),
        Offset(
          random.nextDouble() * 4 - 2,
          random.nextDouble() * 4 - 2,
        ),
        Colors.grey,
        random.nextDouble() * 4,
      );
    });
  }

  void updateParticles() {
    final List<Particle> interactingParticles = [];

    for (var particle in particles) {
      particle.position += particle.velocity;

      final double dx = particle.position.dx - mousePosition.dx;
      final double dy = particle.position.dy - mousePosition.dy;
      final double sqDistanceToMouse = dx * dx + dy * dy;

      if (sqDistanceToMouse < sqInteractionRadius && sqDistanceToMouse > 0) {
        interactingParticles.add(particle);
      }

      // Keep particles within bounds
      if (particle.position.dx < 0 ||
          particle.position.dx > screenSize.width ||
          particle.position.dy < 0 ||
          particle.position.dy > screenSize.height) {
        particle.position = Offset(
          random.nextDouble() * screenSize.width,
          random.nextDouble() * screenSize.height,
        );
      }
    }

    // Process interacting particles separately
    for (var particle in interactingParticles) {
      final double dx = particle.position.dx - mousePosition.dx;
      final double dy = particle.position.dy - mousePosition.dy;
      final double distanceToMouse = sqrt(dx * dx + dy * dy);
      final double speed = particle.velocity.distance;

      particle.velocity = Offset(
        dx / distanceToMouse * speed,
        dy / distanceToMouse * speed,
      );

      particle.position += particle.velocity * 10;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size newScreenSize = MediaQuery.of(context).size;
    
    // Update screenSize only if it has changed
    if (screenSize != newScreenSize) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          screenSize = newScreenSize;
        });
      });
    }

    final double connectionDistance = screenSize.height / screenSize.width < 1.4
        ? 250.0
        : 100.0;

    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          mousePosition = details.localPosition;
        });
      },
      child: MouseRegion(
        onHover: (event) {
          setState(() {
            mousePosition = event.localPosition;
          });
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            updateParticles();
            return CustomPaint(
              size: Size.infinite,
              painter: ParticlePainter(particles, connectionDistance: connectionDistance),
            );
          },
        ),
      ),
    );
  }
}
