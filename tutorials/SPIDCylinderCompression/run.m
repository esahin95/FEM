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
import FEM.App.SPID

%% Problem Setup

data = readControls();

fe = SPID(data);

fe.mesh.show()

clim([0 3])

fe.run()