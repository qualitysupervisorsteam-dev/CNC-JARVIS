#include "../include/cnc_cad.h"

#include <cassert>
#include <cstdio>
#include <vector>

int main(int argc, char** argv) {
    assert(cnc_cad_initialize() == 0);
    assert(cnc_cad_body_count() == 0);
    assert(cnc_cad_solid_count() == 0);
    assert(cnc_cad_surface_count() == 0);
    cnc_cad_shutdown();

    if (argc > 1) {
        assert(cnc_cad_initialize() == 0);
        assert(cnc_cad_import_step(argv[1]) == 0);
        assert(cnc_cad_body_count() == 1);
        assert(cnc_cad_solid_count() == 1);
        assert(cnc_cad_surface_count() == 6);
        assert(cnc_cad_tessellate(0.5) == 0);
        int vertexCount = 0;
        int triangleCount = 0;
        assert(cnc_cad_mesh_counts(&vertexCount, &triangleCount) == 0);
        assert(vertexCount == 8);
        assert(triangleCount == 12);
        std::vector<float> positions(static_cast<size_t>(vertexCount) * 3);
        std::vector<int> indices(static_cast<size_t>(triangleCount) * 3);
        assert(cnc_cad_export_mesh(positions.data(), static_cast<int>(positions.size()),
                                   indices.data(), static_cast<int>(indices.size())) == 0);
        cnc_cad_shutdown();
        std::printf("CNC CAD fixture test passed.\n");
    }
    return 0;
}
