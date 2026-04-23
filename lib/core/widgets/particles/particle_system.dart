import 'dart:math';
import 'package:flutter/material.dart';

/// Particle Data Model
class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  Color color;
  double alpha;
  double life;
  double maxLife;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.life,
    required this.maxLife,
  }) : alpha = 1.0;

  /// Update particle position and properties
  void update(double dt) {
    x += vx * dt;
    y += vy * dt;
    life -= dt;
    alpha = (life / maxLife).clamp(0.0, 1.0);
  }

  /// Check if particle is still alive
  bool get isAlive => life > 0;

  /// Create a copy of the particle
  Particle copyWith({
    double? x,
    double? y,
    double? vx,
    double? vy,
    double? size,
    Color? color,
    double? life,
    double? maxLife,
  }) {
    return Particle(
      x: x ?? this.x,
      y: y ?? this.y,
      vx: vx ?? this.vx,
      vy: vy ?? this.vy,
      size: size ?? this.size,
      color: color ?? this.color,
      life: life ?? this.life,
      maxLife: maxLife ?? this.maxLife,
    );
  }
}

/// Premium Particle System Widget
class ParticleSystemWidget extends StatefulWidget {
  final List<Color> colors;
  final int particleCount;
  final double particleSize;
  final double speed;
  final bool circular;
  final Duration duration;
  final bool loop;
  final VoidCallback? onComplete;

  const ParticleSystemWidget({
    super.key,
    required this.colors,
    this.particleCount = 50,
    this.particleSize = 3.0,
    this.speed = 1.0,
    this.circular = false,
    this.duration = const Duration(seconds: 3),
    this.loop = true,
    this.onComplete,
  });

  @override
  State<ParticleSystemWidget> createState() => _ParticleSystemWidgetState();
}

class _ParticleSystemWidgetState extends State<ParticleSystemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();
  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addListener(_updateParticles);
    _controller.addStatusListener(_handleStatus);

    // Start animation after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeParticles();
        if (widget.loop) {
          _controller.repeat();
        } else {
          _controller.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_updateParticles);
    _controller.removeStatusListener(_handleStatus);
    _controller.dispose();
    super.dispose();
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && !widget.loop) {
      widget.onComplete?.call();
    }
  }

  void _initializeParticles() {
    _particles.clear();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(_createParticle());
    }
  }

  Particle _createParticle() {
    final color = widget.colors[_random.nextInt(widget.colors.length)];
    final centerX = _size.width / 2;
    final centerY = _size.height / 2;

    if (widget.circular) {
      // Circular motion around center
      final angle = _random.nextDouble() * 2 * pi;
      final radius = 100 + _random.nextDouble() * 100;
      final x = centerX + cos(angle) * radius;
      final y = centerY + sin(angle) * radius;
      final speed = 0.5 + _random.nextDouble() * 0.5;

      return Particle(
        x: x,
        y: y,
        vx: -sin(angle) * speed * widget.speed,
        vy: cos(angle) * speed * widget.speed,
        size: widget.particleSize * (0.5 + _random.nextDouble()),
        color: color,
        life: widget.duration.inMilliseconds.toDouble() *
            (0.5 + _random.nextDouble() * 0.5),
        maxLife: widget.duration.inMilliseconds.toDouble(),
      );
    } else {
      // Random explosion/float motion
      final x = _random.nextDouble() * _size.width;
      final y = _random.nextDouble() * _size.height;
      final vx = (_random.nextDouble() - 0.5) * widget.speed;
      final vy = (_random.nextDouble() - 0.5) * widget.speed;

      return Particle(
        x: x,
        y: y,
        vx: vx,
        vy: vy,
        size: widget.particleSize * (0.5 + _random.nextDouble()),
        color: color,
        life: widget.duration.inMilliseconds.toDouble() *
            (0.5 + _random.nextDouble() * 0.5),
        maxLife: widget.duration.inMilliseconds.toDouble(),
      );
    }
  }

  void _updateParticles() {
    if (_controller.isAnimating) {
      final dt = 16.0; // ~60fps

      for (var particle in _particles) {
        particle.update(dt * widget.speed);

        // Wrap around for circular motion
        if (widget.circular) {
          final centerX = _size.width / 2;
          final centerY = _size.height / 2;
          final dx = particle.x - centerX;
          final dy = particle.y - centerY;
          final distance = sqrt(dx * dx + dy * dy);

          if (distance > 300) {
            particle.x = centerX - dx;
            particle.y = centerY - dy;
          }
        } else if (!particle.isAlive) {
          // Respawn dead particles if looping
          if (widget.loop && _controller.isAnimating) {
            final newParticle = _createParticle();
            particle.x = newParticle.x;
            particle.y = newParticle.y;
            particle.vx = newParticle.vx;
            particle.vy = newParticle.vy;
            particle.life = newParticle.life;
            particle.maxLife = newParticle.maxLife;
            particle.alpha = 1.0;
          }
        }
      }

      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: _ParticleSystemPainter(
          particles: _particles,
          size: _size,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_size != constraints.biggest) {
                setState(() {
                  _size = constraints.biggest;
                });
              }
            });
            return const SizedBox.expand();
          },
        ),
      ),
    );
  }
}

class _ParticleSystemPainter extends CustomPainter {
  final List<Particle> particles;
  final Size size;

  _ParticleSystemPainter({
    required this.particles,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      if (particle.isAlive) {
        final paint = Paint()
          ..color = particle.color.withValues(alpha: particle.alpha)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

        canvas.drawCircle(
          Offset(particle.x, particle.y),
          particle.size,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
