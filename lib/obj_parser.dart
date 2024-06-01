import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame_3d/game.dart';
import 'package:flame_3d/resources.dart';
import 'package:flame_3d_demo/surface_tool.dart';

class Face {
  const Face(this.vertex, this.texCoord, this.normal);

  final List<int> vertex;
  final List<int> texCoord;
  final List<int> normal;

  Face.empty()
      : vertex = [],
        texCoord = [],
        normal = [];
}

class MtlParser {
  static Future<Map<String, Material>> parse(String filePath) async {
    final lines = (await Flame.assets.readFile(filePath)).split('\n');

    final materials = <String, SpatialMaterial>{};
    SpatialMaterial? currentMat;
    for (final line in lines) {
      final [type, ...parts] = line.split(' ');

      switch (type) {
        // Comment
        case '#':
          continue;
        // Create new material
        case 'newmtl':
          materials[parts[0].trim()] = currentMat = SpatialMaterial();
          break;
        case 'Ka':
          break;
        case 'Kd':
          final first = parts.first;
          switch (first) {
            case 'spectral':
              break;
            case 'xyz':
              break;
            default:
              currentMat?.albedoColor = Color.fromRGBO(
                (double.parse(first) * 255).toInt(),
                (double.parse(parts.elementAtOrNull(1) ?? first) * 255).toInt(),
                (double.parse(parts.elementAtOrNull(2) ?? first) * 255).toInt(),
                1,
              );
              break;
          }
          break;
        case 'Ks':
          switch (parts[0]) {
            case 'spectral':
              break;
            case 'xyz':
              break;
            default:
              currentMat?.metallic = parts.map(double.parse).fold(0.0, max);
              break;
          }
          break;
        case 'Ns':
          currentMat?.metallic = (1000.0 - double.parse(parts[0])) / 1000.0;
          break;
      }
    }
    return materials;
  }
}

class ObjParser {
  static Future<Mesh> parse(String filePath, {Mesh? applyTo}) async {
    final vertices = <Vector3>[];
    final normals = <Vector3>[];
    final texCoords = <Vector2>[];
    final faces = <String, List<Face>>{};

    final lines = (await Flame.assets.readFile(filePath)).split('\n');

    var materialName = 'default';

    final materials = <String, Material>{};
    for (final line in lines) {
      final [type, ...parts] = line.split(' ');

      switch (type) {
        // Comment
        case '#':
          continue;
        // Vertex
        case 'v':
          vertices.add(Vector3.array(parts.map(double.parse).toList()));
          break;
        // Normal
        case 'vn':
          normals.add(Vector3.array(parts.map(double.parse).toList()));
          break;
        // UV
        case 'vt':
          texCoords.add(Vector2.array(parts.map(double.parse).toList()));
          break;
        // Face
        case 'f':
          if (parts.length == 3) {
            // Single triangle
            final face = Face.empty();
            for (final value in parts) {
              final indices = value.split('/');
              face.vertex.add(int.parse(indices[0]) - 1);
              if (indices[1].isNotEmpty) {
                face.texCoord.add(int.parse(indices[1]) - 1);
              }
              if (indices.length > 2) {
                face.normal.add(int.parse(indices[2]) - 1);
              }
            }
            faces[materialName]?.add(face);
          } else if (parts.length > 4) {
            // Triangulate
            // TODO(wolfen):
          }
          break;
        // Material library
        case 'mtllib':
          final rel = (filePath.split('/')..removeLast()).join('/');
          materials.addAll(await MtlParser.parse('$rel/${parts[0]}'.trim()));
          break;
        // Material
        case 'usemtl':
          materialName = parts[0].trim();

          if (!faces.containsKey(materialName)) {
            if (!materials.containsKey(materialName)) {
              // TODO(wolfen): material not found?
            }
            faces[materialName] = [];
          }
          break;
      }
    }

    var mesh = applyTo ?? Mesh();
    for (final materialGroup in faces.keys) {
      final surface = SurfaceTool()..setMaterial(materials[materialGroup]!);

      for (final face in faces[materialGroup]!) {
        if (face.vertex.length == 3) {
          // Vertices
          final fanVertices = [
            vertices[face.vertex[0]],
            vertices[face.vertex[1]],
            vertices[face.vertex[2]],
          ];

          // Tex coords
          final fanTexCoords = <Vector2>[];
          if (face.texCoord.isNotEmpty) {
            for (final k in [0, 2, 1]) {
              final f = face.texCoord[k];
              if (f > -1) {
                final uv = texCoords[f];
                fanTexCoords.add(uv);
              }
            }
          }

          // Normals
          final fanNormals = [
            if (face.normal.isNotEmpty) ...[
              normals[face.normal[0]],
              normals[face.normal[1]],
              normals[face.normal[2]],
            ],
          ];

          surface.addTriangleFan(fanVertices, fanTexCoords, fanNormals);
        }
      }
      mesh = surface.apply(mesh);
    }
    return mesh;
  }
}

extension on StandardMaterial {
  Vector3 get diffuse {
    final vector = NotifyingVector3.zero();

    return vector
      ..addListener(() {
        albedoColor = Color.fromARGB(
          255,
          (vector.x * 255).toInt(),
          (vector.y * 255).toInt(),
          (vector.z * 255).toInt(),
        );
      });
  }

  Vector3 get specular => Vector3.zero();

  Vector3 get ambient => Vector3.zero();
}
