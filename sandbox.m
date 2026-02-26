%% Clean workspace
% clear workspace
close all hidden
clear
clc

% set interpreter to latex
set(0,'defaultTextInterpreter','latex','defaultAxesTickLabelInterpreter','latex','defaultLegendInterpreter','latex')

%% Problem Setup

data = FEM.Util.readDict('controlDict')

mesh = FEM.Geom.FEQuadMesh(nex=data.nex, ney=data.ney, Lx=data.Lx, Ly=data.Ly);

figure(mesh.fig)