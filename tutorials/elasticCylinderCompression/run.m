%% Clean workspace
% clear workspace
close all hidden
clear
clc

% set interpreter to latex
set(0,'defaultTextInterpreter','latex','defaultAxesTickLabelInterpreter','latex','defaultLegendInterpreter','latex')

% add tutorial case file
addpath('tutorials/elasticCylinderCompression/system')

% imports
import FEM.Util.*
import FEM.Geom.*

%% Problem Setup

data = readControls();

mesh = FEQuadMesh(data.geometry);

figure(mesh.fig)