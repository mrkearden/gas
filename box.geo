SetFactory("OpenCASCADE");

L = DefineNumber[ 15.6, Name "Parameters/L" ];
//+
H = DefineNumber[ 3.5, Name "Parameters/H" ];
//+
rt = DefineNumber[ 0.21, Name "Parameters/rt" ];
//+
d = DefineNumber[ 0.7, Name "Parameters/d" ];
//+
dz = DefineNumber[ 1.0, Name "Parameters/dz" ];
//+
lt = DefineNumber[ 1.0, Name "Parameters/lt" ];

eps = rt*1e-3;

in = {0, 0, H/2-dz};
Cylinder(1) = {in(0), in(1), in(2), lt, 0, 0, rt};

Box(2) = {lt, -d, -H/2, L, L, H};

out = {L-d+lt, L-d+lt, -H/2+dz};
Cylinder(3) = {out(0), out(1), out(2), 0, -lt, 0, rt};

v = BooleanUnion {Volume{1}; Delete;} {Volume{2,3}; Delete;};

wall() = Abs(Boundary{Volume{v};});
inlet = Surface In BoundingBox {in(0)-eps, in(1)-rt-eps, in(2)-rt-eps,
                                in(0)+eps, in(1)+rt+eps, in(2)+rt+eps};
outlet = Surface In BoundingBox {out(0)-rt-eps, out(1)-eps, out(2)-rt-eps,
                                 out(0)+rt+eps, out(1)+eps, out(2)+rt+eps};
wall() -= {inlet, outlet};

Physical Surface(1) = {inlet};
Physical Surface(2) = {wall()};
Physical Surface(3) = {outlet};

Physical Volume(1) = {v};

Mesh.CharacteristicLengthFromCurvature = 1;
Mesh.MinimumCirclePoints = 6;
Mesh.CharacteristicLengthFactor = 0.3;
