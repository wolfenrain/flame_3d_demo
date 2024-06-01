import 'package:flame_3d/graphics.dart';
import 'package:flame_3d/resources.dart';
import 'package:flutter_gpu/gpu.dart' as gpu;

class GridMaterial extends Material {
  GridMaterial()
      : super(
          vertexShader: Shader(
            _library['TextureVertex']!,
            slots: [
              UniformSlot.value('VertexInfo', {'model', 'view', 'projection'}),
            ],
          ),
          fragmentShader: Shader(_library['TextureFragment']!),
        );

  @override
  void bind(GraphicsDevice device) {
    vertexShader
      ..setMatrix4('VertexInfo.model', device.model)
      ..setMatrix4('VertexInfo.view', device.view)
      ..setMatrix4('VertexInfo.projection', device.projection);
  }

  static final _library = gpu.ShaderLibrary.fromAsset(
    'assets/shaders/grid_material.shaderbundle',
  )!;
}
