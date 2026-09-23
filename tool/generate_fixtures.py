from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
FIXTURES = ROOT / 'test' / 'fixtures'
FIXTURES.mkdir(parents=True, exist_ok=True)

ents=[]
def add(body): ents.append(body); return len(ents)
ctx_app=add("APPLICATION_CONTEXT('configuration controlled 3d designs of mechanical parts and assemblies')")
ctx_apd=add(f"APPLICATION_PROTOCOL_DEFINITION('international standard','config_control_design',1994,#{ctx_app})")
ctx_des=add(f"DESIGN_CONTEXT('',#{ctx_app},'design')")
ctx_mec=add(f"PRODUCT_CONTEXT('',#{ctx_app},'mechanical')")
prod=add(f"PRODUCT('box_20','box_20','CNC-JARVIS test cube',(#{ctx_mec}))")
pdf=add(f"PRODUCT_DEFINITION_FORMATION_WITH_SPECIFIED_SOURCE('','',#{prod},.NOT_KNOWN.)")
pd=add(f"PRODUCT_DEFINITION('design','',#{pdf},#{ctx_des})")
pds=add(f"PRODUCT_DEFINITION_SHAPE('','',#{pd})")
origin=add("CARTESIAN_POINT('NONE',(0.,0.,0.))")
d_z=add("DIRECTION('NONE',(0.,0.,1.))")
d_x=add("DIRECTION('NONE',(1.,0.,0.))")
sr_axis=add(f"AXIS2_PLACEMENT_3D('NONE',#{origin},#{d_z},#{d_x})")
len_u=add("( LENGTH_UNIT() NAMED_UNIT(*) SI_UNIT(.MILLI.,.METRE.) )")
ang_u=add("( NAMED_UNIT(*) PLANE_ANGLE_UNIT() SI_UNIT($,.RADIAN.) )")
sol_u=add("( NAMED_UNIT(*) SI_UNIT($,.STERADIAN.) SOLID_ANGLE_UNIT() )")
unc=add(f"UNCERTAINTY_MEASURE_WITH_UNIT(LENGTH_MEASURE(1.E-05),#{len_u},'distance_accuracy_value','')")
gctx=add(f"( GEOMETRIC_REPRESENTATION_CONTEXT(3) GLOBAL_UNCERTAINTY_ASSIGNED_CONTEXT((#{unc})) GLOBAL_UNIT_ASSIGNED_CONTEXT((#{len_u},#{ang_u},#{sol_u})) REPRESENTATION_CONTEXT('NONE','NONE') )")
corners={'A':(0.,0.,0.),'B':(20.,0.,0.),'C':(20.,20.,0.),'D':(0.,20.,0.),'E':(0.,0.,20.),'F':(20.,0.,20.),'G':(20.,20.,20.),'H':(0.,20.,20.)}
cp_id={}; vp_id={}
for name,co in corners.items():
    cp_id[name]=add("CARTESIAN_POINT('NONE',(%s,%s,%s))"%co)
    vp_id[name]=add(f"VERTEX_POINT('NONE',#{cp_id[name]})")
dirs={}
for key,vec in [('1,0,0',(1.,0.,0.)),('-1,0,0',(-1.,0.,0.)),('0,1,0',(0.,1.,0.)),('0,-1,0',(0.,-1.,0.)),('0,0,1',(0.,0.,1.)),('0,0,-1',(0.,0.,-1.))]:
    dirs[key]=add("DIRECTION('NONE',(%s,%s,%s))"%vec)
edge_id={}
for ename,s,e,dk in [('e1','A','B','1,0,0'),('e2','B','C','0,1,0'),('e3','C','D','-1,0,0'),('e4','D','A','0,-1,0'),('e5','E','F','1,0,0'),('e6','F','G','0,1,0'),('e7','G','H','-1,0,0'),('e8','H','E','0,-1,0'),('e9','A','E','0,0,1'),('e10','B','F','0,0,1'),('e11','C','G','0,0,1'),('e12','D','H','0,0,1')]:
    ln=add(f"LINE('NONE',#{cp_id[s]},#{dirs[dk]})")
    edge_id[ename]=add(f"EDGE_CURVE('NONE',#{vp_id[s]},#{vp_id[e]},#{ln},.T.)")
def oe(eid,flag): return add(f"ORIENTED_EDGE('NONE',*,*,#{eid},.{flag}.)")
def face(flags,origin_name,zdir,xdir):
    loop=add("EDGE_LOOP('NONE',(%s))"%','.join(f"#{oe(edge_id[e],f)}" for e,f in flags))
    bound=add(f"FACE_OUTER_BOUND('NONE',#{loop},.T.)")
    ax=add(f"AXIS2_PLACEMENT_3D('NONE',#{cp_id[origin_name]},#{dirs[zdir]},#{dirs[xdir]})")
    pl=add(f"PLANE('NONE',#{ax})")
    return add(f"FACE('NONE',(#{bound}),#{pl},.T.)")
faces=[face([('e4','F'),('e3','F'),('e2','F'),('e1','F')],'A','0,0,-1','1,0,0'),face([('e5','T'),('e6','T'),('e7','T'),('e8','T')],'E','0,0,1','1,0,0'),face([('e1','T'),('e10','T'),('e5','F'),('e9','F')],'A','0,-1,0','1,0,0'),face([('e12','T'),('e7','F'),('e11','F'),('e3','T')],'D','0,1,0','-1,0,0'),face([('e2','T'),('e11','T'),('e6','F'),('e10','F')],'B','1,0,0','0,1,0'),face([('e9','T'),('e8','F'),('e12','F'),('e4','T')],'A','-1,0,0','0,1,0')]
shell=add("CLOSED_SHELL('NONE',(%s))"%','.join(f"#{f}" for f in faces))
msb=add(f"MANIFOLD_SOLID_BREP('box_20',#{shell})")
sr=add(f"SHAPE_REPRESENTATION('box_20',(#{sr_axis},#{msb}),#{gctx})")
add(f"SHAPE_DEFINITION_REPRESENTATION(#{pds},#{sr})")
step=("ISO-10303-21;\nHEADER;\nFILE_DESCRIPTION(('CNC-JARVIS test cube'),'2;1');\nFILE_NAME('box_20x20x20.step','2026-09-16T00:00:00',('CNC-JARVIS'),('CNC-JARVIS'),'CNC-JARVIS','','');\nFILE_SCHEMA(('CONFIG_CONTROL_DESIGN'));\nENDSEC;\nDATA;\n"+"\n".join(f"#{i+1}={b};" for i,b in enumerate(ents))+"\nENDSEC;\nEND-ISO-10303-21;\n")
assert set(map(int,re.findall(r'#(\d+)',step))) <= set(range(1,len(ents)+1))
(FIXTURES/'box_20x20x20.step').write_text(step,encoding='utf-8')

g=("1H,,1H;,7HMinimal,10Hminimal.,7HMinimal,5Higes5,5Higes5,32,38,6,308,15,1.0,2,2HMM,1,0.01,15H20240101.000000,1E-06,10000.,7HUnknown,7HUnknown,11,0,15HMinimal IGES;")
gl=[g[i:i+72] for i in range(0,len(g),72)]
lines=["CNC-JARVIS IGES fixture: single line entity".ljust(72)+"S      1"]
for i,x in enumerate(gl): lines.append(x.ljust(72)+"G"+str(i+1).rjust(7))
lines.append("110     "+"       1"+"       0"*5+"       0"+"00000001"+"D      1")
lines.append("110     "+"       0"+"       0"+"       1"+"       0"+"        "+"        "+"LINE    "+"       0"+"D      2")
lines.append("110,0.,0.,0.,20.,20.,20.;".ljust(72)+"P"+"1".rjust(7))
lines.append(("S      1G"+str(len(gl)).rjust(7)+"D      2P      1T      1").ljust(80))
assert all(len(x)==80 for x in lines)
(FIXTURES/'line_20mm.iges').write_text("\n".join(lines)+"\n",encoding='utf-8')
print('Fixtures generated:', FIXTURES)
