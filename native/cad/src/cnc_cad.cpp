#include "../include/cnc_cad.h"

#include <BRepCheck_Analyzer.hxx>
#include <BRepMesh_IncrementalMesh.hxx>
#include <IGESControl_Reader.hxx>
#include <STEPControl_Reader.hxx>
#include <Standard_Failure.hxx>
#include <TopExp_Explorer.hxx>
#include <TopAbs_ShapeEnum.hxx>
#include <TopoDS_Shape.hxx>
#include <TopoDS_Face.hxx>
#include <BRep_Tool.hxx>
#include <Poly_Triangulation.hxx>
#include <Poly_Triangle.hxx>
#include <TopLoc_Location.hxx>
#include <gp_Pnt.hxx>

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <map>
#include <string>
#include <tuple>
#include <vector>

namespace {

struct MeshData {
    std::vector<float> positions;
    std::vector<int> indices;
    void clear() { positions.clear(); indices.clear(); }
};

struct CadState {
    bool initialized = false;
    bool modelLoaded = false;
    TopoDS_Shape shape;
    int bodyCount = 0;
    int solidCount = 0;
    int surfaceCount = 0;
    MeshData mesh;
};

CadState& state() {
    static CadState instance;
    return instance;
}

void clearShapeData() {
    auto& cad = state();
    cad.modelLoaded = false;
    cad.shape.Nullify();
    cad.bodyCount = 0;
    cad.solidCount = 0;
    cad.surfaceCount = 0;
    cad.mesh.clear();
}

void calculateTopology() {
    auto& cad = state();
    cad.bodyCount = cad.solidCount = cad.surfaceCount = 0;
    if (cad.shape.IsNull()) return;
    for (TopExp_Explorer it(cad.shape, TopAbs_SOLID); it.More(); it.Next()) ++cad.solidCount;
    for (TopExp_Explorer it(cad.shape, TopAbs_FACE); it.More(); it.Next()) ++cad.surfaceCount;
    cad.bodyCount = cad.solidCount > 0 ? cad.solidCount : (cad.surfaceCount > 0 ? 1 : 0);
}

int validateAndStoreShape(const TopoDS_Shape& shape) {
    if (shape.IsNull()) return -10;
    BRepCheck_Analyzer analyzer(shape);
    if (!analyzer.IsValid()) return -11;
    auto& cad = state();
    cad.shape = shape;
    cad.modelLoaded = true;
    calculateTopology();
    cad.mesh.clear();
    return 0;
}

int importStepInternal(const char* path) {
    if (!path || path[0] == '\0') return -1;
    auto& cad = state();
    if (!cad.initialized) return -2;
    try {
        STEPControl_Reader reader;
        const auto status = reader.ReadFile(path);
        if (status != IFSelect_RetDone && status != IFSelect_RetVoid) return -20;
        if (reader.TransferRoots() <= 0) return -21;
        return validateAndStoreShape(reader.OneShape());
    } catch (const Standard_Failure&) { return -22; } catch (...) { return -23; }
}

int importIgesInternal(const char* path) {
    if (!path || path[0] == '\0') return -1;
    auto& cad = state();
    if (!cad.initialized) return -2;
    try {
        IGESControl_Reader reader;
        if (reader.ReadFile(path) != IFSelect_RetDone) return -30;
        reader.TransferRoots();
        return validateAndStoreShape(reader.OneShape());
    } catch (const Standard_Failure&) { return -31; } catch (...) { return -32; }
}

using Key = std::tuple<long long, long long, long long>;

Key pointKey(const gp_Pnt& p) {
    constexpr double scale = 1000000000.0;
    return {static_cast<long long>(std::llround(p.X() * scale)),
            static_cast<long long>(std::llround(p.Y() * scale)),
            static_cast<long long>(std::llround(p.Z() * scale))};
}

int addPoint(std::map<Key, int>& vertexMap, const gp_Pnt& point) {
    const auto key = pointKey(point);
    const auto found = vertexMap.find(key);
    if (found != vertexMap.end()) return found->second;
    const int index = static_cast<int>(state().mesh.positions.size() / 3);
    state().mesh.positions.push_back(static_cast<float>(point.X()));
    state().mesh.positions.push_back(static_cast<float>(point.Y()));
    state().mesh.positions.push_back(static_cast<float>(point.Z()));
    vertexMap.emplace(key, index);
    return index;
}

} // namespace

extern "C" {

int cnc_cad_initialize(void) {
    auto& cad = state();
    clearShapeData();
    cad.initialized = true;
    return 0;
}

int cnc_cad_import_step(const char* path) { return importStepInternal(path); }
int cnc_cad_import_iges(const char* path) { return importIgesInternal(path); }

int cnc_cad_body_count(void) { return state().modelLoaded ? state().bodyCount : 0; }
int cnc_cad_solid_count(void) { return state().modelLoaded ? state().solidCount : 0; }
int cnc_cad_surface_count(void) { return state().modelLoaded ? state().surfaceCount : 0; }

void cnc_cad_clear(void) { clearShapeData(); }

void cnc_cad_shutdown(void) {
    auto& cad = state();
    clearShapeData();
    cad.initialized = false;
}

int cnc_cad_tessellate(double deflection) {
    auto& cad = state();
    if (!cad.initialized) return -1;
    if (!cad.modelLoaded || cad.shape.IsNull()) return -2;
    if (!(deflection > 0.0) || !std::isfinite(deflection)) return -3;

    try {
        cad.mesh.clear();
        BRepMesh_IncrementalMesh mesher(cad.shape, deflection, false, 0.5, true);
        if (!mesher.IsDone()) return -3;

        std::map<Key, int> vertexMap;
        for (TopExp_Explorer explorer(cad.shape, TopAbs_FACE); explorer.More(); explorer.Next()) {
            const TopoDS_Face face = TopoDS::Face(explorer.Current());
            TopLoc_Location location;
            const Handle(Poly_Triangulation) triangulation = BRep_Tool::Triangulation(face, location);
            if (triangulation.IsNull()) continue;

            const auto transformation = location.Transformation();
            const auto& nodes = triangulation->Nodes();
            const auto& triangles = triangulation->Triangles();

            for (int i = 1; i <= triangles.Length(); ++i) {
                Standard_Integer n1 = 0, n2 = 0, n3 = 0;
                triangles.Value(i).Get(n1, n2, n3);
                gp_Pnt p1 = nodes.Value(n1).Transformed(transformation);
                gp_Pnt p2 = nodes.Value(n2).Transformed(transformation);
                gp_Pnt p3 = nodes.Value(n3).Transformed(transformation);

                const int i1 = addPoint(vertexMap, p1);
                const int i2 = addPoint(vertexMap, p2);
                const int i3 = addPoint(vertexMap, p3);

                if (face.Orientation() == TopAbs_REVERSED) {
                    cad.mesh.indices.push_back(i1);
                    cad.mesh.indices.push_back(i3);
                    cad.mesh.indices.push_back(i2);
                } else {
                    cad.mesh.indices.push_back(i1);
                    cad.mesh.indices.push_back(i2);
                    cad.mesh.indices.push_back(i3);
                }
            }
        }
        return cad.mesh.indices.empty() ? -4 : 0;
    } catch (const Standard_Failure&) { return -5; } catch (...) { return -6; }
}

int cnc_cad_mesh_counts(int* vertexCount, int* triangleCount) {
    if (!vertexCount || !triangleCount) return -3;
    const auto& cad = state();
    if (!cad.modelLoaded) return -1;
    *vertexCount = static_cast<int>(cad.mesh.positions.size() / 3);
    *triangleCount = static_cast<int>(cad.mesh.indices.size() / 3);
    return 0;
}

int cnc_cad_export_mesh(float* positions, int positionCapacity, int* indices, int indexCapacity) {
    const auto& cad = state();
    if (!cad.modelLoaded) return -1;
    if (!positions || !indices) return -3;
    if (positionCapacity < static_cast<int>(cad.mesh.positions.size()) ||
        indexCapacity < static_cast<int>(cad.mesh.indices.size())) return -2;
    std::copy(cad.mesh.positions.begin(), cad.mesh.positions.end(), positions);
    std::copy(cad.mesh.indices.begin(), cad.mesh.indices.end(), indices);
    return 0;
}

} // extern "C"
