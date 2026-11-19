import 'package:flutter/material.dart';
import 'game/basketball_engine.dart';

void main() => runApp(const BasketballShotApp());

class BasketballShotApp extends StatelessWidget {
  const BasketballShotApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Basketball Shot',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange, brightness: Brightness.dark),
    ),
    home: const BasketballScreen(),
  );
}

class BasketballScreen extends StatefulWidget {
  const BasketballScreen({super.key});

  @override
  State<BasketballScreen> createState() => _BasketballScreenState();
}

class _BasketballScreenState extends State<BasketballScreen> {
  final BasketballEngine game = BasketballEngine();
  double aim = 0.5;
  double power = 0.62;

  void restart() => setState(() {
    game.reset();
    aim = 0.5;
    power = 0.62;
  });

  @override
  Widget build(BuildContext context) {
    final isPlaying = game.phase == GamePhase.playing;
    return Scaffold(
      appBar: AppBar(
        title: const Text('BASKETBALL SHOT'),
        actions: [IconButton(
          tooltip: 'Restart',
          onPressed: restart,
          icon: const Icon(Icons.restart_alt),
        )],
      ),
      body: SafeArea(child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550),
        child: ListView(padding: const EdgeInsets.all(14), children: [
          Text('SHOTS ${game.shots}/${game.maxShots}   •   POINTS ${game.points}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text('BASKETS ${game.baskets}    STREAK ${game.streak}'
            '    ACCURACY ${(game.accuracy * 100).round()}%',
            textAlign: TextAlign.center),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.15,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFF8B4E23),
              ),
              child: CustomPaint(
                painter: CourtPainter(
                  target: game.target,
                  aim: aim,
                  landing: game.lastShot?.landing,
                  success: game.lastShot?.scored,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Semantics(liveRegion: true,
            child: Text(game.notice, textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium)),
          const SizedBox(height: 16),
          if (isPlaying) ...[
            Text('AIM  ${(aim * 100).round()}%    '
              'WIND ${game.wind >= 0 ? "+" : ""}${game.wind.toStringAsFixed(2)}'),
            Slider(
              key: const ValueKey('aim-slider'),
              value: aim, min: 0, max: 1,
              onChanged: (value) => setState(() => aim = value),
            ),
            Text('POWER  ${(power * 100).round()}%'),
            Slider(
              key: const ValueKey('power-slider'),
              value: power, min: 0, max: 1,
              onChanged: (value) => setState(() => power = value),
            ),
            FilledButton.icon(
              key: const ValueKey('shoot'),
              onPressed: () => setState(() => game.shoot(aim, power)),
              icon: const Icon(Icons.sports_basketball),
              label: const Text('SHOOT'),
            ),
          ] else
            FilledButton(
              onPressed: () => setState(() {
                if (game.phase == GamePhase.finished) game.reset();
                game.start();
              }),
              child: Text(game.phase == GamePhase.ready
                ? 'START GAME' : 'PLAY AGAIN'),
            ),
          const SizedBox(height: 12),
          const Text('Take ten shots. Match the basket position using aim and '
            'power while accounting for wind. Build streaks for bonus points.',
            textAlign: TextAlign.center),
        ]),
      ))),
    );
  }
}

class CourtPainter extends CustomPainter {
  final double target;
  final double aim;
  final double? landing;
  final bool? success;
  CourtPainter({
    required this.target,
    required this.aim,
    required this.landing,
    required this.success,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final lines = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(
      size.width * .06, size.height * .07,
      size.width * .88, size.height * .86), lines);
    canvas.drawCircle(Offset(size.width / 2, size.height * .55),
      size.width * .17, lines);
    final hoop = Offset(target * size.width, size.height * .27);
    canvas.drawRect(Rect.fromCenter(
      center: Offset(hoop.dx, hoop.dy - 17),
      width: size.width * .20, height: 13),
      Paint()..color = Colors.white);
    canvas.drawOval(Rect.fromCenter(
      center: hoop, width: 56, height: 15),
      Paint()..color = Colors.deepOrangeAccent
        ..style = PaintingStyle.stroke ..strokeWidth = 5);
    final ball = Offset(aim * size.width, size.height * .82);
    canvas.drawCircle(ball, 16, Paint()..color = Colors.orangeAccent);
    canvas.drawLine(Offset(ball.dx - 15, ball.dy),
      Offset(ball.dx + 15, ball.dy), lines);
    canvas.drawLine(Offset(ball.dx, ball.dy - 15),
      Offset(ball.dx, ball.dy + 15), lines);
    if (landing != null) {
      canvas.drawCircle(Offset(landing! * size.width, size.height * .27),
        7, Paint()..color = success == true ?
          Colors.lightGreenAccent : Colors.redAccent);
    }
  }

  @override
  bool shouldRepaint(covariant CourtPainter oldDelegate) =>
      oldDelegate.target != target ||
      oldDelegate.aim != aim ||
      oldDelegate.landing != landing ||
      oldDelegate.success != success;
}
