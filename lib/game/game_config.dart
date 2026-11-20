import 'package:flutter/material.dart';

import '../app/arcade_stage.dart';
import '../app/game_api.dart';
import '../core/game_rules.dart';
import 'shot_engine.dart';
import 'shot_view.dart';
import 'rules.dart';

final gameConfig = GameConfig(
  gameId: 'game-082-basketball-shot',
  title: const ['Basketbol Atışı', 'Basketball Shot', 'Basketball-Wurf', 'Tiro de Baloncesto', 'Tir de Basket'],
  tagline: const ['Fırlat, filelere gönder, seriyi sürdür!', 'Flick, swish and keep the streak!', 'Werfen und treffen!', '¡Lanza y encesta!', 'Lancez et marquez !'],
  seedColor: const Color(0xFFF77F00),
  icon: Icons.sports_basketball,
  rules: BasketballRules(),
  buildPlay: (ctx) => ArcadeStage(
    ctx: ctx,
    create: () => ShotSim((ctx.generated as GeneratedLevel<ShotLevel>).puzzle),
    paint: paintShot,
    sound: shotSound,
    boosterIcon: Icons.add_circle,
    boosterLabel: (l) => l == 'tr' ? '+2 atış' : '+2 shots',
    howTo: const ['Topa bas ve potaya doğru kaydırıp bırak: kaydırma uzunluğu gücü belirler. Yörünge önizlemesi yardımcı olur.', 'Press and flick toward the hoop: the flick length sets the power. A short arc preview helps.', 'Drücken und zum Korb wischen.', 'Pulsa y desliza hacia el aro.', 'Appuyez et lancez vers le panier.'],
  ),
  tutorial: const [
    TutorialStep(Icons.swipe_up, ['Potaya doğru kaydır ve bırak.', 'Flick toward the hoop and release.', 'Zum Korb wischen.', 'Desliza hacia el aro.', 'Glissez vers le panier.']),
    TutorialStep(Icons.timeline, ['Beyaz noktalar yörüngenin başını gösterir.', 'White dots preview the arc.', 'Punkte zeigen die Flugbahn.', 'Los puntos muestran el arco.', 'Les points montrent la trajectoire.']),
    TutorialStep(Icons.star, ['Çembere değmeden atarsan SWISH bonusu.', 'Nothing but net = SWISH bonus.', 'Swish-Bonus.', 'Bonus swish.', 'Bonus swish.']),
  ],
);
