%% Clean workspace
% clear workspace
close all hidden
clear
clc

% set interpreter to latex
set(0,'defaultTextInterpreter','latex','defaultAxesTickLabelInterpreter','latex','defaultLegendInterpreter','latex')

% add tutorial case file
% addpath(genpath('tutorials/elasticCylinderCompression'))

% imports
import FEM.Util.*
import FEM.Geom.*
import FEM.App.*

%% Problem Setup

data = readControls();

fe = FEProblem(data);

figure(fe.msh.fig)