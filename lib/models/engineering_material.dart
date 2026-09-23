enum MaterialSource {
  source,
  calculated,
  estimated,
}

class EngineeringMaterial {
  final String name;
  final String? standard;
  final String? grade;

  final double? density;
  final String densityUnit;

  final double? yieldStrength;
  final double? tensileStrength;
  final String strengthUnit;

  final MaterialSource source;
  final double confidence;

  final String? note;

  const EngineeringMaterial({
    required this.name,
    this.standard,
    this.grade,
    this.density,
    this.densityUnit = 'kg/m³',
    this.yieldStrength,
    this.tensileStrength,
    this.strengthUnit = 'MPa',
    required this.source,
    required this.confidence,
    this.note,
  });

  bool get hasStandard =>
      standard != null && standard!.isNotEmpty;

  bool get hasGrade =>
      grade != null && grade!.isNotEmpty;

  bool get hasDensity =>
      density != null;

  bool get hasStrengthData =>
      yieldStrength != null ||
      tensileStrength != null;

  bool get isSource =>
      source == MaterialSource.source;

  bool get isCalculated =>
      source == MaterialSource.calculated;

  bool get isEstimated =>
      source == MaterialSource.estimated;

  bool get requiresVerification =>
      source == MaterialSource.estimated ||
      confidence < 0.8;
}
