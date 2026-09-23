enum ViewerProjection {
  perspective,
  orthographic,
}

enum ViewerRenderMode {
  shaded,
  wireframe,
  shadedWireframe,
}

enum ViewerInteractionMode {
  orbit,
  pan,
  zoom,
  measure,
  section,
}

class ViewerState {
  final ViewerProjection projection;
  final ViewerRenderMode renderMode;
  final ViewerInteractionMode interactionMode;

  final double rotationX;
  final double rotationY;
  final double rotationZ;

  final double zoom;

  final bool showDimensions;
  final bool showAxes;
  final bool showGrid;
  final bool sectionEnabled;

  final String? sectionPlane;

  const ViewerState({
    this.projection = ViewerProjection.perspective,
    this.renderMode = ViewerRenderMode.shaded,
    this.interactionMode = ViewerInteractionMode.orbit,
    this.rotationX = 0,
    this.rotationY = 0,
    this.rotationZ = 0,
    this.zoom = 1,
    this.showDimensions = true,
    this.showAxes = true,
    this.showGrid = true,
    this.sectionEnabled = false,
    this.sectionPlane,
  });

  bool get isPerspective =>
      projection == ViewerProjection.perspective;

  bool get isOrthographic =>
      projection == ViewerProjection.orthographic;

  bool get isShaded =>
      renderMode == ViewerRenderMode.shaded;

  bool get isWireframe =>
      renderMode == ViewerRenderMode.wireframe;

  bool get isSectionEnabled =>
      sectionEnabled;

  ViewerState copyWith({
    ViewerProjection? projection,
    ViewerRenderMode? renderMode,
    ViewerInteractionMode? interactionMode,
    double? rotationX,
    double? rotationY,
    double? rotationZ,
    double? zoom,
    bool? showDimensions,
    bool? showAxes,
    bool? showGrid,
    bool? sectionEnabled,
    String? sectionPlane,
    bool clearSectionPlane = false,
  }) {
    return ViewerState(
      projection:
          projection ?? this.projection,
      renderMode:
          renderMode ?? this.renderMode,
      interactionMode:
          interactionMode ?? this.interactionMode,
      rotationX:
          rotationX ?? this.rotationX,
      rotationY:
          rotationY ?? this.rotationY,
      rotationZ:
          rotationZ ?? this.rotationZ,
      zoom:
          zoom ?? this.zoom,
      showDimensions:
          showDimensions ?? this.showDimensions,
      showAxes:
          showAxes ?? this.showAxes,
      showGrid:
          showGrid ?? this.showGrid,
      sectionEnabled:
          sectionEnabled ?? this.sectionEnabled,
      sectionPlane: clearSectionPlane
          ? null
          : sectionPlane ?? this.sectionPlane,
    );
  }
}
