%% Miniproject - Chan Vese segmentation, a probabilistic approach
%  The following exercise is carried out as part of the course 
%  02506 Advanced Image Analysis (Spring, 2021), at the Technical 
%  University of Denmark (DTU).
%
%  Authors : Mario Corral Bolaños & Sheyla Barrado Ballestero

close all
clear, clc

addpath('probabilistic_data', genpath('functions'));

%% Ex1: Histogram-based probabilities
ex11 % Two differentiated distributions
ex12 % Two overlapping distributions
ex13 % Two similar distributions

%% Ex2: Patched-based probabilities - Using all patches
ex21 % Two differentiated distributions
ex22 % Natural image in RGB transformed to a single channel - Starfish
ex23 % Using the 3 channels in the dictionary - Snow leopard

%% Ex3: Patched-based probabilities - Using some patches
ex31 % Snow leopard

%% Ex4: Multi-patch approach
ex41