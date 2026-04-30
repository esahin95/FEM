%% Clean workspace
% clear workspace
close all hidden
clear
clc

% set interpreter to latex
set(0,'defaultTextInterpreter','latex','defaultAxesTickLabelInterpreter','latex','defaultLegendInterpreter','latex')

% add tutorial case file
addpath(genpath('tutorials/solidifyingBeam'))

% imports
import FEM.Util.readControls
import FEM.App.PlaneThermal

%% Problem Setup
data = readControls();

fe = PlaneThermal(data);

xlim([0 1.1])
ylim([0 1.1])
clim([0 0.3])

fe.mesh.show()

%fe.run()