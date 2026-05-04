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

xlim([0 0.6])
ylim([0 0.6])
clim([0 0.3])

fe.mesh.show()

fe.run()

%% Comparison
% extract numerical solution
D = fe.TCorner;
t = D(1,:);
Tnum = D(2,:);

% analytical solution
L = 1;
x = 0.5 * L; 
y = 0.5 * L;

c1 = 1;
c2 = 1;

Tana = zeros(size(t));
nMax = 12;
for i = 1:2:nMax
    for j = 1:2:nMax
        fac = 16 * c1 / pi^2 / i / j;
        lam = fe.mat.alpha * pi^2 / L^2 * (i^2 + j^2);
        if fac == lam
            bet = fac .* t .* exp(-c2 * t);
        else
            bet = fac / (lam - c2) * (exp(-c2 * t) - exp(-lam * t));
        end
        psi = sin(i*pi*x/L) * sin(j*pi*y/L);
        Tana = Tana + bet * psi;
    end
end

figure()
plot(t, Tana, 'k')
hold on
plot(t, Tnum, 'ob')

max(Tana)
max(Tnum)