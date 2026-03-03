%% Clean workspace
% clear workspace
close all hidden
clear
clc

% set interpreter to latex
set(0,'defaultTextInterpreter','latex','defaultAxesTickLabelInterpreter','latex','defaultLegendInterpreter','latex')

% add tutorial case file
addpath(genpath('tutorials/elasticCylinderCompression'))

% imports
import FEM.Util.readControls
import FEM.App.Elastic

%% Problem Setup

data = readControls();

fe = Elastic(data);

fe.mesh.show()

clim([0 0.5])

fe.run()