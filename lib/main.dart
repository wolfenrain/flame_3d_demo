import 'package:flame/flame.dart';
import 'package:flame_3d_demo/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:flame/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();

  final demo = Demo();
  runApp(
    Listener(
      onPointerMove: (event) => demo.camera.pointerEvent = event,
      onPointerUp: (_) => demo.camera.pointerEvent = null,
      onPointerCancel: (_) => demo.camera.pointerEvent = null,
      child: GameWidget(game: demo),
    ),
  );
}
