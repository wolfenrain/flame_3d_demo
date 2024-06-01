import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame_3d/components.dart';
import 'package:flame_3d/game.dart';
import 'package:flame_3d/resources.dart';
import 'package:flame_3d_demo/demo_camera.dart';
import 'package:flame_3d/camera.dart';
import 'package:flame_3d_demo/grid_material.dart';
import 'package:flame_3d_demo/obj_parser.dart';
import 'package:flame_3d_demo/debug_info.dart';

class Demo extends FlameGame3D<World3D> {
  Demo()
      : super(
          world: World3D(clearColor: const Color(0xFF000000)),
          camera: DemoCamera(hudComponents: [DebugInfo()])..moveToTarget(1.5),
        );

  @override
  DemoCamera get camera => super.camera as DemoCamera;

  final player = MeshComponent(
    position: Vector3(0, .5, 0),
    mesh: CuboidMesh(
      size: Vector3.all(1),
      material: SpatialMaterial(albedoColor: const Color(0xFFFF00FF)),
    ),
  );

  final light = MeshComponent(
    scale: Vector3.all(0.5),
    mesh: CuboidMesh(
      size: Vector3.all(1),
      material: GridMaterial(),
    ),
  );

  @override
  FutureOr<void> onLoad() async {
    world.add(player);
    world.add(MeshComponent(
      mesh: PlaneMesh(
        size: Vector2.all(100),
        material: SpatialMaterial(albedoColor: const Color(0xFF0000FF)),
      ),
    ));

    final rnd = Random(1336);

    // final mesh = await ObjParser.parse('objects/buoy.obj');
    // const amount = 10.0;
    world.addAll([
      light,
      //   for (var x = -amount; x < amount; x += 2)
      //     for (var y = -amount; y < amount; y += 2)
      //       MeshComponent(
      //         position: Vector3(x, 0, -y),
      //         rotation: Quaternion.euler(rnd.nextDouble() * 6,
      //             rnd.nextDouble() * 6, rnd.nextDouble() * 6),
      //         mesh: mesh,
      //       ),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);

    const radius = 15;
    final angle = DateTime.now().millisecondsSinceEpoch / 4000;
    final x = cos(angle) * radius;
    final z = sin(angle) * radius;

    light.position.setValues(x, 10, z);
  }
}
