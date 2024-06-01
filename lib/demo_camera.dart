import 'package:flame_3d/camera.dart';
import 'package:flame_3d/game.dart';
import 'package:flutter/gestures.dart';

class DemoCamera extends CameraComponent3D {
  DemoCamera({
    super.world,
    super.viewport,
    super.viewfinder,
    super.backdrop,
    super.hudComponents,
  }) : super(
          projection: CameraProjection.perspective,
          mode: CameraMode.thirdPerson,
          position: Vector3(-3.48, 3.61, 3.20),
          target: Vector3(0, 2, 0),
          up: Vector3(0, 1, 0),
          fovY: 60,
        );

  PointerEvent? pointerEvent;

  @override
  void update(double dt) {
    final event = pointerEvent;
    pointerEvent = null;
    if (event?.buttons == kPrimaryButton) {
      const mouseMoveSensitivity = 0.003;
      yaw(
        -(event?.delta.dx ?? 0) * mouseMoveSensitivity,
        rotateAroundTarget: true,
      );
      pitch(
        -(event?.delta.dy ?? 0) * mouseMoveSensitivity,
        lockView: false,
        rotateAroundTarget: true,
      );
    }
  }
}
