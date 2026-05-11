# FEM - Finite Element Methods in MATLAB

A modular MATLAB package implementing Finite Element Methods for solving mechanical and thermal problems for solids.
Uses Opbject-Oriented Programming and a configuration-driven workflow inspired by OpenFOAM. Written for teaching purposes.

## Requirements
- MATLAB R2019b or later with no additional toolboxes

## Basic Workflow

The typical workflow consists of three components:

1. **Configuration File** (`controlDict`): Defines geometry, material, and solver parameters
2. **Initial Conditions** (`0/U`): Sets initial and boundary conditions
3. **Run Script**: Executes the simulation. Must be run with the FEM directory on path.

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
