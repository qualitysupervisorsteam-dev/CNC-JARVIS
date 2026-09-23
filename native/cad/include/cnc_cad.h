#ifndef CNC_CAD_H
#define CNC_CAD_H

#ifdef __cplusplus
extern "C" {
#endif

int cnc_cad_initialize(void);
int cnc_cad_import_step(const char* path);
int cnc_cad_import_iges(const char* path);
int cnc_cad_body_count(void);
int cnc_cad_solid_count(void);
int cnc_cad_surface_count(void);
void cnc_cad_clear(void);
void cnc_cad_shutdown(void);

int cnc_cad_tessellate(double deflection);
int cnc_cad_mesh_counts(int* vertexCount, int* triangleCount);
int cnc_cad_export_mesh(float* positions, int positionCapacity, int* indices, int indexCapacity);

#ifdef __cplusplus
}
#endif

#endif /* CNC_CAD_H */
