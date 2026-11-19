import 'dart:math';

enum GamePhase { ready, playing, finished }

class ShotResult {
  final bool scored;
  final int points;
  final double landing;
  final double target;
  final double error;
  const ShotResult({
    required this.scored,
    required this.points,
    required this.landing,
    required this.target,
    required this.error,
  });
}

/// Deterministic arcade-style basketball challenge.
/// Aim and power are normalized values between 0 and 1.
class BasketballEngine {
  final Random random;
  final int maxShots;
  GamePhase phase = GamePhase.ready;
  int shots = 0;
  int baskets = 0;
  int points = 0;
  int streak = 0;
  int bestStreak = 0;
  double target = 0.5;
  double wind = 0;
  ShotResult? lastShot;
  String notice = 'Adjust aim and power to sink the basket!';

  BasketballEngine({Random? random, this.maxShots = 10})
      : assert(maxShots > 0),
        random = random ?? Random() {
    reset();
  }

  void reset() {
    phase = GamePhase.ready;
    shots = 0;
    baskets = 0;
    points = 0;
    streak = 0;
    bestStreak = 0;
    lastShot = null;
    target = 0.5;
    wind = 0;
    notice = 'Start the shooting challenge!';
  }

  void start() {
    if (phase != GamePhase.ready) return;
    phase = GamePhase.playing;
    notice = 'Take your shot!';
  }

  int get remaining => maxShots - shots;
  double get accuracy => shots == 0 ? 0 : baskets / shots;

  /// Projectile abstraction: aim sets horizontal reach, power adds vertical
  /// depth; wind causes small horizontal drift. Target has a tolerance radius.
  bool shoot(double aim, double power) {
    if (phase != GamePhase.playing ||
        !aim.isFinite || !power.isFinite ||
        aim < 0 || aim > 1 || power < 0 || power > 1) {
      return false;
    }
    final landing = (aim + wind * 0.14 + (power - 0.62) * 0.48)
        .clamp(0.0, 1.0).toDouble();
    final error = (landing - target).abs();
    // Low power cannot reach the hoop even with perfect horizontal aim.
    final made = power >= 0.4 && error <= 0.095;
    int gained = 0;
    if (made) {
      baskets++;
      streak++;
      bestStreak = max(bestStreak, streak);
      gained = (error < 0.03 ? 3 : 2) + min(3, streak ~/ 3);
      points += gained;
      notice = 'BUCKET! +$gained points';
    } else {
      streak = 0;
      notice = power < 0.4 ? 'Too short. Increase power!' : 'Missed. Adjust your aim!';
    }
    lastShot = ShotResult(scored: made, points: gained,
      landing: landing, target: target, error: error);
    shots++;
    if (shots >= maxShots) {
      phase = GamePhase.finished;
      notice = 'Game over! $baskets/$maxShots baskets, $points points.';
    } else {
      // Reproducible target and wind variation with an injected RNG.
      target = 0.22 + random.nextDouble() * 0.56;
      wind = (random.nextDouble() - 0.5) * 0.45;
    }
    return true;
  }
}
