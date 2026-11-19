import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_082_basketball_shot/game/basketball_engine.dart';

void main() {
  group('BasketballEngine', () {
    test('starts in ready state and refuses early attempts', () {
      final game = BasketballEngine(random: Random(1));
      expect(game.phase, GamePhase.ready);
      expect(game.shoot(0.5, 0.62), false);
      game.start();
      expect(game.phase, GamePhase.playing);
    });
    test('perfect aim and baseline power scores three points', () {
      final game = BasketballEngine(random: Random(2))..start();
      expect(game.shoot(0.5, 0.62), true);
      expect(game.baskets, 1);
      expect(game.points, 3);
      expect(game.lastShot!.scored, true);
      expect(game.lastShot!.error, closeTo(0, 0.00001));
    });
    test('insufficient power cannot score', () {
      final game = BasketballEngine(random: Random(3))..start();
      game.shoot(0.5, 0.1);
      expect(game.baskets, 0);
      expect(game.streak, 0);
    });
    test('rejects non finite and out-of-range controls without counting shots', () {
      final game = BasketballEngine(random: Random(4))..start();
      expect(game.shoot(-0.1, 0.5), false);
      expect(game.shoot(double.nan, 0.5), false);
      expect(game.shoot(0.5, 1.1), false);
      expect(game.shots, 0);
    });
    test('misses reset consecutive streak', () {
      final game = BasketballEngine(random: Random(5))..start();
      game.shoot(0.5, 0.62);
      expect(game.streak, 1);
      game.shoot(0, 0.1);
      expect(game.streak, 0);
      expect(game.bestStreak, 1);
    });
    test('finite match ends and prevents extra shots', () {
      final game = BasketballEngine(random: Random(6), maxShots: 2)..start();
      expect(game.shoot(0.5, 0.62), true);
      expect(game.shoot(0.5, 0.62), true);
      expect(game.phase, GamePhase.finished);
      expect(game.shots, 2);
      expect(game.shoot(0.5, 0.62), false);
      expect(game.remaining, 0);
    });
    test('reset clears scores and allows replay', () {
      final game = BasketballEngine(random: Random(7), maxShots: 1)..start();
      game.shoot(0.5, 0.62);
      game.reset();
      expect(game.phase, GamePhase.ready);
      expect(game.points, 0);
      expect(game.baskets, 0);
      expect(game.lastShot, isNull);
    });
    test('same seed produces identical target and wind', () {
      final a = BasketballEngine(random: Random(20))..start();
      final b = BasketballEngine(random: Random(20))..start();
      a.shoot(0.5, 0.62);
      b.shoot(0.5, 0.62);
      expect(a.target, b.target);
      expect(a.wind, b.wind);
    });
  });
}
