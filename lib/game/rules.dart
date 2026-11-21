import 'package:studio_core/core/arcade.dart';
import 'package:studio_core/core/level_plan.dart';
import 'package:studio_core/core/missions.dart';
import 'package:studio_core/core/stats.dart';
import 'shot_engine.dart';

class BasketballRules extends ArcadeRules<ShotLevel> {
  @override
  String get gameId => 'game-082-basketball-shot';

  @override
  List<String> get optionalMechanics => const [];

  @override
  List<GameStat> get gameStats => const [
        GameStat('baskets', 'Basket', 'Baskets', scale: 300),
        GameStat('swishes', 'Filesiz basket (swish)', 'Swishes', scale: 100),
        GameStat('shots_taken', 'Yapılan atış', 'Shots taken', scale: 300),
        GameStat('best_streak', 'En uzun basket serisi', 'Best streak', scale: 10),
      ];

  @override
  List<MissionTemplate> get missionTemplates => const [
        MissionTemplate('baskets', 'baskets', [75, 150, 300]),
        MissionTemplate('swishes', 'swishes', [12, 25, 50], coinReward: 80),
      ];

  @override
  ShotLevel generate(LevelSpec spec) => generateShot(ShotKind.basketball, spec);

  @override
  ArcadeMeta metaOf(ShotLevel l) => l.meta;

  @override
  ArcadeSim createSim(ShotLevel l) => ShotSim(l);

  @override
  ArcadeInput bot(ArcadeSim sim) => shotBot(sim);
}

ArcadeRules createRules() => BasketballRules();
