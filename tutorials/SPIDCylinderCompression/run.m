%% Clean workspace
% clear workspace
close all hidden
clear
clc

% set interpreter to latex
set(0,'defaultTextInterpreter','latex','defaultAxesTickLabelInterpreter','latex','defaultLegendInterpreter','latex')

% add tutorial case file
addpath(genpath('tutorials/SPIDcylinderCompression'))

% imports
import FEM.Util.readControls
import FEM.App.AxisymmetricSPID

%% Problem Setup
data = readControls();

fe = AxisymmetricSPID(data);

xlim([0 1.5])
ylim([0 1.2])
clim([0 3])

fe.mesh.show()

fe.run()