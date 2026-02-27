%% Clean workspace
% clear workspace
close all hidden
clear
clc

% set interpreter to latex
set(0,'defaultTextInterpreter','latex','defaultAxesTickLabelInterpreter','latex','defaultLegendInterpreter','latex')

% add FEM namespace
addpath('../../')

% imports
import FEM.Util.*
import FEM.Geom.*

%% Problem Setup

data = readControls();

mesh = FEQuadMesh(data.geometry);

figure(mesh.fig)