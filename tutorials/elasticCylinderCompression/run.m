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
import FEM.App.AxisymmetricElastic

%% Problem Setup
data = readControls();

fe = AxisymmetricElastic(data);

xlim([0 1.5])
ylim([0 1.2])
clim([0 0.5])

fe.mesh.show()

fe.run()