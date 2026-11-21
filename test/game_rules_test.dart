import 'package:flutter_test/flutter_test.dart';
import 'package:studio_core/core/arcade.dart';
import 'package:studio_core/core/level_plan.dart';
import 'package:game_082_basketball_shot/game/rules.dart';
import 'package:game_082_basketball_shot/game/shot_engine.dart';

void main() {
  final rules = BasketballRules();
  final planner = LevelPlanner(gameId: rules.gameId, optionalMechanics: rules.optionalMechanics);

  ShotSim fresh([int n = 1]) => ShotSim(rules.build(planner.spec(n)).puzzle);

  test('drag and release fires a shot, a tiny tap does not', () {
    final s = fresh();
    if (s.usesReticle) {
      s.tick(const ArcadeInput(down: true, x: 500, y: 650));
      s.tick(const ArcadeInput(down: false, x: 500, y: 650));
      expect(s.shots, 0, reason: 'too short a hold');
      for (var i = 0; i < 10; i++) {
        s.tick(const ArcadeInput(down: true, x: 500, y: 650));
      }
      s.tick(const ArcadeInput(down: false, x: 500, y: 650));
      expect(s.shots, 1);
    } else {
      s.tick(const ArcadeInput(down: true, x: 500, y: 800));
      s.tick(const ArcadeInput(down: true, x: 503, y: 805));
      s.tick(const ArcadeInput(down: false, x: 503, y: 805));
      expect(s.shots, 0, reason: 'too short a drag');
      s.tick(const ArcadeInput(down: true, x: 500, y: 800));
      s.tick(const ArcadeInput(down: true, x: 500, y: 1000));
      s.tick(const ArcadeInput(down: false, x: 500, y: 1000));
      expect(s.shots, 1);
      expect(s.phase, 1);
    }
  });

  test('failing a round costs a life and restarts the same layout', () {
    final s = fresh(3);
    final before = s.goalText;
    s.roundFailed();
    expect(s.lives, 2);
    expect(s.goalText, before);
    expect(s.over, isFalse);
  });

  test('autopilot clears the first ten levels without losing a life', () {
    for (var n = 1; n <= 10; n++) {
      final s = fresh(n);
      final r = runBot(s, rules.bot, 60 * 60 * 6);
      expect(r.won, isTrue, reason: 'level $n');
      expect(s.stars, greaterThanOrEqualTo(1));
    }
  });

  test('basketball: dropping the ball through the rim scores', () {
    final s = fresh() as HoopSim;
    s.bx = s.hxAt(s.ticks);
    s.by = s.hy - 200;
    s.vx = 0;
    s.vy = 0;
    s.phase = 1;
    s.taken = 1;
    for (var i = 0; i < 120 && s.made == 0; i++) {
      s.tick(ArcadeInput.idle);
    }
    expect(s.made, 1);
  });
}
