import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flame_3d/camera.dart';
import 'package:flame_3d/components.dart';
import 'package:flame_3d_demo/demo.dart';

const _width = 1.2;
const _color = Color(0xFFFFFFFF);

final _style = TextStyle(
  color: const Color(0xFF000000),
  shadows: [
    for (var x = 1; x < _width + 5; x++)
      for (var y = 1; y < _width + 5; y++) ...[
        Shadow(offset: Offset(-_width / x, -_width / y), color: _color),
        Shadow(offset: Offset(-_width / x, _width / y), color: _color),
        Shadow(offset: Offset(_width / x, -_width / y), color: _color),
        Shadow(offset: Offset(_width / x, _width / y), color: _color),
      ],
  ],
);

class DebugInfo extends Component with HasGameReference<Demo> {
  DebugInfo() : super(children: [FpsComponent()]);

  String get fps =>
      children.query<FpsComponent>().firstOrNull?.fps.toStringAsFixed(2) ?? '0';

  final _textRight = TextPaint(style: _style, textDirection: TextDirection.rtl);

  late final _meshes =
      game.world.children.query<MeshComponent>().map((e) => e.mesh);

  @override
  void render(Canvas canvas) {
    final CameraComponent3D(:position, :target, :up) = game.camera;

    _textRight.render(
      canvas,
      '''
FPS: $fps
Culled: ${game.world.culled} / ${game.world.children.length}
Meshes: ${_meshes.length}
Surfaces: ${_meshes.fold(0, (p, e) => p + e.surfaceCount)}
Vertices: ${_meshes.fold(0, (p, e) => p + e.vertexCount)}

Position: ${position.x.toStringAsFixed(2)}, ${position.y.toStringAsFixed(2)}, ${position.z.toStringAsFixed(2)}
Target: ${target.x.toStringAsFixed(2)}, ${target.y.toStringAsFixed(2)}, ${target.z.toStringAsFixed(2)}
Up: ${up.x.toStringAsFixed(2)}, ${up.y.toStringAsFixed(2)}, ${up.z.toStringAsFixed(2)}
''',
      Vector2(game.size.x - 8, 8),
      anchor: Anchor.topRight,
    );
  }
}
