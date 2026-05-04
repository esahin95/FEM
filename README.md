# FEM - Finite Element Methods in MATLAB

A modular MATLAB package implementing Finite Element Methods for solving mechanical and thermal problems for solids. 
It uses OOP and a configuration-driven workflow inspired by OpenFOAM

## Project Structure

```
+FEM/
├── +App/                 # Application classes for different problem types
│   ├── @Base/           # Base class for all applications
│   ├── @Axisymmetric/   # Base axisymmetric formulation
│   ├── @AxisymmetricElastic/  # Elastic axisymmetric analysis
│   ├── @AxisymmetricSPID/     # Phase decomposition formulation
│   └── @Plane*/         # 2D plane strain and thermal problems
├── +Core/               # Core FEM components
│   ├── @FEField/        # Finite element field representation
│   ├── @FEMatrix/       # Sparse matrix assembly utilities
│   ├── @FEPatch/        # Boundary patch handling
│   ├── +Materials/      # Material models (Elastic, Hyperelastic, etc.)
|   |   ├── @Elastic     # Simple isotropic linear elastic material model
|   |   ├── @RigidViscoPlastic # Rigid visco plastic material model
|   |   ├── @Thermal     # Simple isotropic thermal material model
│   └── @FEPatch/        # Boundary condition patch classes
├── +Geom/               # Geometry and mesh management
│   ├── @FEMesh/         # Base mesh class
│   ├── @FEMesh2D/       # 2D mesh implementation
│   └── @FEQuadMesh/     # Quadrilateral element mesh
├── +Quad/               # Quadrature rules
│   ├── @Base/           # Base quadrature class
│   ├── @Quadrilateral/  # Gauss quadrature for quads
│   └── @Simpson/        # Simpson's rule integration
└── +Util/               # Utility functions
    └── readControls.m   # Configuration file parser
```

## Requirements
- MATLAB R2019b or later (uses string arrays and modern syntax)
- Basic MATLAB toolbox (no additional toolboxes required)

## Basic Workflow

The typical workflow consists of three components:

1. **Configuration File** (`controlDict`): Defines geometry, material, and solver parameters
2. **Initial Conditions** (`0/U`): Sets initial and boundary conditions
3. **Run Script**: Executes the simulation

### Configuration Dictionary Format

The `controlDict` file uses a custom format parsed by `FEM.Util.readControls`

### Initial and Boundary Condition Format

Initial conditions are defined in `0/U`:
Each entry corresponds to a spatial direction.

```
% Internal initial values
internal
{
    values  0 0;
}

% Boundary patch conditions
left
{
    types   fixedValue zeroGradient;
    values  0 0;
}

right
{
    types   zeroGradient zeroGradient;
    values  0 0;
}

top
{
    types   fixedValue fixedValue;    % Both components fixed
    values  0 -0.1;                   % Apply 0.1 unit compression
}
```

## Available Cases

### 1. **elasticCylinderCompression**
2D axisymmetric linear elastic analysis of a cylinder under compression.
- **Location**: `tutorials/elasticCylinderCompression/`
- **Problem**: Small strain compression of an isotropic, linear elastic cylinder
- **Output**: Strain and stress field visualization 

### 2. **SPIDCylinderCompression**
Simple Plastic Incremental Deformation of a cylinder. Implementation follows the book 
"Metal Forming and the Finite-Element-Method" from Kobayashi et al.
- **Location**: `tutorials/SPIDCylinderCompression/`

### 3. **solidifyingBeam**
Thermal analysis of a solidifying beam with square cross section. Latent heat release is currently modeled
as an exponentially decaying source term, hard build into PlaneThermal solver module. This is going to be changed in the future.
- **Location**: `tutorials/solidifyingBeam/`

## License

This project is provided as-is for research and educational purposes.
