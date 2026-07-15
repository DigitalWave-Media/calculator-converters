import 'dart:math' as math;
import '../models/measurement_shape.dart';

class MeasurementCalculator {
  static const List<ShapeDefinition> areaShapes = [
    ShapeDefinition(
      id: 'square',
      name: 'Square',
      type: MeasurementType.area,
      description: 'Square area from side length',
      fields: [
        DimensionFieldConfig(key: 's', label: 'Side Length', hint: 'e.g. 5', symbol: 's'),
      ],
    ),
    ShapeDefinition(
      id: 'rectangle',
      name: 'Rectangle',
      type: MeasurementType.area,
      description: 'Rectangular area from length & width',
      fields: [
        DimensionFieldConfig(key: 'l', label: 'Length', hint: 'e.g. 10', symbol: 'l'),
        DimensionFieldConfig(key: 'w', label: 'Width', hint: 'e.g. 5', symbol: 'w'),
      ],
    ),
    ShapeDefinition(
      id: 'quadrilateral',
      name: 'Quadrilateral',
      type: MeasurementType.area,
      description: 'Area via diagonal and 2 perpendicular heights',
      fields: [
        DimensionFieldConfig(key: 'diag', label: 'Diagonal', hint: 'e.g. 12', symbol: 'd'),
        DimensionFieldConfig(key: 'h1', label: 'Height 1', hint: 'e.g. 4', symbol: 'h₁'),
        DimensionFieldConfig(key: 'h2', label: 'Height 2', hint: 'e.g. 5', symbol: 'h₂'),
      ],
    ),
    ShapeDefinition(
      id: 'diamond',
      name: 'Diamond (Rhombus)',
      type: MeasurementType.area,
      description: 'Rhombus area from perpendicular diagonals',
      fields: [
        DimensionFieldConfig(key: 'd1', label: 'Diagonal 1', hint: 'e.g. 8', symbol: 'd₁'),
        DimensionFieldConfig(key: 'd2', label: 'Diagonal 2', hint: 'e.g. 6', symbol: 'd₂'),
      ],
    ),
    ShapeDefinition(
      id: 'kite',
      name: 'Kite',
      type: MeasurementType.area,
      description: 'Kite surface area from perpendicular diagonals',
      fields: [
        DimensionFieldConfig(key: 'd1', label: 'Diagonal 1', hint: 'e.g. 10', symbol: 'd₁'),
        DimensionFieldConfig(key: 'd2', label: 'Diagonal 2', hint: 'e.g. 7', symbol: 'd₂'),
      ],
    ),
    ShapeDefinition(
      id: 'trapezoid',
      name: 'Trapezoid',
      type: MeasurementType.area,
      description: 'Trapezoidal site area from top base, bottom base & vertical height',
      fields: [
        DimensionFieldConfig(key: 'a', label: 'Top Base', hint: 'e.g. 4', symbol: 'a'),
        DimensionFieldConfig(key: 'b', label: 'Bottom Base', hint: 'e.g. 8', symbol: 'b'),
        DimensionFieldConfig(key: 'h', label: 'Vertical Height', hint: 'e.g. 5', symbol: 'h'),
      ],
    ),
    ShapeDefinition(
      id: 'circle',
      name: 'Circle',
      type: MeasurementType.area,
      description: 'Circular footprint area from radius',
      fields: [
        DimensionFieldConfig(key: 'r', label: 'Radius', hint: 'e.g. 3.5', symbol: 'r'),
      ],
    ),
    ShapeDefinition(
      id: 'semicircle',
      name: 'Semicircle',
      type: MeasurementType.area,
      description: 'Half circle area from radius',
      fields: [
        DimensionFieldConfig(key: 'r', label: 'Radius', hint: 'e.g. 4', symbol: 'r'),
      ],
    ),
    ShapeDefinition(
      id: 'ellipse',
      name: 'Ellipse',
      type: MeasurementType.area,
      description: 'Elliptical region from semi-major & semi-minor axes',
      fields: [
        DimensionFieldConfig(key: 'a', label: 'Semi-major Axis', hint: 'e.g. 6', symbol: 'a'),
        DimensionFieldConfig(key: 'b', label: 'Semi-minor Axis', hint: 'e.g. 4', symbol: 'b'),
      ],
    ),
    ShapeDefinition(
      id: 'ring',
      name: 'Ring (Annulus)',
      type: MeasurementType.area,
      description: 'Concentric ring area from outer and inner radius',
      fields: [
        DimensionFieldConfig(key: 'R', label: 'Outer Radius', hint: 'e.g. 10', symbol: 'R'),
        DimensionFieldConfig(key: 'r', label: 'Inner Radius', hint: 'e.g. 6', symbol: 'r'),
      ],
    ),
    ShapeDefinition(
      id: 'sector',
      name: 'Sector',
      type: MeasurementType.area,
      description: 'Circular arc sector area from radius and angle in degrees',
      fields: [
        DimensionFieldConfig(key: 'r', label: 'Radius', hint: 'e.g. 5', symbol: 'r'),
        DimensionFieldConfig(key: 'angle', label: 'Central Angle (°)', hint: 'e.g. 60', symbol: 'θ'),
      ],
    ),
  ];

  static const List<ShapeDefinition> volumeShapes = [
    // Category A: Cubes & Prisms
    ShapeDefinition(
      id: 'cube',
      name: 'Cube',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.cubesAndPrisms,
      description: 'Equilateral cubic volume',
      fields: [
        DimensionFieldConfig(key: 's', label: 'Side Length', hint: 'e.g. 4', symbol: 's'),
      ],
    ),
    ShapeDefinition(
      id: 'rectangular_prism',
      name: 'Rectangular Prism (Slabs/Beams)',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.cubesAndPrisms,
      description: 'Volume of concrete slab or beam',
      fields: [
        DimensionFieldConfig(key: 'l', label: 'Length', hint: 'e.g. 12', symbol: 'l'),
        DimensionFieldConfig(key: 'w', label: 'Width', hint: 'e.g. 6', symbol: 'w'),
        DimensionFieldConfig(key: 'h', label: 'Height / Thickness', hint: 'e.g. 0.15', symbol: 'h'),
      ],
    ),
    ShapeDefinition(
      id: 'trapezoid_prism',
      name: 'Trapezoid Prism (Footings)',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.cubesAndPrisms,
      description: 'Tapered footing foundation volume',
      fields: [
        DimensionFieldConfig(key: 'l', label: 'Total Length', hint: 'e.g. 15', symbol: 'l'),
        DimensionFieldConfig(key: 'w1', label: 'Top Width', hint: 'e.g. 2', symbol: 'w₁'),
        DimensionFieldConfig(key: 'w2', label: 'Bottom Width', hint: 'e.g. 4', symbol: 'w₂'),
        DimensionFieldConfig(key: 'h', label: 'Vertical Height', hint: 'e.g. 1.5', symbol: 'h'),
      ],
    ),
    ShapeDefinition(
      id: 'dumper',
      name: 'Dumper (Truck Earthwork)',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.cubesAndPrisms,
      description: 'Prismoidal volume of truck body or excavated pit',
      fields: [
        DimensionFieldConfig(key: 'l1', label: 'Top Length', hint: 'e.g. 5', symbol: 'l₁'),
        DimensionFieldConfig(key: 'w1', label: 'Top Width', hint: 'e.g. 2.5', symbol: 'w₁'),
        DimensionFieldConfig(key: 'l2', label: 'Bottom Length', hint: 'e.g. 4', symbol: 'l₂'),
        DimensionFieldConfig(key: 'w2', label: 'Bottom Width', hint: 'e.g. 2', symbol: 'w₂'),
        DimensionFieldConfig(key: 'h', label: 'Fill Depth', hint: 'e.g. 1.8', symbol: 'h'),
      ],
    ),
    ShapeDefinition(
      id: 'parallelepiped',
      name: 'Parallelepiped',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.cubesAndPrisms,
      description: 'Inclined prism volume with tilt angle',
      fields: [
        DimensionFieldConfig(key: 'l', label: 'Length', hint: 'e.g. 8', symbol: 'l'),
        DimensionFieldConfig(key: 'w', label: 'Width', hint: 'e.g. 4', symbol: 'w'),
        DimensionFieldConfig(key: 'h', label: 'Height', hint: 'e.g. 5', symbol: 'h'),
        DimensionFieldConfig(key: 'tilt', label: 'Tilt Angle (°)', hint: 'e.g. 75', symbol: 'θ'),
      ],
    ),

    // Category B: Prisms & Pyramids
    ShapeDefinition(
      id: 'triangular_prism',
      name: 'Triangular Prism',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.prismsAndPyramids,
      description: 'Roof truss or triangular concrete wedge volume',
      fields: [
        DimensionFieldConfig(key: 'b', label: 'Triangular Base', hint: 'e.g. 6', symbol: 'b'),
        DimensionFieldConfig(key: 'h', label: 'Triangle Height', hint: 'e.g. 4', symbol: 'h'),
        DimensionFieldConfig(key: 'l', label: 'Prism Length', hint: 'e.g. 10', symbol: 'l'),
      ],
    ),
    ShapeDefinition(
      id: 'prism',
      name: 'General Prism',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.prismsAndPyramids,
      description: 'Uniform section volume from base area & height',
      fields: [
        DimensionFieldConfig(key: 'base_area', label: 'Base Area', hint: 'e.g. 25', symbol: 'A'),
        DimensionFieldConfig(key: 'h', label: 'Vertical Height', hint: 'e.g. 8', symbol: 'h'),
      ],
    ),
    ShapeDefinition(
      id: 'pyramid',
      name: 'Pyramid',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.prismsAndPyramids,
      description: 'Rectangular base pyramid volume',
      fields: [
        DimensionFieldConfig(key: 'l', label: 'Base Length', hint: 'e.g. 6', symbol: 'l'),
        DimensionFieldConfig(key: 'w', label: 'Base Width', hint: 'e.g. 6', symbol: 'w'),
        DimensionFieldConfig(key: 'h', label: 'Height', hint: 'e.g. 9', symbol: 'h'),
      ],
    ),
    ShapeDefinition(
      id: 'hexagonal_prism',
      name: 'Hexagonal Prism',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.prismsAndPyramids,
      description: 'Regular 6-sided prism column volume',
      fields: [
        DimensionFieldConfig(key: 'a', label: 'Hexagon Side Length', hint: 'e.g. 3', symbol: 'a'),
        DimensionFieldConfig(key: 'h', label: 'Total Height', hint: 'e.g. 10', symbol: 'h'),
      ],
    ),

    // Category C: Cylinders & Cones
    ShapeDefinition(
      id: 'cylinder',
      name: 'Cylinder (Piles/Columns)',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.cylindersAndCones,
      description: 'Concrete pile or round column volume',
      fields: [
        DimensionFieldConfig(key: 'r', label: 'Radius', hint: 'e.g. 0.5', symbol: 'r'),
        DimensionFieldConfig(key: 'h', label: 'Vertical Height', hint: 'e.g. 4', symbol: 'h'),
      ],
    ),
    ShapeDefinition(
      id: 'tube',
      name: 'Tube (Hollow Cylinder)',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.cylindersAndCones,
      description: 'Hollow cylindrical wall volume',
      fields: [
        DimensionFieldConfig(key: 'R', label: 'Outer Radius', hint: 'e.g. 1.0', symbol: 'R'),
        DimensionFieldConfig(key: 'r', label: 'Inner Radius', hint: 'e.g. 0.8', symbol: 'r'),
        DimensionFieldConfig(key: 'h', label: 'Height / Length', hint: 'e.g. 6', symbol: 'h'),
      ],
    ),
    ShapeDefinition(
      id: 'cylindrical_tube',
      name: 'Cylindrical Tube (Pipes)',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.cylindersAndCones,
      description: 'Pipe shell volume from outer diameter & wall thickness',
      fields: [
        DimensionFieldConfig(key: 'D', label: 'Outer Diameter', hint: 'e.g. 1.2', symbol: 'D'),
        DimensionFieldConfig(key: 't', label: 'Wall Thickness', hint: 'e.g. 0.1', symbol: 't'),
        DimensionFieldConfig(key: 'L', label: 'Total Length', hint: 'e.g. 10', symbol: 'L'),
      ],
    ),
    ShapeDefinition(
      id: 'cone',
      name: 'Cone (Stockpiles)',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.cylindersAndCones,
      description: 'Aggregate stockpile conical volume',
      fields: [
        DimensionFieldConfig(key: 'r', label: 'Base Radius', hint: 'e.g. 4', symbol: 'r'),
        DimensionFieldConfig(key: 'h', label: 'Vertical Height', hint: 'e.g. 3', symbol: 'h'),
      ],
    ),

    // Category D: Spheres & Domes
    ShapeDefinition(
      id: 'sphere',
      name: 'Sphere',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.spheresAndOthers,
      description: 'Spherical volume from radius',
      fields: [
        DimensionFieldConfig(key: 'r', label: 'Radius', hint: 'e.g. 3', symbol: 'r'),
      ],
    ),
    ShapeDefinition(
      id: 'hemisphere',
      name: 'Hemisphere (Dome)',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.spheresAndOthers,
      description: 'Architectural dome hemispherical volume',
      fields: [
        DimensionFieldConfig(key: 'r', label: 'Radius', hint: 'e.g. 5', symbol: 'r'),
      ],
    ),
    ShapeDefinition(
      id: 'ellipsoid',
      name: 'Ellipsoid',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.spheresAndOthers,
      description: 'Tri-axial ellipsoid volume',
      fields: [
        DimensionFieldConfig(key: 'a', label: 'Radius A', hint: 'e.g. 5', symbol: 'a'),
        DimensionFieldConfig(key: 'b', label: 'Radius B', hint: 'e.g. 4', symbol: 'b'),
        DimensionFieldConfig(key: 'c', label: 'Radius C', hint: 'e.g. 3', symbol: 'c'),
      ],
    ),
    ShapeDefinition(
      id: 'frustum',
      name: 'Frustum (Truncated Cone)',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.spheresAndOthers,
      description: 'Bucket or tapered pier frustum volume',
      fields: [
        DimensionFieldConfig(key: 'r1', label: 'Top Radius', hint: 'e.g. 2', symbol: 'r₁'),
        DimensionFieldConfig(key: 'r2', label: 'Bottom Radius', hint: 'e.g. 4', symbol: 'r₂'),
        DimensionFieldConfig(key: 'h', label: 'Vertical Height', hint: 'e.g. 6', symbol: 'h'),
      ],
    ),
    ShapeDefinition(
      id: 'barrel',
      name: 'Barrel (Storage Drums)',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.spheresAndOthers,
      description: 'Storage barrel liquid volume',
      fields: [
        DimensionFieldConfig(key: 'h', label: 'Total Height', hint: 'e.g. 1.2', symbol: 'h'),
        DimensionFieldConfig(key: 'd', label: 'End Diameter', hint: 'e.g. 0.6', symbol: 'd'),
        DimensionFieldConfig(key: 'D', label: 'Belly Diameter', hint: 'e.g. 0.8', symbol: 'D'),
      ],
    ),

    // Category E: Complex Site Works
    ShapeDefinition(
      id: 'hollow_rectangle',
      name: 'Hollow Rectangle (Foundation Pits)',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.complexSiteWorks,
      description: 'Excavation volume surrounding basement cores',
      fields: [
        DimensionFieldConfig(key: 'Lo', label: 'Outer Length', hint: 'e.g. 20', symbol: 'Lₒ'),
        DimensionFieldConfig(key: 'Wo', label: 'Outer Width', hint: 'e.g. 15', symbol: 'Wₒ'),
        DimensionFieldConfig(key: 'Li', label: 'Inner Length', hint: 'e.g. 14', symbol: 'Lᵢ'),
        DimensionFieldConfig(key: 'Wi', label: 'Inner Width', hint: 'e.g. 10', symbol: 'Wᵢ'),
        DimensionFieldConfig(key: 'h', label: 'Total Depth', hint: 'e.g. 3', symbol: 'h'),
      ],
    ),
    ShapeDefinition(
      id: 'l_shape',
      name: 'L-Shape (Corner Beams)',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.complexSiteWorks,
      description: 'L-shaped retaining wall or beam volume',
      fields: [
        DimensionFieldConfig(key: 'l1', label: 'Sec 1 Length', hint: 'e.g. 10', symbol: 'L₁'),
        DimensionFieldConfig(key: 'w1', label: 'Sec 1 Width', hint: 'e.g. 2', symbol: 'W₁'),
        DimensionFieldConfig(key: 'h1', label: 'Sec 1 Height', hint: 'e.g. 3', symbol: 'H₁'),
        DimensionFieldConfig(key: 'l2', label: 'Sec 2 Length', hint: 'e.g. 8', symbol: 'L₂'),
        DimensionFieldConfig(key: 'w2', label: 'Sec 2 Width', hint: 'e.g. 2', symbol: 'W₂'),
        DimensionFieldConfig(key: 'h2', label: 'Sec 2 Height', hint: 'e.g. 3', symbol: 'H₂'),
      ],
    ),
    ShapeDefinition(
      id: 'pipe_culvert',
      name: 'Pipe Culvert (Storm Drainage)',
      type: MeasurementType.volume,
      volumeCategory: VolumeCategory.complexSiteWorks,
      description: 'Multi-row drainage pipe concrete shell volume',
      fields: [
        DimensionFieldConfig(key: 'Do', label: 'Outer Diameter', hint: 'e.g. 1.2', symbol: 'Dₒ'),
        DimensionFieldConfig(key: 'Di', label: 'Inner Diameter', hint: 'e.g. 1.0', symbol: 'Dᵢ'),
        DimensionFieldConfig(key: 'L', label: 'Pipe Length', hint: 'e.g. 15', symbol: 'L'),
        DimensionFieldConfig(key: 'N', label: 'Number of Rows', hint: 'e.g. 3', symbol: 'N'),
      ],
    ),
  ];

  static ShapeDefinition getShapeById(String id) {
    for (final s in areaShapes) {
      if (s.id == id) return s;
    }
    for (final s in volumeShapes) {
      if (s.id == id) return s;
    }
    return areaShapes.first;
  }

  static MeasurementResult calculate({
    required ShapeDefinition shape,
    required Map<String, double> values,
    required bool isAdvancedMode,
    double wastagePercentage = 0.0,
    double? unitCost,
  }) {
    double raw = 0.0;
    List<String> steps = [];

    switch (shape.id) {
      // Area Shapes
      case 'square':
        final s = values['s'] ?? 0.0;
        raw = s * s;
        steps.add('Area = side × side');
        steps.add('Area = $s × $s = ${raw.toStringAsFixed(3)}');
        break;
      case 'rectangle':
        final l = values['l'] ?? 0.0;
        final w = values['w'] ?? 0.0;
        raw = l * w;
        steps.add('Area = length × width');
        steps.add('Area = $l × $w = ${raw.toStringAsFixed(3)}');
        break;
      case 'quadrilateral':
        final d = values['diag'] ?? 0.0;
        final h1 = values['h1'] ?? 0.0;
        final h2 = values['h2'] ?? 0.0;
        raw = 0.5 * d * (h1 + h2);
        steps.add('Area = ½ × diagonal × (h₁ + h₂)');
        steps.add('Area = ½ × $d × ($h1 + $h2) = ${raw.toStringAsFixed(3)}');
        break;
      case 'diamond':
      case 'kite':
        final d1 = values['d1'] ?? 0.0;
        final d2 = values['d2'] ?? 0.0;
        raw = 0.5 * d1 * d2;
        steps.add('Area = ½ × d₁ × d₂');
        steps.add('Area = ½ × $d1 × $d2 = ${raw.toStringAsFixed(3)}');
        break;
      case 'trapezoid':
        final a = values['a'] ?? 0.0;
        final b = values['b'] ?? 0.0;
        final h = values['h'] ?? 0.0;
        raw = 0.5 * (a + b) * h;
        steps.add('Area = ½ × (a + b) × h');
        steps.add('Area = ½ × ($a + $b) × $h = ${raw.toStringAsFixed(3)}');
        break;
      case 'circle':
        final r = values['r'] ?? 0.0;
        raw = math.pi * r * r;
        steps.add('Area = π × r²');
        steps.add('Area = π × $r² = ${raw.toStringAsFixed(3)}');
        break;
      case 'semicircle':
        final r = values['r'] ?? 0.0;
        raw = 0.5 * math.pi * r * r;
        steps.add('Area = ½ × π × r²');
        steps.add('Area = ½ × π × $r² = ${raw.toStringAsFixed(3)}');
        break;
      case 'ellipse':
        final a = values['a'] ?? 0.0;
        final b = values['b'] ?? 0.0;
        raw = math.pi * a * b;
        steps.add('Area = π × a × b');
        steps.add('Area = π × $a × $b = ${raw.toStringAsFixed(3)}');
        break;
      case 'ring':
        final R = values['R'] ?? 0.0;
        final r = values['r'] ?? 0.0;
        raw = math.pi * math.max(0.0, (R * R - r * r));
        steps.add('Area = π × (R² - r²)');
        steps.add('Area = π × ($R² - $r²) = ${raw.toStringAsFixed(3)}');
        break;
      case 'sector':
        final r = values['r'] ?? 0.0;
        final angle = values['angle'] ?? 0.0;
        raw = (angle / 360.0) * math.pi * r * r;
        steps.add('Area = (θ / 360) × π × r²');
        steps.add('Area = ($angle / 360) × π × $r² = ${raw.toStringAsFixed(3)}');
        break;

      // Volume Category A
      case 'cube':
        final s = values['s'] ?? 0.0;
        raw = s * s * s;
        steps.add('Volume = side³');
        steps.add('Volume = $s³ = ${raw.toStringAsFixed(3)}');
        break;
      case 'rectangular_prism':
        final l = values['l'] ?? 0.0;
        final w = values['w'] ?? 0.0;
        final h = values['h'] ?? 0.0;
        raw = l * w * h;
        steps.add('Volume = length × width × height');
        steps.add('Volume = $l × $w × $h = ${raw.toStringAsFixed(3)}');
        break;
      case 'trapezoid_prism':
        final l = values['l'] ?? 0.0;
        final w1 = values['w1'] ?? 0.0;
        final w2 = values['w2'] ?? 0.0;
        final h = values['h'] ?? 0.0;
        raw = 0.5 * (w1 + w2) * h * l;
        steps.add('Volume = [½ × (w₁ + w₂) × h] × length');
        steps.add('Volume = [½ × ($w1 + $w2) × $h] × $l = ${raw.toStringAsFixed(3)}');
        break;
      case 'dumper':
        final l1 = values['l1'] ?? 0.0;
        final w1 = values['w1'] ?? 0.0;
        final l2 = values['l2'] ?? 0.0;
        final w2 = values['w2'] ?? 0.0;
        final h = values['h'] ?? 0.0;
        final a1 = l1 * w1;
        final a2 = l2 * w2;
        final am = ((l1 + l2) / 2.0) * ((w1 + w2) / 2.0);
        raw = (h / 6.0) * (a1 + a2 + 4.0 * am);
        steps.add('A₁ (Top Area) = $l1 × $w1 = ${a1.toStringAsFixed(3)}');
        steps.add('A₂ (Bottom Area) = $l2 × $w2 = ${a2.toStringAsFixed(3)}');
        steps.add('Am (Mid Area) = ${am.toStringAsFixed(3)}');
        steps.add('Volume = (h/6) × (A₁ + A₂ + 4Am) = ${raw.toStringAsFixed(3)}');
        break;
      case 'parallelepiped':
        final l = values['l'] ?? 0.0;
        final w = values['w'] ?? 0.0;
        final h = values['h'] ?? 0.0;
        final tilt = values['tilt'] ?? 90.0;
        final rad = tilt * (math.pi / 180.0);
        raw = l * w * h * math.sin(rad);
        steps.add('Volume = l × w × h × sin(θ)');
        steps.add('Volume = $l × $w × $h × sin($tilt°) = ${raw.toStringAsFixed(3)}');
        break;

      // Volume Category B
      case 'triangular_prism':
        final b = values['b'] ?? 0.0;
        final h = values['h'] ?? 0.0;
        final l = values['l'] ?? 0.0;
        raw = 0.5 * b * h * l;
        steps.add('Volume = (½ × base × height) × length');
        steps.add('Volume = (½ × $b × $h) × $l = ${raw.toStringAsFixed(3)}');
        break;
      case 'prism':
        final baseArea = values['base_area'] ?? 0.0;
        final h = values['h'] ?? 0.0;
        raw = baseArea * h;
        steps.add('Volume = Base Area × Height');
        steps.add('Volume = $baseArea × $h = ${raw.toStringAsFixed(3)}');
        break;
      case 'pyramid':
        final l = values['l'] ?? 0.0;
        final w = values['w'] ?? 0.0;
        final h = values['h'] ?? 0.0;
        raw = (1.0 / 3.0) * (l * w) * h;
        steps.add('Volume = ⅓ × (length × width) × height');
        steps.add('Volume = ⅓ × ($l × $w) × $h = ${raw.toStringAsFixed(3)}');
        break;
      case 'hexagonal_prism':
        final a = values['a'] ?? 0.0;
        final h = values['h'] ?? 0.0;
        raw = (3.0 * math.sqrt(3) / 2.0) * a * a * h;
        steps.add('Volume = [3√3 / 2 × a²] × h');
        steps.add('Volume = [3√3 / 2 × $a²] × $h = ${raw.toStringAsFixed(3)}');
        break;

      // Volume Category C
      case 'cylinder':
        final r = values['r'] ?? 0.0;
        final h = values['h'] ?? 0.0;
        raw = math.pi * r * r * h;
        steps.add('Volume = π × r² × h');
        steps.add('Volume = π × $r² × $h = ${raw.toStringAsFixed(3)}');
        break;
      case 'tube':
        final R = values['R'] ?? 0.0;
        final r = values['r'] ?? 0.0;
        final h = values['h'] ?? 0.0;
        raw = math.pi * math.max(0.0, (R * R - r * r)) * h;
        steps.add('Volume = π × (R² - r²) × h');
        steps.add('Volume = π × ($R² - $r²) × $h = ${raw.toStringAsFixed(3)}');
        break;
      case 'cylindrical_tube':
        final D = values['D'] ?? 0.0;
        final t = values['t'] ?? 0.0;
        final L = values['L'] ?? 0.0;
        final ro = D / 2.0;
        final ri = math.max(0.0, ro - t);
        raw = math.pi * (ro * ro - ri * ri) * L;
        steps.add('Outer radius = $D / 2 = $ro');
        steps.add('Inner radius = $ro - $t = $ri');
        steps.add('Volume = π × (R² - r²) × L = ${raw.toStringAsFixed(3)}');
        break;
      case 'cone':
        final r = values['r'] ?? 0.0;
        final h = values['h'] ?? 0.0;
        raw = (1.0 / 3.0) * math.pi * r * r * h;
        steps.add('Volume = ⅓ × π × r² × h');
        steps.add('Volume = ⅓ × π × $r² × $h = ${raw.toStringAsFixed(3)}');
        break;

      // Volume Category D
      case 'sphere':
        final r = values['r'] ?? 0.0;
        raw = (4.0 / 3.0) * math.pi * math.pow(r, 3);
        steps.add('Volume = 4/3 × π × r³');
        steps.add('Volume = 4/3 × π × $r³ = ${raw.toStringAsFixed(3)}');
        break;
      case 'hemisphere':
        final r = values['r'] ?? 0.0;
        raw = (2.0 / 3.0) * math.pi * math.pow(r, 3);
        steps.add('Volume = ⅔ × π × r³');
        steps.add('Volume = ⅔ × π × $r³ = ${raw.toStringAsFixed(3)}');
        break;
      case 'ellipsoid':
        final a = values['a'] ?? 0.0;
        final b = values['b'] ?? 0.0;
        final c = values['c'] ?? 0.0;
        raw = (4.0 / 3.0) * math.pi * a * b * c;
        steps.add('Volume = 4/3 × π × a × b × c');
        steps.add('Volume = 4/3 × π × $a × $b × $c = ${raw.toStringAsFixed(3)}');
        break;
      case 'frustum':
        final r1 = values['r1'] ?? 0.0;
        final r2 = values['r2'] ?? 0.0;
        final h = values['h'] ?? 0.0;
        raw = (1.0 / 3.0) * math.pi * h * (r1 * r1 + r2 * r2 + r1 * r2);
        steps.add('Volume = ⅓ × π × h × (r₁² + r₂² + r₁×r₂)');
        steps.add('Volume = ⅓ × π × $h × ($r1² + $r2² + $r1×$r2) = ${raw.toStringAsFixed(3)}');
        break;
      case 'barrel':
        final h = values['h'] ?? 0.0;
        final d = values['d'] ?? 0.0;
        final D = values['D'] ?? 0.0;
        raw = (math.pi * h / 12.0) * (2.0 * D * D + d * d);
        steps.add('Volume ≈ (π × h / 12) × (2D² + d²)');
        steps.add('Volume ≈ (π × $h / 12) × (2($D)² + ($d)²) = ${raw.toStringAsFixed(3)}');
        break;

      // Volume Category E
      case 'hollow_rectangle':
        final lo = values['Lo'] ?? 0.0;
        final wo = values['Wo'] ?? 0.0;
        final li = values['Li'] ?? 0.0;
        final wi = values['Wi'] ?? 0.0;
        final h = values['h'] ?? 0.0;
        raw = math.max(0.0, (lo * wo - li * wi)) * h;
        steps.add('Outer Area = $lo × $wo = ${(lo * wo).toStringAsFixed(3)}');
        steps.add('Inner Area = $li × $wi = ${(li * wi).toStringAsFixed(3)}');
        steps.add('Volume = (Outer - Inner) × h = ${raw.toStringAsFixed(3)}');
        break;
      case 'l_shape':
        final l1 = values['l1'] ?? 0.0;
        final w1 = values['w1'] ?? 0.0;
        final h1 = values['h1'] ?? 0.0;
        final l2 = values['l2'] ?? 0.0;
        final w2 = values['w2'] ?? 0.0;
        final h2 = values['h2'] ?? 0.0;
        final v1 = l1 * w1 * h1;
        final v2 = l2 * w2 * h2;
        raw = v1 + v2;
        steps.add('V₁ = $l1 × $w1 × $h1 = ${v1.toStringAsFixed(3)}');
        steps.add('V₂ = $l2 × $w2 × $h2 = ${v2.toStringAsFixed(3)}');
        steps.add('Volume = V₁ + V₂ = ${raw.toStringAsFixed(3)}');
        break;
      case 'pipe_culvert':
        final doVal = values['Do'] ?? 0.0;
        final diVal = values['Di'] ?? 0.0;
        final L = values['L'] ?? 0.0;
        final N = values['N'] ?? 1.0;
        final ro = doVal / 2.0;
        final ri = diVal / 2.0;
        raw = N * math.pi * math.max(0.0, (ro * ro - ri * ri)) * L;
        steps.add('Cross-section Area = π × (R² - r²) = ${(math.pi * math.max(0.0, (ro * ro - ri * ri))).toStringAsFixed(3)}');
        steps.add('Volume = N × Area × L = $N × Area × $L = ${raw.toStringAsFixed(3)}');
        break;
    }

    final gross = raw * (1.0 + (isAdvancedMode ? wastagePercentage / 100.0 : 0.0));
    final double? totalCost = (isAdvancedMode && unitCost != null) ? gross * unitCost : null;
    final unitSymbol = shape.type == MeasurementType.area ? 'm²' : 'm³';

    return MeasurementResult(
      rawValue: raw,
      grossValueWithWastage: gross,
      totalCost: totalCost,
      wastagePercentage: isAdvancedMode ? wastagePercentage : 0.0,
      unitCost: isAdvancedMode ? unitCost : null,
      unitSymbol: unitSymbol,
      calculationSteps: steps,
    );
  }
}
